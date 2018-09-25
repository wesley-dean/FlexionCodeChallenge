#!/bin/bash

host="${host:-0.0.0.0}"
port="${port:-5000}"

application="${application:-./verify_temperature.py}"
environment="${environment:-development}"

FLASK_APP="${application}" FLASK_ENV="${environment}" flask run --host="${host}" --port="${port}"
