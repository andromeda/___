#!/bin/bash
# Pulls repositories as needed (either everything or a single repo)
#
# This script can be called both ways:
# * If in the andromeda top level repo, just sets up submodules
# * If used standalone (or via wget), first clones top level repo
#
# Subprojects might have different dependencies -- see the docs

# GitHub allows HTTP, but would then need to check for curl/wget 
# and recursively fetch all the repositories, some of which might
# be private. Easiest way to resolve.
GIT_ERROR="You need git to get the repositories. Exiting..";

command -v "git" >/dev/null 2>&1 || { echo "$GIT_ERROR"; }

SINGLE_REPO=false
REPO_NAME=""
M31_INFO="    Apparent mass: ~1,230 billion M☉\n    Age: 9 billion years\n    Magnitude: 3.44\n    Constellation: Andromeda\n    Stars: 1 trillion"
SPLASH="                                                                   .                                                     \n                                                           .  .   .           .     .                                    \n                                              ?.      .      .      ~      :                                             \n                                 ,.       .   .. .         . .           .  .                                            \n                               . ? .   +  .   .     .  =.     ?,    , : :.                                               \n                             .         ?,  ..        .,  :   =    :,     . ?..  .            .                           \n                             .O                    =.  ,..  ,  ,.  . ,~.~?   . ..  =.  =.     .                          \n                      :  ~  .      ,.    . , ~: :$. ~.?I, 7::.~     .~. ,   ..~ : ::  ..      ,                          \n                     .,      .          =, ~ ,7?, + .?   .: ..,  .. .  ? .      .=  :  ND.,. ..                          \n                   ,,,   ,  = .  , .. .=,::=,.~= ~~~  : ~.  +=      :,.=.  :~    ~  ::  .: ,  +    ,,                    \n                   .  :.       .    . ..   .O . ..     . ..   I:., .=.,  . .    .     .  .. ? ~ .                        \n                ..       ,Z ..  + ,.,$? I?+= . O  Z  = ,.  +== Z.+ ~:=,:~ .    , ,        .,  ..    .                    \n            . ..                . ~  ?$,:?.= : . +,, .  ID:8=  :. =+7 ? I+ =~=:~ .     ..    ~.    .    .=               \n           , , .     .   .    ..?   = :.  . 8~O    . ~?::,?8D+8I$MZZOZ??M$ .., ?~. :   ~ I .  .7   .    ~ . .            \n             ? =.       ~      .  .Z?++  + ...  Z. I= =,7=MMMMI..~  DN== $ ?Z7O~,I?   I  .   ,.: .   . ~ =       .       \n          .     ,        .   .?,. :???:.     ..  .~~=+?MMDMMMD8= :+7 I~ 7.7~.~I+?,=.=. .  .       ,.= .        .         \n          .    ? .         ,.  ?  .N8+,  I8   . I=7:~ZMMMMDO8?8I:? ~.,=. ,? .,77,= =Z..           ?  ~ .,   ~      =     \n         .....   =         8. I7 ?M= Z+.:~ . ~. =. ,?IZMMMN=M7ODM77 , ? =.I  ~I=7,$$?~. =.~. ,  . , . =  . .~            \n        , $..   I ..  .    . ?+ M~~I$, . ..  I.. ~,?:?MMMMMMMMOM8N7=   . ...= =.?~:$:,,$.=  ..           .  .  ..        \n      .   . M.      +           .?N?= II+..O , Z?=?I.=OMMMMMMMMMMMZ, 8 . =  =..:.:. ,~ I             +  . .?  :~   .     \n     .  . ..        :    .  ,     ,$$+8~ :  .I.D . ,7:77INNMMMMMMON~:+?I..$ I,. ~+ Z+?+.+ = I.. ?         =    : .       \n       :     I     .     ,     ..  +N I,I  .7 ..7 ?,= ?? 7$M8MMMMM:M=,=?.~..I,,    7 8+7 =.. .7,            : . 7 .      \n    .   =      .  .      .,  .   .~:D=D$~ :.:..    7.ZD~I:IN:D8MMMMMO,.. . .   7Z  :  ,. ,~    ..    .        7 ,: .  7. \n        +.  :   ~              7 7 + ~7+?=N =. +.+ I :N.7..Z DZMMNM77= $.N I ~ ?.=,:O.   M+         .. .  .   ,.. .,     \n        ~ :.         .        : : . =.7$7? =.N=? ..I+. O7,N=NMMOM.8,$$+N  .  ,...  . ..~OM7O.        .             .     \n         Z.  .       =         .       I=.,D7=M,7=7+IZ8,OZ$7NZ7D$+ $II~      .,   .  .  ,..:=., .         ~.  +     .~.. \n     ,.      =            .~    ,~  .Z,.  =, =8ZN~7,8:+8N8MM7M?7$7..IN$ . ..,  ,~  +  .. I.:  =     ..          ,.       \n        , .+          .   $       +.=   :M  ?.  $IO= I,78M?Z. +: ,~:  .I, ~  .,: 7:.. .,?I:?  .     7            ,    O.7\n     :$,  .   = .      =  ..        ~.. $ 8: =. O I . =+.=+ ~ ~ .   . . ~ =    Z. :  ,  .  .                 ..          \n        =     .                 ..   .  . ?7 I.=I,=+.:Z~. +? =. ,  :,     Z .. ~.   7... ==  : ,          .    . :    ~  \n ..     .  7         .   ..       ?. . . .,   .$ Z.+..: .. ., 7  ,:.  ,.        . + ::?7,.~ .  =     . ..             ,, \n        :,7 . .  Z,         .,    .     II . .  ?~  $   I.      . .   .         ,I ?  ,,.=.   ,                          \n   . .   $ ..M    ...         ..N         .   .  .  : ~   ,. . +    + ?    . . =    D  .8,  .., .   .                   7\n   +        7  .    I.              .    :   .          .I .    .   .         , :? I?.N? . .....                     O7D \n            I , :,  ,                  :.  .          ?$  .     .  +  ...  =.. . ,  +?I Z  +~   . .       ..   Z      .  \n                I       ,       ~O           .  .: .. .:             ,   7..  .   .   .  ~ ..    .                       \n           . . .  :            .     .  .,        =      .   ..     .   .   .  .: =.,+          =    .                Z  \n  8 +           N                .     +,   . ,N              .     ,   .O. .  D.       ..           . :        ,        \n           7      .=  D  ?   ..      ...   =  I : .. ?   :     :  :  :.  ~  ,. 8.  ,.       .         .. ,               \n . .       Z    ...I   . I  .    .   ..   . .  I   ....   = .8 O:         .I.    : ~ :               ,  ~.             7 \n :      .         ..      ?    .$ .    7     : +   I            : :, ,,I ::,. =8,  .        $                            \n                   ,+  =  . .       .  Z       . .   ,:   . M =   .  8:  :..   ,     .                                   \n              ,.    ,     ..,.          .   O ..: . .   :  . Z  . .   ..,   .   . I  ..                      ..          \n           ~   .            $        .     +   D M=  .       ..     8  ,       .                                         \n          .:                  ~    .O .. I ..:  M~. .. 7~ . ~  .   7                : .                                  \n                         .  Z   .O.   I~   ,  ~ +    ?     :      .                                   andromeda          \n           .      .       .               .            ....  .    .  ~     .       .    m31                              \n               .                ,.             ..   ,,      .    ..                .      . .                            \n                                              .   :   ..    =                       :                                    "
##
# First argument (optional) is a severity:
# 1 (grey -- default), 2 (white), 3 (purple), 4 (yellow), 5 (red)
# rest of arguments are text
##
out() {
  local _severity="0"

  if [[ $1 == "2" ]]; then
    _severity="7"
    shift
  fi
  if [[ $1 == "3" ]]; then
    _severity="5"
    shift
  fi
  if [[ $1 == "4" ]]; then
    _severity="3"
    shift
  fi
  if [[ $1 == "5" ]]; then
    _severity="1"
    shift
  fi

  while (( "$#" )); do
    echo -e "$(tput bold ; tput setaf $_severity)$1$(tput sgr0)" | 
      sed "s/andromeda/$(tput sgr0)$(tput setaf 7)andromeda$(tput bold ; tput setaf 8)/" 
    shift
  done
}

