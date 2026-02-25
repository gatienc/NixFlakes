{
  pkgs,
  lib,
  config,
  ...
}:
let
  blueLightStrengthFile = "$HOME/.config/hypr/blue-light-strength";
  blueLightTemperatureFile = "$HOME/.config/hypr/blue-light-temperature";
  blueLightLuminanceFile = "$HOME/.config/hypr/blue-light-luminance";
  blueLightShaderPath = "$HOME/.config/hypr/shaders/blue-light-filter.glsl";
  blueLightTemplate =
    pkgs.writeText "blue-light-filter.glsl.template" ''
      #version 300 es
      precision mediump float;

      in vec2 v_texcoord;
      uniform sampler2D tex;
      layout(location = 0) out vec4 fragColor;

      const float Temperature = __TEMPERATURE__;
      const float Strength = __STRENGTH__;
      const float LuminancePreservationFactor = __LUMINANCE__;

      vec3 colorTemperatureToRGB(const in float temperature) {
        mat3 m = (temperature <= 6500.0)
          ? mat3(vec3(0.0, -2902.1955373783176, -8257.7997278925690),
                 vec3(0.0, 1669.5803561666639, 2575.2827530017594),
                 vec3(1.0, 1.3302673723350029, 1.8993753891711275))
          : mat3(vec3(1745.0425298314172, 1216.6168361476490, -8257.7997278925690),
                 vec3(-2666.3474220535695, -2173.1012343082230, 2575.2827530017594),
                 vec3(0.55995389139931482, 0.70381203140554553, 1.8993753891711275));

        return mix(
          clamp(m[0] / (vec3(clamp(temperature, 1000.0, 40000.0)) + m[1]) + m[2], 0.0, 1.0),
          vec3(1.0),
          smoothstep(1000.0, 0.0, temperature)
        );
      }

      void main() {
        vec4 pixColor = texture(tex, v_texcoord);
        vec3 color = pixColor.rgb;

        float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
        color *= mix(1.0, lum / max(lum, 1e-5), LuminancePreservationFactor);

        color = mix(color, color * colorTemperatureToRGB(Temperature), Strength);

        fragColor = vec4(color, pixColor.a);
      }
    ''
    + "\n";
  blueLightApply = pkgs.writeShellScriptBin "blue-light-filter-apply" ''
    strength_file="${blueLightStrengthFile}"
    temperature_file="${blueLightTemperatureFile}"
    luminance_file="${blueLightLuminanceFile}"
    shader_path="${blueLightShaderPath}"
    template="$(printf '%s' "${blueLightTemplate}" | tr -d '\n\r' | sed 's/[[:space:]]*$//')"
    mkdir -p "$(dirname "$shader_path")"
    [ ! -f "$strength_file" ] && echo "0.8" > "$strength_file"
    [ ! -f "$temperature_file" ] && echo "2600" > "$temperature_file"
    [ ! -f "$luminance_file" ] && echo "1.0" > "$luminance_file"
    strength=$(cat "$strength_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    temperature=$(cat "$temperature_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<1000)v=1000; if(v>40000)v=40000; printf "%.1f", v }')
    luminance=$(cat "$luminance_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    echo "$strength" > "$strength_file"; echo "$temperature" > "$temperature_file"; echo "$luminance" > "$luminance_file"
    tmp_shader="''${shader_path}.tmp.$$"
    ${pkgs.gnused}/bin/sed -e "s/__STRENGTH__/$strength/" -e "s/__TEMPERATURE__/$temperature/" -e "s/__LUMINANCE__/$luminance/" "$template" > "$tmp_shader"
    mv -f "$tmp_shader" "$shader_path"
    hyprshade on "$shader_path"
  '';
  blueLightDebug = pkgs.writeShellScriptBin "blue-light-filter-debug" ''
    set -e
    strength_file="${blueLightStrengthFile}"
    temperature_file="${blueLightTemperatureFile}"
    luminance_file="${blueLightLuminanceFile}"
    shader_path="${blueLightShaderPath}"
    template="$(printf '%s' "${blueLightTemplate}" | tr -d '\n\r' | sed 's/[[:space:]]*$//')"
    mkdir -p "$(dirname "$shader_path")"
    [ ! -f "$strength_file" ] && echo "0.8" > "$strength_file"
    [ ! -f "$temperature_file" ] && echo "2600" > "$temperature_file"
    [ ! -f "$luminance_file" ] && echo "1.0" > "$luminance_file"
    strength=$(cat "$strength_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    temperature=$(cat "$temperature_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<1000)v=1000; if(v>40000)v=40000; printf "%.1f", v }')
    luminance=$(cat "$luminance_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    echo "=== Strength: $strength Temperature: $temperature Luminance: $luminance ==="
    echo "=== Template path: $template ==="
    echo "=== Shader output path: $shader_path ==="
    ${pkgs.gnused}/bin/sed -e "s/__STRENGTH__/$strength/" -e "s/__TEMPERATURE__/$temperature/" -e "s/__LUMINANCE__/$luminance/" "$template" > "$shader_path"
    echo "=== Generated shader content ==="
    cat "$shader_path"
    echo "=== End of shader ==="
    echo "=== Running: hyprshade on $shader_path ==="
    hyprshade on "$shader_path" 2>&1 || true
    echo "=== hyprshade exit code: $? ==="
  '';
  blueLightAdjust = pkgs.writeShellScriptBin "blue-light-filter-adjust" ''
    delta="''${1:-0.1}"
    strength_file="${blueLightStrengthFile}"
    temperature_file="${blueLightTemperatureFile}"
    luminance_file="${blueLightLuminanceFile}"
    shader_path="${blueLightShaderPath}"
    template="$(printf '%s' "${blueLightTemplate}" | tr -d '\n\r' | sed 's/[[:space:]]*$//')"
    [ ! -f "$strength_file" ] && echo "0.8" > "$strength_file"
    [ ! -f "$temperature_file" ] && echo "2600" > "$temperature_file"
    [ ! -f "$luminance_file" ] && echo "1.0" > "$luminance_file"
    current=$(cat "$strength_file" | sed 's/,/./')
    new=$(echo "$current $delta" | ${pkgs.gawk}/bin/awk '{ v=$1+$2; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    echo "$new" > "$strength_file"
    temperature=$(cat "$temperature_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<1000)v=1000; if(v>40000)v=40000; printf "%.1f", v }')
    luminance=$(cat "$luminance_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<0)v=0; if(v>1)v=1; printf "%.2f", v }')
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"blue-light-filter"* ]]; then
      mkdir -p "$(dirname "$shader_path")"
      tmp_shader="''${shader_path}.tmp.$$"
      ${pkgs.gnused}/bin/sed -e "s/__STRENGTH__/$new/" -e "s/__TEMPERATURE__/$temperature/" -e "s/__LUMINANCE__/$luminance/" "$template" > "$tmp_shader"
      mv -f "$tmp_shader" "$shader_path"
      hyprshade on "$shader_path"
      pct=$(echo "$new" | ${pkgs.gawk}/bin/awk '{ printf "%.0f", $1*100 }')
      notify-send 'Blue Light Filter' "Strength: $pct%" 2>/dev/null || true
    fi
  '';
  blueLightStrengthStatus = pkgs.writeShellScriptBin "blue-light-filter-strength" ''
    strength_file="${blueLightStrengthFile}"
    if [ ! -f "$strength_file" ]; then echo "0.8"; else cat "$strength_file"; fi
  '';
  blueLightSlider = pkgs.writeShellScriptBin "blue-light-filter-slider" ''
    strength_file="${blueLightStrengthFile}"
    temperature_file="${blueLightTemperatureFile}"
    luminance_file="${blueLightLuminanceFile}"
    shader_path="${blueLightShaderPath}"
    template="$(printf '%s' "${blueLightTemplate}" | tr -d '\n\r' | sed 's/[[:space:]]*$//')"
    [ ! -f "$strength_file" ] && echo "0.8" > "$strength_file"
    [ ! -f "$temperature_file" ] && echo "2600" > "$temperature_file"
    [ ! -f "$luminance_file" ] && echo "1.0" > "$luminance_file"
    temp_val=$(cat "$temperature_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<1000)v=1000; if(v>40000)v=40000; printf "%.0f", v }')
    str_val=$(cat "$strength_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ printf "%.0f", $1*100 }')
    lum_val=$(cat "$luminance_file" | sed 's/,/./' | ${pkgs.gawk}/bin/awk '{ printf "%.0f", $1*100 }')
    result=$(${pkgs.yad}/bin/yad --title="Blue Light Filter" --window-icon=preferences-color \
      --form --separator="|" \
      --field="Temperature (K):NUM" "''${temp_val}!1000..40000!100!0" \
      --field="Strength (%):SCL" "$str_val" \
      --field="Luminance preservation (%):SCL" "$lum_val" \
      2>/dev/null) || exit 0
    [ -z "$result" ] && exit 0
    temperature=$(echo "$result" | ${pkgs.gawk}/bin/awk -F'|' '{ print $1 }' | ${pkgs.gawk}/bin/awk '{ v=$1; if(v<1000)v=1000; if(v>40000)v=40000; printf "%.1f", v }')
    strength_pct=$(echo "$result" | ${pkgs.gawk}/bin/awk -F'|' '{ print $2 }')
    lum_pct=$(echo "$result" | ${pkgs.gawk}/bin/awk -F'|' '{ print $3 }')
    strength=$(echo "$strength_pct" | ${pkgs.gawk}/bin/awk '{ printf "%.2f", $1/100 }')
    luminance=$(echo "$lum_pct" | ${pkgs.gawk}/bin/awk '{ printf "%.2f", $1/100 }')
    echo "$strength" > "$strength_file"
    echo "$temperature" > "$temperature_file"
    echo "$luminance" > "$luminance_file"
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"blue-light-filter"* ]]; then
      mkdir -p "$(dirname "$shader_path")"
      tmp_shader="''${shader_path}.tmp.$$"
      ${pkgs.gnused}/bin/sed -e "s/__STRENGTH__/$strength/" -e "s/__TEMPERATURE__/$temperature/" -e "s/__LUMINANCE__/$luminance/" "$template" > "$tmp_shader"
      mv -f "$tmp_shader" "$shader_path"
      hyprshade on "$shader_path"
    fi
    notify-send 'Blue Light Filter' "Temp: $temperature K | Strength: $strength_pct % | Luminance: $lum_pct %" 2>/dev/null || true
  '';
in
{
  config.home.packages = [
    blueLightApply
    blueLightAdjust
    blueLightStrengthStatus
    blueLightSlider
    blueLightDebug
    pkgs.yad
  ];
}
