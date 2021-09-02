#!/bin/sh
# Requires hit, npm, Python 3.8 and Angular

# Optional arguments: $1 -- engine branch
#                     $2 -- interface branch

BASE=$(pwd)
REPOS=https://github.com/ankieter-gui

git clone $REPOS/engine
if [ $# -ge 3 ]; then
	git checkout $1
fi


git clone $REPOS/interface
if [ $# -ge 3 ]; then
	git checkout $2
fi

mv engine/* .

cd interface
npm install
ng build --configuration production
cd $BASE
cp -r interface/dist/frontend/* static/

git add .

if [ $# -ge 3 ]; then
	git commit -am "sync engine: $1 interface: $2"
else
	git commit -am "sync"
fi
