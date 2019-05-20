#!/bin/bash

# This script has to always be run from the project root.
export bootstrap_ver=4.3.1
export jquery_ver=3.4.0

# Download and set up app static environment. All downloads end up in
#   the externals folder.
export appRoot=$PWD/__MYAPPNAME__
# In case externals does not exist.
mkdir -p externals;
cd externals;

# Download and create relative-pathed (hence the need for pushd and popd) soft links. 
echo "Installing Bootstrap 4 ($bootstrap_ver) javascript and CSS files."
if [ ! -d bootstrap-$bootstrap_ver-dist ] ; then
    if [ ! -f bootstrap-$bootstrap_ver-dist.zip ] ; then
	echo "Downloading Bootstrap 4."
	wget https://github.com/twbs/bootstrap/releases/download/v$bootstrap_ver/bootstrap-$bootstrap_ver-dist.zip
    fi
    echo "Expanding Bootstrap 4 package."
    unzip bootstrap-$bootstrap_ver-dist.zip
fi
# In case the static folder does not yet exist.
mkdir -p $appRoot/static
pushd $appRoot/static
ln -sfn ../../externals/bootstrap-$bootstrap_ver-dist bootstrap4
popd
echo "*****"

echo "Installing jQuery ($jquery_ver)."
if [ ! -f jquery-$jquery_ver.min.js ] ; then
    wget https://code.jquery.com/jquery-$jquery_ver.min.js; 
fi
# In case the static folder has no js sub-folder.
mkdir -p $appRoot/static/js
pushd $appRoot/static/js
ln -sfn ../../../externals/jquery-$jquery_ver.min.js jquery.min.js
popd
echo "*****"

echo "Installing Assets."
pushd $appRoot/static
ln -sfn ../../externals/stubAssets/images images
popd
echo "*****"
