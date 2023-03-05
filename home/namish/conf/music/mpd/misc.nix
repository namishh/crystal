{ ... }:

{
  # Allows mpd to work with playerctl.
  services.mpdris2.enable = true;
  services.playerctld.enable = true;
}
