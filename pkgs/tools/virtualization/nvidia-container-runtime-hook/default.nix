{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nvidia-container-runtime-hook";
  version = "95836f333576730bf0cc5f3e6580a30495034926";

  goPackagePath = "github.com/NVIDIA/nvidia-container-runtime";

  src = fetchFromGitHub {
     owner = "NVIDIA";
     repo = "nvidia-container-runtime";
     rev = version;
     sha256 = "1mhybrrxxrafrz096mrj2x3bigy015jwc2f8wpv3hiqs6whjblxw";
  };

  goDeps = ./deps.nix;
  preConfigure = "cd hook/nvidia-container-runtime-hook";
}
