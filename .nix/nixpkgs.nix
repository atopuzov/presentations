# git ls-remote https://github.com/NixOS/nixpkgs nixos-20.09
builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs";
  rev = "e065200fc90175a8f6e50e76ef10a48786126e1c";
  ref = "nixos-20.09";
 }
