#!/bin/bash
# Setup
if [ "$#" -ge 1 ]; then
project=$1
else
echo "usage: $0 <project-name> [<app-name>]"
exit -1
fi
mkdir $project
cd $project
virtualenv env
source env/bin/activate
pip install django
django-admin startproject $project
cd $project
echo "**** Project $project created. ****"
# Also creates an app if given the second parameter
if [ "$#" -eq 2 ]; then
app=$2
python manage.py startapp $app
# Update the project to use the created app. NOTE: this step is very fragile.
cd $project
cp ./settings.py ./settings.orig.py
cp ./urls.py ./urls.orig.py
sed -e "s/__MYAPPNAME__/$app/g" ../../../project_patch_settings.py > ./settings.py
sed -e "s/__MYAPPNAME__/$app/g" ../../../project_patch_urls.py > ./urls.py
cd ../$app
# Set the new app's own URL paths, and new view. NOTE: this step is very fragile.
cp ./views.py ./views.orig.py
cp ../../../basic_urls.py ./urls.py
sed -e "s/__MYAPPNAME__/$app/g" ../../../basic_views.py > ./views.py
mkdir templates
mkdir static
cd templates
mkdir $app
cd $app
sed -e "s/__MYAPPNAME__/$app/g" ../../../../../basic_main.html > ./main.html
cp ../../../../../basic_template.html ./base.html
cd ../../..
echo "**== Application $app created. ==**"
fi
echo "*--- Initializing ---*"
python manage.py migrate
# User will be prompted for name, email, and password
python manage.py createsuperuser
echo "*--- Done Initializing ---*"
