# Linux-only configuration.
{ ... }:

{
  imports = [ ./fonts.nix ];

  # Unlike darwin, Linux applications find fonts through fontconfig. This
  # generates the fontconfig configuration that makes fonts installed via
  # home.packages discoverable, and keeps the font cache up to date. It
  # defaults to false for a standalone Home Manager install.
  fonts.fontconfig.enable = true;
}
