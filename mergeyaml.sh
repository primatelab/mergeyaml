#!/usr/bin/env bash

yaml1="$1"
yaml2="$2"

unindent () {
  inputyaml="$1"
  tmpdir=$(mktemp -d /tmp/XXXXXX)
  sed 's/^/z;/g;' "$inputyaml" > "$tmpdir/yaml1"
  # unindent sections
  while (grep -E ';  ' "$tmpdir/yaml1" &>/dev/null); do
    cat "$tmpdir/yaml1" | while read line; do
      if (echo "$line" | grep -E ";[A-Za-z0-9\-_]*:" &>/dev/null); then
        echo "$line" >> "$tmpdir/yaml2"
        pref=$(echo "$line" | grep -Eo ";[A-Za-z0-9\-_]*:" | sed 's/^;//; s/:$//')
      else
        echo "${line/;  /;$pref;}"  >> "$tmpdir/yaml2"
      fi
    done
    mv -f "$tmpdir/yaml2" "$tmpdir/yaml1"
  done
  # unindent lists
  cat "$tmpdir/yaml1" | while read line; do
    if (echo "$line" | grep -E ";[A-Za-z0-9\-_]*:" &>/dev/null); then
      echo "$line" >> "$tmpdir/yaml2"
      pref=$(echo "$line" | grep -Eo ";[A-Za-z0-9\-_]*:" | sed 's/^;//; s/:$//')
    else
      echo "${line/;-/;$pref;-}" >> "$tmpdir/yaml2"
    fi
  done
  cat "$tmpdir/yaml2"
  rm -rf $tmpdir
}

reindent () {
  inputyaml="$1"
  sed 's/[a-zA-Z0-9\-_]*;/  /g; s/^  //; s/  -/-/' $inputyaml
}

tmpdir2=$(mktemp -d /tmp/XXXXXX)

unindent $yaml1 >> $tmpdir2/file1
unindent $yaml2 >> $tmpdir2/file1

cat $tmpdir2/file1 | LC_COLLATE=C sort | uniq >> $tmpdir2/file2

reindent $tmpdir2/file2
rm -rf $tmpdir2