##
# Output the first argument, if previous command run OK
##
try() {
  if [ $? != 0 ]; then out "$1"; fi
}

##
# Replace the beginning of the string
##
istart() {
  sed "s/^/$(tput bold ; tput setaf 8)    /" | sed s/Submodule/Subuniverse/
}

##
# Replace the end of the string
##
iend() {
  sed "s/$/$(tput sgr0)/"
}


usage() {
  echo "
  Usage: ./$(basename $0)

  Fetches the andromeda repositories and prepares the environment (dependencies).

  Options
  =======
  -r <repo>:          Tries to fetch  a particular repository.
  -h:                 This help message

  "
}


##
# Generate submodules
##
generate-submodules() {
  out "\n  [Registering Universe]\n"
  git submodule init 2>&1 | istart | iend
  out "\n  [Initializing Universe]\n"
  { sleep 1 && out "    ..hang tight!" &}
  git submodule update 2>&1 | istart | iend
  for d in */ ; do 
    cd $d;
    git checkout master 2>&1 | istart | iend 
    git pull 2>&1 | istart | iend 
    cd ..;
  done
  out "\n  [Andromeda Galaxy]\n"
  out "$M31_INFO"
  out "\n  [Time is now $(date) +2,538,000 light years..]\n"
}

##
# A simple test
##
cell() {
  out one
}

##
# Add aliases to .*shrc's
##
patch-rc() {
  out "  [Patching .*rc]\n"
  out "  You can add the following shortcuts to your shell startup file"
  # Andromeda
  out "    androdev=$(pwd)"
  out "    andromeda=$(pwd)/andromeda"
  out "    alias andromeda='node $(pwd)/andromeda/andromeda.js'"
  #for file in .*shrc; do
  #  echo "m31=$(pwd)" >> $file
  #  echo 'alias m31=$m31/m31/src/shell.js' >> $file
  #done
}

prelude() {
  clear
  out "$SPLASH"
}

# Check which argument we have
while getopts "r:h" opt; do
  case $opt in
    r) 
      out "Repository picked: ${OPTARG}"
      SINGLE_REPO=true;
      REPO_NAME="${OPTARG}";
      ;;
    h) 
      usage;
      exit 0;
      ;;
    \?)
      out "There are no arguments -- that's OK"
      exit 1;
      ;;
    :)
      out "Need extra argument for ${OPTARG}. -h brings up help."
      exit 1;
      ;;
  esac
done

if [[ -e "./.git" ]]; then
  # we are in git, invoke locally
  prelude
  generate-submodules
else
  # clone repository
  if [[ $SINGLE_REPO == 'true' ]]; then
    out "\n  [Cloning ${REPO_NAME}]\n"
    git clone git@github.com:andromeda/${REPO_NAME}.git 2>&1 | grep -v clon
  else
    prelude
    out "  [Cloning Universe]\n"
    git clone git@github.com:andromeda/universe.git > /dev/null 2>&1
    cd universe
    generate-submodules
    patch-rc
  fi
fi
