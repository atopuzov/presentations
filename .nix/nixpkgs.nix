# git ls-remote https://github.com/NixOS/nixpkgs-channels nixos-20.03
builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs-channels";
  rev = "05a32d8e771dc39438835ba0e3141d68ad4e3068";
  ref = "nixos-20.03";
 }
