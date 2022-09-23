#!/bin/bash
# Setup
if [ "$#" -eq 2 ]; then
project=$1
target_root=$2
else
echo "usage: $0 <project-name> <target-folder>"
exit -1
fi
template_root=$PWD/GeneratorTemplates

# Build the Project
echo "**** Creating Project $project ****"
mkdir $target_root
if [ $? -ne 0 ]; then
    echo "Failed to create target folder."
    exit -1
fi
cd $target_root

# Check Python dependencies
pipenv --version
if [ $? -ne 0 ]; then
    echo "pipenv not installed. Exiting ..."
    exit -1
fi 

# Use pipenv to set up the essential Python packages
pipenv install django==3.2.15
pipenv install djangorestframework

# Set up the basic standard Django structure with a default app for managing accounts.
pipenv run django-admin startproject $project .
pipenv run python manage.py startapp accounts

# Populate newly created structure with frontend scaffold
cp -R $template_root/static ./static
cp -R $template_root/templates ./templates
cp -R $template_root/rest_api $project/
cp $template_root/gitignore_template .gitignore
cp $template_root/Readme.md .

# Modify and populate backend structures with appropriate links to the frontend scaffold.
cat $template_root/fragments/accounts_views >> accounts/views.py
cat $template_root/fragments/accounts_urls >> accounts/urls.py
cat $template_root/fragments/general_urls >> $project/urls.py

cat $template_root/fragments/general_settings | sed "s/__MYPROJECT__/$project/g" >> $project/settings.py
mkdir static-root

# Create and populate default sqlite database.
pipenv run python manage.py migrate

# Default User Authentication Sub-system tied to the accounts app.
# User will be prompted for name, email, and password
pipenv run python manage.py createsuperuser
pipenv run python manage.py collectstatic

echo "**** Project $project scaffolding created. ****"
echo "Run python manage.py runserver to test."
