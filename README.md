# Django Project Setup Support Package

## Overview

The purpose of this package is to help me get started quickly on a new
Django project based on my most common starting requirements. It is
mostly to mitigate the frustration of moving to a new Django project a
few months after a previous one, and then having to check
documentation on the process of starting a fresh project.

## Features

Running setup.sh with a project name, and an app name (optional but a common use-case) will:

* Create a new python 3.x virtualenv environment.
* Start the virtual environment, and install Django in that sandbox.
* Initialize the project.
* Initialize the app.
* Create the necessary static and template folders for the app.
* Replace the settings.py file of the project with one that has the app installed.
* Replace the urls.py file of the project with one that also includes the
urls.py file specified by the app.
* Create a new urls.py file for the app to specify the path for the main view and 
its associated template.
* Replace the views.py file of the app that specifies a simple main view which 
simply passes an empty context to its associated template.
* Create a base HTML template for the app. This base template specifies all the major
HTML blocks like Javascript, CSS, header, footer, and body.
* Create a main HTML template to be associated with the main view. This template
inherits from the previously created base HTML template, so it can override any of the
previously specified Django blocks.
* Maintain example files for the inclusion of database models, and model forms. These
can then serve as reference material for apps that require databases.

## Example Use-Case

* ./setup.sh myproject fooapp
* Script requests admin name, email, and password.
* cd myproject; source env/bin/activate
* cd myproject; python manage.py runserver
* browse to 127.0.0.1:8000 to see main view (Hello World)
* browse to 127.0.0.1:8000/admin to interact with admin operations. There appears to
be a weird interface bug when logging in as admin for the first time.

## Todos

* Setup baseline authentication using Django defaults.
* Use a prettier Bootstrap-based main HTML template (e.g. with a Jumbotron) for 
the main view as a starting point, instead of the current plain "Hello World" page.
* Perhaps include an option for the setup.sh script to include database models
infrastructure as part of the starting build.
