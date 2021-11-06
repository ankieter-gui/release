#!/bin/sh
# Requires hit, npm, Python 3.8 and Angular

# Optional arguments: $1 -- engine branch
#                     $2 -- interface branch

# Define constants
BASE=$(pwd)
REPOS=https://github.com/ankieter-gui

# Define variables
EBRANCH=''
IBRANCH=''
MSG=sync

# Process command line arguments
while [ $# -gt 0 ]; do
	case $1 in
	-c|--clean)
                for file in *; do
                        if [ "$file" = ".git" ]; then
                                continue
                        fi
                        if [ "$file" = "update.sh" ]; then
                                continue
                        fi
                        rm -rf "$file"
                done
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

# Clone the engine repository and set branch
git clone $REPOS/engine
cd $BASE/engine
if [ $EBRANCH ]; then
	git checkout $EBRANCH
fi
git pull
cd $BASE

# Cone the interface repository and set branch
git clone $REPOS/interface
cd $BASE/interface
if [ $IBRANCH ]; then
	git checkout $IBRANCH
fi
git pull
cd $BASE

# Move engine files to the main dir
mv engine/* .

# Build frontend
cd interface
npm install
ng build --configuration production
cd $BASE

mkdir static
mkdir templates

cp -r interface/dist/frontend/* static/
if [ -e static/index.html ]; then
	rm static/index.html
fi
cp interface/dist/frontend/index.html templates/

# Add all new files to the release repository
git add .

# Save changes
git commit -am "$MSG"

