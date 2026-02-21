{
  pkgs,
  lib,
  config,
  ...
}:
let
  readingModePaperBlueFile = "$HOME/.config/hypr/reading-mode-paper-blue";
  readingModeInvertFile = "$HOME/.config/hypr/reading-mode-invert";
  readingModeShaderPath = "$HOME/.config/hypr/shaders/reading_mode.glsl";
  readingModeTemplate =
    pkgs.writeText "reading_mode.glsl.template" ''
      /*
         Original source: https://github.com/snes19xx/surface-dots/blob/main/.config/hypr/shaders/reading_mode.glsl
         Author: https://github.com/snes19xx
      */

      #version 300 es

      /*
         I love e-ink displays!
         The mathematical philosophy here is using deterministic logic (Bayer matrices, arithmetic hashing)
         to simulate physical chaos (paper grain, ink bleed). I picked up these concepts in a course
         and this is easily the best real-world application of them I've found.
         It works brilliantly-looks like real paper, killed my eye strain, and even reduced the insane
         reflections from my glossy surface display.
      */

      precision highp float;
      in vec2 v_texcoord;
      uniform sampler2D tex;
      out vec4 fragColor;

      // 4x4 Bayer Matrix
      float getBayer(vec2 pos) {
          int x = int(mod(pos.x, 4.0));
          int y = int(mod(pos.y, 4.0));
          const mat4 bayer = mat4(0.0, 12.0, 3.0, 15.0, 8.0, 4.0, 11.0, 7.0, 2.0, 14.0, 1.0, 13.0, 10.0, 6.0, 9.0, 5.0);
          return bayer[x][y] / 16.0;
      }

      float hash(vec2 p) {
          vec3 p3 = fract(vec3(p.xyx) * .1031);
          p3 += dot(p3, p3.yzx + 33.33);
          return fract((p3.x + p3.y) * p3.z);
      }

      float paperTexture(vec2 uv) {
          float n = 0.0;
          n += hash(uv * 0.3) * 0.6;
          n += hash(uv * 0.8) * 0.4;
          n += hash(uv * 2.5) * 0.3;
          n += hash(uv * 6.0) * 0.2;
          n += hash(uv * 15.0) * 0.1;
          return n / 1.6;
      }

      float directionalGrain(vec2 uv) {
          vec2 direction = vec2(0.7, 0.3);
          float grain = 0.0;
          grain += hash(uv * 3.0 + direction * 2.0) * 0.5;
          grain += hash(uv * 8.0 + direction * 5.0) * 0.3;
          return grain / 0.8;
      }

      float vignette(vec2 uv) {
          vec2 center = uv - 0.5;
          float dist = length(center);
          return 1.0 - smoothstep(0.4, 1.2, dist) * 0.15;
      }

      void main() {
          vec4 pixColor = texture(tex, v_texcoord);
          float gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));
          gray = pow(gray, 1.2);
          gray = smoothstep(0.08, 0.92, gray);
          float midBoost = smoothstep(0.3, 0.5, gray) * (1.0 - smoothstep(0.5, 0.7, gray));
          gray += midBoost * 0.1;
          vec2 screenPos = gl_FragCoord.xy;
          float paperGrain = (paperTexture(screenPos * 0.3) - 0.5) * 0.035;
          float dirGrain = (directionalGrain(screenPos * 0.4) - 0.5) * 0.025;
          float bayerValue = getBayer(screenPos);
          float textureMask = smoothstep(0.5, 0.95, gray);
          gray += paperGrain * textureMask;
          gray += dirGrain * textureMask * 0.7;
          float ditherStrength = 0.025;
          gray += (bayerValue - 0.5) * ditherStrength * textureMask;
          float vig = vignette(v_texcoord);
          gray *= vig;
          gray = clamp(gray, 0.0, 1.0);
          vec3 paperColor = vec3(0.94, 0.92, __PAPER_BLUE__);
          vec3 inkColor = vec3(0.10, 0.10, 0.12);
          float colorVariation = hash(screenPos * 0.08) * 0.02;
          paperColor += vec3(colorVariation, colorVariation * 0.5, -colorVariation * 0.2);
          float invert = __INVERT__;
          vec3 finalColor = (invert > 0.5) ? mix(paperColor, inkColor, gray) : mix(inkColor, paperColor, gray);
          fragColor = vec4(finalColor, pixColor.a);
      }
    ''
    + "\n";
  readingModeApply = pkgs.writeShellScriptBin "reading-mode-apply" ''
    paper_blue_file="${readingModePaperBlueFile}"
    invert_file="${readingModeInvertFile}"
    shader_path="${readingModeShaderPath}"
    template="$(printf '%s' "${readingModeTemplate}" | tr -d '\n\r' | ${pkgs.gnused}/bin/sed 's/[[:space:]]*$//')"
    mkdir -p "$(dirname "$shader_path")"
    [ ! -f "$paper_blue_file" ] && echo "0.86" > "$paper_blue_file"
    [ ! -f "$invert_file" ] && echo "0" > "$invert_file"
    paper_blue=$(cat "$paper_blue_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    invert=$(cat "$invert_file" | ${pkgs.gawk}/bin/awk '{ v=($1+0); printf "%.1f", (v!=0)?1.0:0.0 }')
    echo "$paper_blue" > "$paper_blue_file"
    echo "$( [ "$invert" = "1.0" ] && echo 1 || echo 0 )" > "$invert_file"
    tmp_shader="''${shader_path}.tmp.$$"
    ${pkgs.gnused}/bin/sed -e "s/__PAPER_BLUE__/$paper_blue/" -e "s/__INVERT__/$invert/" "$template" > "$tmp_shader"
    mv -f "$tmp_shader" "$shader_path"
    hyprshade on "$shader_path"
  '';
  readingModeAdjust = pkgs.writeShellScriptBin "reading-mode-adjust" ''
    paper_blue_file="${readingModePaperBlueFile}"
    invert_file="${readingModeInvertFile}"
    shader_path="${readingModeShaderPath}"
    template="$(printf '%s' "${readingModeTemplate}" | tr -d '\n\r' | ${pkgs.gnused}/bin/sed 's/[[:space:]]*$//')"
    [ ! -f "$paper_blue_file" ] && echo "0.86" > "$paper_blue_file"
    [ ! -f "$invert_file" ] && echo "0" > "$invert_file"
    current_blue=$(cat "$paper_blue_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    current_invert=$(cat "$invert_file" | ${pkgs.gawk}/bin/awk '{ v=($1+0); print (v!=0)?"TRUE":"FALSE" }')
    result=$(${pkgs.yad}/bin/yad --title="Reading Mode" --window-icon=preferences-color \
      --form --separator="|" \
      --field="Paper blue (0.0–1.0):NUM" "''${current_blue}!0..1!0.01!2" \
      --field="Invert (dark background):CHK" "$current_invert" \
      2>/dev/null) || exit 0
    [ -z "$result" ] && exit 0
    paper_blue=$(echo "$result" | ${pkgs.gawk}/bin/awk -F'|' '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    invert_chk=$(echo "$result" | ${pkgs.gawk}/bin/awk -F'|' '{ print $2 }')
    invert=$( [ "$invert_chk" = "TRUE" ] && echo "1.0" || echo "0.0" )
    invert_raw=$( [ "$invert_chk" = "TRUE" ] && echo "1" || echo "0" )
    echo "$paper_blue" > "$paper_blue_file"
    echo "$invert_raw" > "$invert_file"
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"reading_mode"* ]]; then
      mkdir -p "$(dirname "$shader_path")"
      tmp_shader="''${shader_path}.tmp.$$"
      ${pkgs.gnused}/bin/sed -e "s/__PAPER_BLUE__/$paper_blue/" -e "s/__INVERT__/$invert/" "$template" > "$tmp_shader"
      mv -f "$tmp_shader" "$shader_path"
      hyprshade on "$shader_path"
    fi
    invert_msg=$( [ "$invert_chk" = "TRUE" ] && echo "inverted" || echo "normal" )
    notify-send 'Reading Mode' "Paper blue: $paper_blue | $invert_msg" 2>/dev/null || true
  '';
in
{
  config.home.packages = [
    readingModeApply
    readingModeAdjust
  ];
}
