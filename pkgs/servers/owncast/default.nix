{ lib, buildGoModule, fetchFromGitHub, bash, which, ffmpeg, makeWrapper, ... }:

buildGoModule rec {

  pname = "owncast";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    sha256 = "0md4iafa767yxkwh6z8zpcjv9zd79ql2wapx9vzyd973ksvrdaw2";
  };

  vendorSha256 = "sha256-bH2CWIgpOS974/P98n0R9ebGTJ0YoqPlH8UmxSYNHeM=";

  propagatedBuildInputs = [ ffmpeg ];

  buildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/owncast --prefix PATH : ${
      lib.makeBinPath [ bash which ffmpeg ]
    }

    mkdir -p $out/usr/share/
    cp -r ./static $out/usr/share/static
    cp -r ./webroot $out/usr/share/webroot
  '';

  installCheckPhase = ''
    runHook preCheck
    $out/bin/owncast --help
    runHook postCheck
  '';

  meta = with lib; {
    description = "self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mayniklas ];
  };

}
