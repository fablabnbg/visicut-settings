#! /bin/bash
#
# check-nn.sh - Simple tool to check for consistency of cut-nn.xml with cut-nn.xml
#
# (C) 2023 - juergen@fabmail.org - distribute under GPLv2+
# 
# TODO: suggest to copy the newer of the two files ont the other, if both exist, and differ

top=..

if [ ! -f $top/profiles/cut-nn.xml ]; then
  echo "ERROR: $top/profiles/cut-nn.xml missing."
  echo "       please create one using the cut.xml file as template and with"
  echo "         <orderStrategy>NEAREST</orderStrategy>"
  exit 1
fi

if [ -z "$(grep NEAREST $top/profiles/cut-nn.xml)" ]; then
  echo "ERROR: top/profiles/cut-nn.xml does not contain"
  echo "         <orderStrategy>NEAREST</orderStrategy>"
  exit 1
else
  echo "$top/profiles/cut-nn.xml OK"
fi

cutfiles="$(find $top/laserprofiles -name cut.xml)"
echo "$(echo "$cutfiles" | wc -w) cut.xml files found in $top/laserprofiles ..."

ok=0
err=0
for cut in $cutfiles; do
  nn="$(echo $cut | sed -e 's/cut.xml/cut-nn.xml/')"
  if [ -f "$nn" ]; then
    if ! cmp $cut $nn; then
      echo "ERROR: nn file $nn differs from its cut.xml file. They should be identical."
      diff -u0 $cut $nn
      # TODO:
      # if cut file is newer, suggest to copy it to nn file
      # if nn file is newer, suggest to copy it to cut file
      err=$(expr $err + 1)
    else
      ok=$(expr $ok + 1)
    fi
  else
    echo "nn file $nn missing. Copying..."
    cp $cut $nn
    ok=$(expr $ok + 1)
  fi
done

echo "$ok nn files are OK."
if [ $err != '0' ]; then
  echo "$err nn files need fixing."
fi
