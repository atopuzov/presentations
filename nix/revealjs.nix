{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.1.2";
  pname = "reveal.js";

  src = fetchurl {
    url = "https://github.com/hakimel/reveal.js/archive/${version}.tar.gz";
    sha256 = "1vjmg29caqppy35my6sfj1qxqa8idh6galw5c9bzwbyhcvs2vkv3";
  };

  installPhase = ''
    mkdir -p $out/reveal.js/
    cp -r {css,js,dist,plugin} $out/reveal.js/
  '';
}
