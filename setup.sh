#!/bin/bash
# Setup
if [ "$#" -ge 1 ]; then
project=$1
else
echo "usage: $0 <project-name> [<app-name>]"
exit -1
fi
setup_root=$PWD

# Build the Project
echo "**** Creating Project $project ****"
mkdir $project
cd $project
virtualenv env
source env/bin/activate
pip install django
django-admin startproject $project
cd $project
project_root=$PWD
# Create the project's setup script. This script is used to (re)start the project using
#   only the checked-in parts of github repositories.
cp $setup_root/setup_template_project.sh $project_root/setup.sh
# Set up the folder for managing external packages and resources used to build
#   the project's static environments.
mkdir -p externals;
cp -R $setup_root/externals/stubAssets ./externals/
echo "**** Project $project created. ****"

echo "**== Creating Application $app ==**"
# Also creates an app if given the second parameter
if [ "$#" -eq 2 ]; then
app=$2
python manage.py startapp $app
# Update the project to use the created app. NOTE: this step is very fragile.
cd $project
cp ./settings.py ./settings.orig.py
cp ./urls.py ./urls.orig.py
sed -e "s/__MYAPPNAME__/$app/g" -e "s/__MYPROJNAME__/$project/g" $setup_root/project_patch_settings.py > ./settings.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/project_patch_urls.py > ./urls.py
cd ../$app
# Set the new app's own URL paths, and new view. NOTE: this step is very fragile.
cp ./views.py ./views.orig.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_urls.py > ./urls.py
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_views.py > ./views.py
# Install app static environment creation script and folder
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/setup_template_app.sh > $project_root/build_static.sh
# Creating new app's template files
mkdir templates
cd templates
mkdir $app
cd $app
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_main.html > ./main.html
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_secure.html > ./secure.html
sed -e "s/__MYAPPNAME__/$app/g" $setup_root/basic_login.html > ./login.html
cp $setup_root/basic_template.html ./base.html
cd $project_root
chmod 755 ./build_static.sh
/bin/bash build_static.sh
echo "**== Application $app created. ==**"
fi

echo "*--- Initializing Project ---*"
cd $project_root
python manage.py migrate
# If User Authentication Sub-system requested.
# User will be prompted for name, email, and password
python manage.py createsuperuser
# Create the requirements file so it can be used to reconstruct the environment.
pip freeze > requirements.txt
deactivate
virtualenv env
source env/bin/activate
pip install -r requirements.txt
echo "*--- Done Initializing ---*"
