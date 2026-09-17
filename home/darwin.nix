# Darwin-only configuration.
{ ... }:

{
  imports = [ ./fonts.nix ];

  # Fonts need no further setup here: macOS does not follow symlinked fonts,
  # so Home Manager's own darwin targets module collects every font in
  # home.packages and rsyncs it into ~/Library/Fonts/HomeManager on
  # activation. fontconfig is not involved.
}
