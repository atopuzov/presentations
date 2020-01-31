
---
title: Introduction to Nix**
author: Aleksandar Topuzović
theme: night
width: 1920
height: 1080
---

## Nix

> Nix is a purely functional package manager.

It is built using the Nix language

---

### Nix the language

The Nix expression language is a pure, lazy, functional language.

The language was designed especially for the Nix Package Manager.

[Wiki](https://nixos.wiki/wiki/Nix_Expression_Language)

[Nix-by-example](https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55)

[Nix One Pager](https://github.com/tazjin/nix-1p)

---

### Nix language basics

Types

* Strings
```nix
''This is a multiline
  string
''
```

* Integers

* Floats

---

* Path
```nix
/nix/store/b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z-firefox-33.1
```
* URIs

* Booleans

* Lists
```nix
[ 1 2 3 4 5]
```
* Sets
```nix
{
  key = value;
  other = value2;
}
```

---

### Functions

```nix
f = x: y: x * y
d = f 2
f = {arg, ...}: arg

```

### let

```nix
let
  a = 1;
  b = 2;
in
  a + b
```

### rec
```nix
rec { a = 15; b = a * 2; }
```

---

### standard library

built into nix

```nix
builtins.<function>
builtins.toJSON
```

nixos provided lib

```nix
nixpkgs.lib.<function>
nixpkgs.lib.mapAttrs
```

---

## Nix the package manager

It treats packages like values in purely functional programming languages.

Packages are built by functions that don’t have side-effects, and they never
change after they have been built.

--

## Nix store

Nix stores packages in the Nix store, `/nix/store` where each package has its own unique subdirectory

`/nix/store/b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z-firefox-33.1/`

Where `b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z` is a unique identifier for the package that captures all its dependencies (it’s a cryptographic hash of the package’s build dependency graph).

[Nix](https://nixos.org/nix/about.html)


---

### Reliable

Nix’s purely functional approach ensures that installing or upgrading one
package cannot break other packages.

This is because it won’t overwrite dependencies with newer versions that might
cause breakage elsewhere.

It allows you to roll back to previous versions, and ensures that no package is
in an inconsistent state during an upgrade.

---

### Reproducible

Nix builds packages in isolation from each other.

This ensures that they are reproducible and don’t have undeclared dependencies,
so if a package works on one machine, it will also work on another.

::: notes

Binary reproducible report for minimal NixOS ISO

[Report](https://r13y.com/)

:::

---

###  Great for developers

Nix makes it trivial to set up and share build environments for your projects,
regardless of what programming languages and tools you’re using.

For instance, running the command “nix-shell '<nixpkgs>' -A firefox” gives you a
Bash shell in which all of Firefox’s build-time dependencies are present and all
necessary environment variables are set.

---

### Multi-user, multi-version

Nix supports multi-user package management: multiple users can share a common
Nix store securely, don’t need to have root privileges to install software, and
can install and use different versions of a package.

---

### Derivations

A recipe how to build a package

```nix
{ nixpkgs ? <nixpkgs>
}:
let
  pkgs = import nixpkgs {};
in
  pkgs.stdenv.mkDerivation {
    name = "my-loveley-cow";
    phases = ["buildPhase"];
    buildInputs = [ pkgs.cowsay ];
    buildPhase = ''
      mkdir $out
      cowsay "Nix is awesome!" > $out/what.txt
    '';
  }
```

---
## Builders

fetchurl

`nixpkgs/pkgs/build-support/fetchurl/default.nix`

Trivial builders

`nixpkgs/pkgs/build-support/trivial-builders.nix`

eg `writeTextFile``

Other

`pythonPackages.buildPythonPackage`

---

## Install

Nix is available on Linux (works on WSL) and Mac Os X

`curl https://nixos.org/nix/install | sh`

[Download](https://nixos.org/nix/download.html)

---

## Nix Repl

```
$ nix repl
Welcome to Nix version 2.3.2. Type :? for help.

nix-repl>
```

---

## NixPkgs

Nix package collection is a set of packages for the Nix package manager.

[NixPkgs](https://nixos.org/nixpkgs)

[Github NixPkgs](https://github.com/NixOS/nixpkgs/tree/master/pkgs)

::: notes

A collection of derivations

:::

---

## Nix shell

The power house of development using Nix.

A file usually called `shell.nix` contains the declaration of packages that are
available to the user.

::: notes

Pure mode, environment is cleared before entering the interactive shell so it
closely corresponds to a real nix build

:::


---

### An example Haskell environment

```nix
{ nixpkgs ? <nixpkgs> }:
let
  pkgs = import nixpkgs {};
  haskellWithPackages = pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [
    array
    vector
    split
    # language tools
    hindent
    hlint
    stylish-haskell
  ]);
in
pkgs.mkShell {
  buildInputs = [haskellWithPackages];

  shellHook = ''
    echo "Ready!"
  '';
}
```

---

## NixOS

NixOS is a Linux distribution with a unique approach to package and
configuration management. Built on top of the Nix package manager, it is
completely declarative, makes upgrading systems reliable, and has many other
advantages.

[Nixos](https://nixos.org/nixos/)

[Manual](https://nixos.org/nixos/manual/)

---

### Configuration

Host configuration defined in

`/etc/nixos/configuration.nix`

```
{ config, lib, pkgs, ... }:
{
   imports = [
    ./hardware-configuration.nix
  ];
  ...
  services.nginx = {
    enable = true;
    statusPage = true;
    virtualHosts."www.topuzovic.net" = {
      default = true;
      enableACME = true;
      addSSL = true;
    };
  };
 ...
}

```

::: notes

Configuration changes are applied by creating a new set of files in `/etc` and
not by in place modification

:::

---

### Modules

NixOS has a modular system for declarative configuration.
Each module handles a specific thing, modules can reuse other modules and can
define options which are used by other modules


[Writing modules](https://nixos.org/nixos/manual/index.html#sec-writing-modules)

::: notes

For example, the module pam.nix declares the option security.pam.services that
allows other modules (e.g. sshd.nix) to define PAM services; and it defines the
option environment.

:::

---

### Channels/Releases

Channels is the method of specifying which version of NixOs to install.

There are 2 releases per year (eg. 19.03, 19.09) which correspond to channels.

eg. `http://nixos.org/channels/nixos-19.09`


::: notes

Shameless plug
https://nixos.org/nixos/manual/release-notes.html#sec-release-19.03-notable-changes
* The Grafana module now supports declarative datasource and dashboard provisioning.

:::

---

## NixOps

NixOps is a tool for deploying NixOS machines in a network or cloud. It takes as
input a declarative specification of a set of “logical” machines and then
performs any necessary steps or actions to realise that specification:
instantiate cloud machines, build and download dependencies, stop and start
services, and so on.

[NixOps](https://nixos.org/nixops/)

[Manual](https://nixos.org/nixops/manual/)

[Code](https://github.com/NixOS/nixops)

---

## Nix pills

A series of blog posts that provide a tutorial introduction into the Nix package
manager and Nixpkgs package collection, in the form of short chapters called
'pills'.

[NixPills](https://nixos.org/nixos/nix-pills/index.html)

---

## Guix

Based on the Nix package manager but packages are defined as native Guile
(scheme) modules.
Provides exclusively only free software.

[Guix](https://guix.gnu.org/)

[Guile](https://www.gnu.org/software/guile/)

---

### Guix System (GuixSD)

An advanced distribution of the GNU operating system. It uses the
Linux-libre kernel, and and GNU Shepherd init system.

---

## Honorable mentions

Disnix is a distributed service deployment toolset whose main purpose is to
deploy service oriented systems into networks of machines having various
characteristics (such as operating systems) and is built on top of Nix

[disnix](https://nixos.org/disnix/)

Hydra is a Nix-based continuous build system. Builds nixpkkgs.

[hydra](https://nixos.org/hydra/)

cpkg is a build tool for C with a particular emphasis on cross compilation. It
is configured using Dhall.

Some would say this is how nix would look with static types.

[cpkg](https://github.com/vmchale/cpkg)

---

## Questions?

---

## Thank you!

github.com/atopuzov

twitter.com/atopuzov
