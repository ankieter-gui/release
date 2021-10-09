#!/bin/sh
# Requires hit, npm, Python 3.8 and Angular

# Optional arguments: $1 -- engine branch
#                     $2 -- interface branch

BASE=$(pwd)
REPOS=https://github.com/ankieter-gui
EBRANCH=''
IBRANCH=''
MSG=sync


while [ $# -gt 0 ]; do
	case $1 in
	-c|--clean)
		rm -rf $BASE/{engine,interface}
		;;
	-e|--engine)
		EBRANCH=$2
		MSG="$MSG engine: $EBRANCH"
		shift
		;;
	-i|--interface)
		IBRANCH=$2
		MSG="$MSG interface: $IBRANCH"
		shift
		;;
	esac
	shift
done


git clone $REPOS/engine
cd $BASE/engine
if [ $EBRANCH ]; then
	git checkout $EBRANCH
fi
git pull
cd $BASE


git clone $REPOS/interface
cd $BASE/interface
if [ $IBRANCH ]; then
	git checkout $IBRANCH
fi
git pull
cd $BASE


mv engine/* .

cd interface
npm install
ng build --configuration production
cd $BASE

cp -r interface/dist/frontend/* static/
rm static/index.html

cp interface/dist/frontend/index.html templates/

git add .

git commit -am "$MSG"

