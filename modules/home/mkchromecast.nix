{ lib, stdenv, python3, fetchFromGitHub, ffmpeg, nodejs, which, yt-dlp }:

python3.pkgs.buildPythonApplication rec {
  pname = "mkchromecast";
  version = "0.3.8.1-unstable-2025-05-14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "muammar";
    repo = "mkchromecast";
    rev = "6de38e8bcac64ed2dc52031b1b45c5d9a60e0503";
    hash = "sha256-whAV6Z4mKY/ZSznERuD8VDvpr3T9FnfFvR1oVSB5bjA=";
  };

  postPatch = ''
    substituteInPlace mkchromecast/cast.py \
      --replace-fail "media_controller.play()" "media_controller.play(timeout=30.0)"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    pychromecast
    flask
    psutil
    mutagen
    netifaces
    requests
    pyqt5
  ] ++ lib.optionals stdenv.isLinux [ pygobject3 soco ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg nodejs which yt-dlp ]}"
  ];

  meta = with lib; {
    description = "Cast macOS/Linux audio/video to Google Cast and Sonos devices";
    homepage = "https://mkchromecast.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
