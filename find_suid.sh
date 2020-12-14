#!/bin/bash
# ssh usename@ipaddrs 'bash -s ' < find_suid.sh

RED='\033[0;31m';
GRE='\033[0;32m';
YEL='\033[1;33m';
BLU='\033[0;34m';
LGRE='\033[1;32m';
NC='\033[0m';
for FILENAME in $(find / -perm /4000 2>/dev/null)
    do
        for LIB in $(ldd $FILENAME 2>/dev/null | grep '=>' | cut -d' ' -f 3 | sort -u)
            do
                DIR=$(dirname $LIB 2>/dev/null)
                PERML=$(stat -L -c "%U" $LIB 2>/dev/null);
                PERMD=$(stat -L -c "%U" $DIR 2>/dev/null);
               
                if [ -w "$LIB" ];then COLORL=$LGRE;COLORS=$LGRE;STATUSL='+'; else COLORL=$RED;COLORS=$RED;STATUSL='-';fi
                if [ -w "$DIR" ];then COLORD=$LGRE;COLORS=$LGRE;STATUSD='+';else COLORD=$RED;COLORS=$RED;STATUSD='-';fi
                if [[ "$STATUSL" == "+" || "$STATUSD" == "+" ]];then STATUS='+';STATUSC=$LGRE; else STATUS='-';STATUSC=$RED;fi
                
                printf "${STATUSC}[$STATUS]${NC} `hostname`, ${GRE}$FILENAME${NC}, ${BLU}$DIR${NC} (${COLORD}$PERMD${NC}), $LIB (${COLORL}$PERML${NC})\n"
        done
    done
