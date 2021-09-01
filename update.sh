#!/bin/sh
# Requires hit, npm, Python 3.8 and Angular

BASE=$(pwd)
REPOS=https://github.com/ankieter-gui

git clone $REPOS/engine
git clone $REPOS/interface

mv engine/* .

cd interface
npm install
ng build --configuration production
cd $BASE
cp -r interface/dist/frontend/* static/

git add .
git commit -am 'sync'
