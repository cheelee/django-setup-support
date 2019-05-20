#!/bin/bash

# Set up Python environment
if [ ! -d env ] ; then
    virtualenv env;
    source env/bin/activate
    pip install -r requirements.txt
else
    source env/bin/activate
fi

# [Optional] Use the test database as the default demo database
# The reason we make a copy instead of link is that usage of the database changes
#   its timestamp, and this makes the repository mark it as a change.
#
# cp db.sqlite3.test db.sqlite3

