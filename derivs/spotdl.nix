{ lib, buildPythonApplication, fetchFromGitHub, pkgs, ... }:

buildPythonApplication rec {
  pname = "spotdl";
  version = "4.1.3";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-XsOecKwSgLWasZw3A4LKSSwEfq93oQM9IrsAIR2M28o=";
  };

  nativeBuildInputs = with pkgs.python311Packages; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = with pkgs.python311Packages; [
    spotipy
    pytube
    syncedlyrics
    pykakasi
    rich
    rapidfuzz
    mutagen
    ytmusicapi
    pytube
    yt-dlp
    mutagen
    rich
    beautifulsoup4
    requests
    unidecode
    setuptools
    rapidfuzz
    python-slugify
    uvicorn
    pydantic
    fastapi
    platformdirs
  ];

  checkInputs = with pkgs.python311Packages; [
    pytest-subprocess
  ];

  # requires networking
  doCheck = false;
  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # require networking
    "tests/test_init.py"
    "tests/test_matching.py"
    "tests/utils/test_m3u.py"
    "tests/utils/test_metadata.py"
    "tests/utils/test_search.py"
  ];

  disabledTests = [
    # require networking
    "test_album_from_string"
    "test_album_from_url"
    "test_album_length"
    "test_artist_from_url"
    "test_artist_from_string"
    "test_convert"
    "test_download_ffmpeg"
    "test_download_song"
    "test_playlist_from_string"
    "test_playlist_from_url"
    "test_playlist_length"
    "test_preload_song"
    "test_song_from_search_term"
    "test_song_from_url"
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ pkgs.ffmpeg ])
  ];
  meta = with lib; {
    description = "Download your Spotify playlists and songs along with album art and metadata";
    homepage = "https://github.com/spotDL/spotify-downloader";
    license = licenses.mit;
  };
}
