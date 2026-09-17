# Fonts shared by every platform. The packages themselves are
# platform-independent; only the way they are made visible to applications
# differs, and that part lives in darwin.nix / linux.nix.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    hackgen-font
    font-awesome
    freefont_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
