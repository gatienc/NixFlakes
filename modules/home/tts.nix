{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  home.packages = with pkgs; [
    piper-tts
    espeak-ng # fallback, very fast
  ];

  programs.zsh.shellAliases = {
    # Text-to-speech aliases
    say = "piper-tts --model ~/tts-voices/en_US-lessac-medium.onnx --output-raw | aplay -r 22050 -f S16_LE -t raw -";
    speak = "xargs -I {} piper-tts --model ~/tts-voices/en_US-lessac-medium.onnx --output-raw <<< '{}' | aplay -r 22050 -f S16_LE -t raw -";
    tts = ''echo "Usage: echo 'hello' | tts" && cat | piper-tts --model ~/tts-voices/en_US-lessac-medium.onnx --output-raw | aplay -r 22050 -f S16_LE -t raw -'';
  };

  # Create voices directory on first login
  home.activation.piperVoices = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/tts-voices

    # Download voice if not present
    if [ ! -f ~/tts-voices/en_US-lessac-medium.onnx ]; then
      echo "Downloading piper voice model..."
      ${pkgs.curl}/bin/curl -L \
        "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx" \
        -o ~/tts-voices/en_US-lessac-medium.onnx
      ${pkgs.curl}/bin/curl -L \
        "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json" \
        -o ~/tts-voices/en_US-lessac-medium.onnx.json
    fi
  '';
}
