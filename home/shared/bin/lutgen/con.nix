_:
''
  #!/usr/bin/env bash
  mkdir -p converted
  find . -depth -name "* *" -execdir rename " " "_" "{}" ";"
  for file in ./*
  do
    lut "$file" "./converted/$file" $1
  done
''
