#!/bin/bash

FLASK="${FLASK:-/usr/local/bin/flask}"

host="${host:-0.0.0.0}"
port="${port:-80}"

application="${application:-./verify_temperature.py}"
environment="${environment:-development}"

FLASK_APP="${application}" FLASK_ENV="${environment}" $FLASK run --host="${host}" --port="${port}"
