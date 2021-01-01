{ nixpkgs ? (import ./.nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./.nix/revealjs.nix {};

  # reveal.js 3.7.0 has minified version, needed for self-contained
  # -V revealjs-url=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.7.0 \
  revealjs_37 = pkgs.callPackage ./.nix/revealjs_37.nix {};

  linkRevealJs = pkgs.writeShellScriptBin "linkrevealjs" ''
    ${pkgs.coreutils}/bin/ln -sf ${revealjs}/reveal.js .
  '';

  mkSlides = pkgs.writeShellScriptBin "mkslides" ''
    REVEAL=${revealjs}/reveal.js
    SLIDE_LEVEL="1"
    OUTPUT="index.html"
    INPUT="slides.md"

    while getopts ":h:nt:so:l:i:" opt; do
      case "''${opt}" in
        h)
          HIGHLIGHT_STYLE="--highlight-style=''${OPTARG}"
          ;;
        n)
          HIGHLIGHT_STYLE="--no-highlight"
          CUSTOM_TEMPLATE="''${CUSTOM_TEMPLATE:-custom.revealjs}"
          ;;
        t)
          CUSTOM_TEMPLATE="''${OPTARG}"
          ;;
        s)
          SELF_CONTAINED="--self-contained"
          REVEAL="${revealjs_37}/reveal.js"
          ;;
        o)
          OUTPUT="''${OPTARG}"
          ;;
        l)
          SLIDE_LEVEL="''${OPTARG}"
          ;;
        i)
          INPUT="''${OPTARG}"
          ;;
        \? )
          echo "Usage: mkslides"
          ;;
      esac
    done

    if [[ -n "''${CUSTOM_TEMPLATE}" ]];
    then
      TEMPLATE="--template=''${CUSTOM_TEMPLATE}"
    fi

    PANDOC_ARGS=(
      "-t revealjs"
      "-V revealjs-url=$REVEAL"
      "''${SELF_CONTAINED:-}"
      "''${HIGHLIGHT_STYLE:-}"
      "''${TEMPLATE:-}"
      "--slide-level=$SLIDE_LEVEL"
      "--standalone"
      "--output $OUTPUT"
      "$INPUT"
    )

    echo ''${PANDOC_ARGS[@]}
    ${pkgs.pandoc}/bin/pandoc ''${PANDOC_ARGS[@]}
  '';

in
  pkgs.stdenv.mkDerivation {
    name = "presentations-shell";
    buildInputs = [ pkgs.pandoc revealjs mkSlides linkRevealJs ];
    shellHook = ''
      export LANG=en_US.UTF-8
      eval "$( ${pkgs.pandoc}/bin/pandoc --bash-completion )"
      echo "Welcome!"
    '';
  }
