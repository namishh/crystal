{}:
''
  #!/usr/bin/env bash

  # █▀▀ █ ▀█▀ █░█ █░█ █▄▄    █▀▀ █▀█ █▄░█ ▀█▀ █▀█ █ █▄▄
  # █▄█ █ ░█░ █▀█ █▄█ █▄█    █▄▄ █▄█ █░▀█ ░█░ █▀▄ █ █▄█

  USERNAME=$1
  CONTRIB_GRAPH_PATH="$HOME/.cache/awesome/github-data-heatmap"
  CONTRIB_YEAR_PATH="$HOME/.cache/awesome/github-data-year-totals"

  out=$(curl -s https://github-contributions.vercel.app/api/v1/$USERNAME)
  echo $out | jq -r '[.contributions[] | select(.date | strptime("%Y-%m-%d") | mktime < now)] | .[].intensity' | tee $CONTRIB_GRAPH_PATH
  echo "="
  echo $out | jq -r '.years[].total' | tee $CONTRIB_YEAR_PATH

  # date as first line of file
  curdate=$(date +"%Y-%m-%d")
  sed  -i "1i $curdate" $CONTRIB_GRAPH_PATH
''
