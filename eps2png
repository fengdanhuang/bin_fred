#!/bin/sh

epsfile=""
if [ $# -eq 1 ]; then
  epsfile="$1"
  if [ ! -e "$epsfile" ] && [ -e "${epsfile}.eps" ]; then
    epsfile="${epsfile}.eps"
  fi
elif [ $# -gt 1 ]; then
  for f in ${1+"$@"}; do
    if [ ! -e "$f" ]; then
      echo "$f does not exist"
      exit
    fi
  done
  for f in ${1+"$@"}; do
    eps2png "$f"
  done
  exit
fi
if [ ! -e "$epsfile" ]; then
  echo "usage: eps2png file.eps"
  exit 1
fi

pngfile=`echo "$epsfile" | sed -e 's#\.eps$#.png#'`
if [ "$pngfile" = "$epsfile" ]; then
  echo "usage: eps2png file.eps"
  exit 1
fi

tmpepsfile=`mktemp /tmp/XXXXXXXXX.eps`
awk 'BEGIN {
  bbline="";
}
{
  if (ARGIND==1) {
    if (/^%%BoundingBox: / && !/atend/) {
      bbline=$0;
      nextfile;
    }
  }
  else {
    if (/^%%BoundingBox: /) {
      if (length(bbline) > 0) {
        print bbline;
        bbline="";
      }
    }
    else {
      print;
    }
  }
}' "$epsfile" "$epsfile" > "$tmpepsfile"

convert -define ps:use-cropbox=true -density 144x144 "$tmpepsfile" "$pngfile"
rm -f "$tmpepsfile"
