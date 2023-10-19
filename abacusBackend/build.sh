#!/bin/bash
pip install -r requirements.txt
python manage.py make migrations
python manage.py migrate
python dbSetup.py
