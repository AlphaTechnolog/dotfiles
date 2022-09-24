{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkgconfig xorg.libX11 xorg.libXft fontconfig harfbuzz ];
}
