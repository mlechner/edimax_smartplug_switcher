#!/bin/sh
PF=0

# read config
. ./switch_edimax.cfg

PrintConfig () {
  echo "Reading config...." >&2
  echo "Using config:"
  echo "URL: $URL" >&2
  echo "HEADER: $HEADER" >&2
  echo "ON_XML: $ON_XML" >&2
  echo "OFF_XML: $OFF_XML" >&2
  echo "STATUS_XML: $STATUS_XML" >&2
  echo "----------------------------"
}

Usage () {
  echo "Usage:"
  echo "./switch_edimax.sh [-c][-pf][-10su]"
  echo ""
  echo "Switch Edimax on, off or request status"
  echo ""
  echo "Config:"
  echo "    -c or --config Print config"
  echo ""
  echo "Flag:"
  echo "    -pf or --post-file  Send xml via wgets post-file - not available at older wget"
  echo ""
  echo "Options:"
  echo "    -1  or --on         Send on.xml to Edimax Smartplug"
  echo "    -0  or --off        Send off.xml to Edimax Smartplug"
  echo "    -s  or --status     Send status.xml to Edimax Smartplug"
  echo "    -h  or --help       Print this Usage"
  echo "    -u  or --usage      Print this Usage"
  echo ""
}

if [ $# -lt 1 ]
  then
    echo "wrong"
    Usage
    exit 1
fi

while [ "$#" -gt "0" ]
do
  case $1 in
    -c|--config)
      PrintConfig
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

while [ "$#" -gt "0" ] && [ "$PF" -eq "0" ]
do
  case $1 in
    -pf|--post-file)
      shift
      PF=1
      break
      ;;
    *)
      break
      ;;
  esac
done

while [ "$#" -gt "0" ]
do
  case $1 in
    -1|--on)
      shift
      if [ "$PF" -eq "1" ]
        then
          wget $URL --post-data="$(cat $ON_XML)" --header=$HEADER
        else
          wget $URL --post-file=$ON_XML --header=$HEADER
      fi
      exit 0
      ;;
    -0|--off)
      shift
      if [ "$PF" -eq "1" ]
        then
          wget $URL --post-data="$(cat $OFF_XML)" --header=$HEADER
        else
          wget $URL --post-file=$OFF_XML --header=$HEADER
      fi
      exit 0
      ;;
    -s|--status)
      shift
      if [ "$PF" -eq "1" ]
        then
          wget $URL --post-data="$(cat $STATUS_XML)" --header=$HEADER
        else
          wget $URL --post-file=$STATUS_XML --header=$HEADER
      fi
      exit 0
      ;;
    -u|-h|--help|--usage)
      shift
      Usage
      exit 0
      ;;
    *)
      shift
      echo "Syntax Error"
      Usage
      exit 1
      ;;
  esac
done
