#!/bin/bash

python3 -m pip install -r requirements.txt --user
python manage.py runserver 0.0.0.0:8000
