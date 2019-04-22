#!/bin/bash
# Setup
if [ "$#" -ge 1 ]; then
project=$1
else
echo "usage: $0 <project-name> [<app-name>]"
exit -1
fi
setup_root=$PWD
# Ensure that the static resources are properly installed
cd externals; ./build_static.sh
cd ..
# Build the Project
mkdir $project
cd $project
virtualenv env
source env/bin/activate
pip install django
django-admin startproject $project
cd $project
project_root=$PWD
echo "**** Project $project created. ****"
# Also creates an app if given the second parameter
if [ "$#" -eq 2 ]; then
app=$2
python manage.py startapp $app
# Update the project to use the created app. NOTE: this step is very fragile.
cd $project
cp ./settings.py ./settings.orig.py
cp ./urls.py ./urls.orig.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/project_patch_settings.py > ./settings.py
sed -i.bak -e "s/__MYPROJNAME__/$project/g" ./settings.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/project_patch_urls.py > ./urls.py
cd ../$app
# Set the new app's own URL paths, and new view. NOTE: this step is very fragile.
cp ./views.py ./views.orig.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_urls.py > ./urls.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_views.py > ./views.py
# Copy installed static folder
cp -R $setup_root/externals/static .
mkdir templates
cd templates
mkdir $app
cd $app
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_main.html > ./main.html
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_secure.html > ./secure.html
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_login.html > ./login.html
cp $setup_root/basic_template.html ./base.html
cd $project_root
echo "**== Application $app created. ==**"
fi
echo "*--- Initializing ---*"
python manage.py migrate
# If User Authentication Sub-system requested.
# User will be prompted for name, email, and password
python manage.py createsuperuser
echo "*--- Done Initializing ---*"
