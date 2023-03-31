#!/usr/bin/env bash

unindent () {
  inputyaml="$1"
  ltmpdir=$(mktemp -d /tmp/XXXXXX)
  sed 's/^---//g; s/^/z;/g;' "$inputyaml" > "$ltmpdir/yaml1"
  # unindent sections
  while (grep -E ';  ' "$ltmpdir/yaml1" &>/dev/null); do
    cat "$ltmpdir/yaml1" | while read line; do
      if (echo "$line" | grep -E ";[A-Za-z0-9\-_]*:" &>/dev/null); then
        echo "$line" >> "$ltmpdir/yaml2"
        pref=$(echo "$line" | grep -Eo ";[A-Za-z0-9\-_]*:" | sed 's/^;//; s/:$//')
      else
        echo "${line/;  /;$pref;}"  >> "$ltmpdir/yaml2"
      fi
    done
    mv -f "$ltmpdir/yaml2" "$ltmpdir/yaml1"
  done
  # unindent lists
  cat "$ltmpdir/yaml1" | while read line; do
    if (echo "$line" | grep -E ";[A-Za-z0-9\-_]*:" &>/dev/null); then
      echo "$line" >> "$ltmpdir/yaml2"
      pref=$(echo "$line" | grep -Eo ";[A-Za-z0-9\-_]*:" | sed 's/^;//; s/:$//')
    else
      echo "${line/;-/;$pref;-}" >> "$ltmpdir/yaml2"
    fi
  done
  cat "$ltmpdir/yaml2"
  rm -rf $ltmpdir
}

reindent () {
  inputyaml="$1"
  sed 's/[a-zA-Z0-9\-_]*;/  /g; s/^  //; s/  -/-/' $inputyaml
}

tmpdir=$(mktemp -d /tmp/XXXXXX)

for item in $@; do
  unindent $item >> $tmpdir/file1
done
echo -n '---' > $tmpdir/file2
cat $tmpdir/file1 | LC_COLLATE=C sort | uniq >> $tmpdir/file2

reindent $tmpdir/file2
rm -rf $tmpdir
