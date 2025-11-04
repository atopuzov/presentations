
{
  description = "A simple flake for presentations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;

        revealjs = pkgs.callPackage ./nix/revealjs.nix {};
        revealjs_37 = pkgs.callPackage ./nix/revealjs_37.nix {};

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
              ? )
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

        presentations = map(dir: {
          name = dir;
          path = pkgs.callPackage (./presentations + "/${dir}") { inherit revealjs; };
        });

        dirs = [
          "calculate-checksum"
          "nix-intro"
          "slides-test"
          "mss"
          "baastad"
        ];

        indexHtml = pkgs.writeTextFile {
          name = "index.html";
          text = ''
            <!doctype html>
            <html lang=en>
              <head>
              <meta charset=utf-8>
              <title>Presentations</title>
              </head>
              <body>
            ${lib.concatMapStringsSep "
" (dir: "    <li><a href='${dir}'>${dir}</a></li>") dirs}
              </body>
            </html>
          '';
        };

      in
      {
        packages.default = pkgs.linkFarm "presentations" ([
          { name = ".nojekyll";  path = pkgs.writeTextFile { name = "nojekyll"; text = ""; }; }
          { name = "CNAME";      path = pkgs.writeTextFile { name = "cname";    text = "talks.topuzovic.net"; }; }
          { name = "index.html"; path = indexHtml;}
        ] ++ presentations dirs);

        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.pandoc revealjs mkSlides linkRevealJs ];
          shellHook = ''
            export LANG=en_US.UTF-8
            eval "$( ${pkgs.pandoc}/bin/pandoc --bash-completion )"
            echo "Welcome!"
          '';
        };
      }
    );
}

