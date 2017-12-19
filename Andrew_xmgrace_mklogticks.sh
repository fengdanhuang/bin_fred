#!/bin/sh

usage() {
  echo "usage: mkasinhticks arg1 arg2 [-] tick1 [[-] tick2...]"
  echo "   arg1 and arg2 are the arguments given to mkasinh"
  echo "    (just use 1 if you did not give arguments to mkasinh)"
  echo "   tickN is a tick to add.  If tickN is preceded by a -,"
  echo "    tickN will be a minor tick and tickN can be in range"
  echo "    format, such as '0.0_', which will generate minor ticks"
  echo "    from 0.02 to 0.09."
}

if [ $# -lt 3 ]; then
  usage
  exit 1
fi

asinh1=$1
asinh2=$2
shift 2

tmpfile=`mktemp`

itick=0
borked=0
while [ $# -gt 0 ]; do
  if [ "$1" = "-" ]; then
    if [ $# -eq 0 ]; then
      borked=1
      break
    fi
    shift
    echo $1 | grep _ > /dev/null
    if [ $? -eq 0 ]; then
      base=`echo $1 | sed -e 's#_##'`
      echo $1 | grep -- - > /dev/null
      if [ $? -eq 0 ]; then
        for d in 9 8 7 6 5 4 3 2; do
          x=`echo $1 | sed -e "s#_#${d}#"`
          as=`echo 1 $x | mkasinh $asinh1 $asinh2 | awk '{print $2}'`
          echo "@    yaxis  tick minor ${itick}, $as"
          itick=`expr $itick + 1`
        done
      else
        for d in 2 3 4 5 6 7 8 9; do
          x=`echo $1 | sed -e "s#_#${d}#"`
          as=`echo 1 $x | mkasinh $asinh1 $asinh2 | awk '{print $2}'`
          echo "@    yaxis  tick minor ${itick}, $as"
          itick=`expr $itick + 1`
        done
      fi
    else
      as=`echo 1 $1 | mkasinh $asinh1 $asinh2 | awk '{print $2}'`
      echo "@    yaxis  tick minor ${itick}, $as"
      itick=`expr $itick + 1`
    fi
  else
    as=`echo 1 $1 | mkasinh $asinh1 $asinh2 | awk '{print $2}'`
    echo "@    yaxis  tick major ${itick}, $as"
    echo "@    yaxis  ticklabel ${itick}, \"$1\""
    itick=`expr $itick + 1`
  fi
  shift
done > $tmpfile

if [ $borked -eq 1 ]; then
  rm -f $tmpfile
  usage
  exit 1
fi


ntick=$itick

echo "@    yaxis  tick spec type both"
echo "@    yaxis  tick spec $ntick"

cat $tmpfile

rm -f $tmpfile
