#!/bin/bash

if [ -d static ] ; then
    echo "static folder already exists. Please remove to build from scratch."
else
    mkdir static
    if [ ! -d bootstrap-4.3.1-dist ] ; then
	if [ ! -f bootstrap-4.3.1-dist.zip ] ; then
	    echo "Downloading Bootstrap 4."
	    wget https://github.com/twbs/bootstrap/releases/download/v4.3.1/bootstrap-4.3.1-dist.zip
	fi
	echo "Expanding Bootstrap 4 package."
	unzip bootstrap-4.3.1-dist.zip
    fi
    echo "Installing Bootstrap 4 javascript and CSS files."
    cp -R bootstrap-4.3.1-dist/js static
    cp -R bootstrap-4.3.1-dist/css static
    if [ ! -f jquery-3.4.0.min.js ] ; then
	wget https://code.jquery.com/jquery-3.4.0.min.js; 
    fi
    echo "Installing jQuery 3.4.0."
    cp jquery-3.4.0.min.js static/js
    echo "Installing Stub Logos."
    cp -R resources/images static
fi
