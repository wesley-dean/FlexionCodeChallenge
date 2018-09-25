#!/usr/bin/env python

## @file verify_temperature
#  this program will help grade students' temperature conversions
#
#  @author Wes Dean <Wesley.Dean@kdaweb.com>
#  @details
#

import re
import sys
from flask import Flask, request, render_template

class Temperature:
	"""!@brief this is the base / parent class for *Temperature classes
  @details
  The Temperature class is designed to be overridden by *Temperature
  classes.  We store the temperature values on the Rankine scale 
  for simplicity of comparison; we also provide accessor methods to
  retrieve temperatures on different scales.
  """

	def __init__ (self, value):
		"""!@brief create a new Temperature object
		"""
		self._value = value

	def __eq__(self, other):
		return self.normalize() == other.normalize()

	def __str__(self):
		return self.normalize()

	def toRankine(self):
		return self._value

	def toKelvin(self):
		return self._value * (5 / 9)

	def toCelsius(self):
		return (self._value - 491.67) * (5 / 9)

	def toFarenheit(self):
		return self._value - 459.67

	def normalize(self):
		return str('%.0f' % (round (self.toRankine() * 10) / 10))

class FarenheitTemperature(Temperature):
	def __init__(self, value):
		Temperature.__init__(self, value + 459.67)

class CelsiusTemperature(Temperature):
	def __init__(self,value):
		Temperature.__init__(self, (value + 273.15) * (9 / 5))

class RankineTemperature(Temperature):
	def __init__(self, value):
		Temperature.__init__(self, value)

class KelvinTemperature(Temperature):
	def __init__(self, value):
		Temperature.__init__(self, value * (9 / 5))

def parse_temperature(string):

	matches = re.match('(?i) *([0-9.-]+) *([cfkr]).*', string)

	temperature_value = matches.group(1)
	temperature_units = matches.group(2).lower()

	if (temperature_units == 'c'):
		return CelsiusTemperature(float (temperature_value))
	elif (temperature_units == 'f'):
		return FarenheitTemperature(float (temperature_value))
	elif (temperature_units == 'k'):
		return KelvinTemperature(float (temperature_value))
	elif (temperature_units == 'r'):
		return RankineTemperature(float (temperature_value))
	else:
		raise 'invalid units'


def verify_temperature(teacher_string, student_string):

	try:
		teacher_temperature = parse_temperature(teacher_string)
	except:
		return 'invalid'

	try:
		student_temperature = parse_temperature(student_string)
	except:
		return 'incorrect'

	if (teacher_temperature == student_temperature):
			return 'correct'
	else:
		return 'incorrect'

app = Flask(__name__)

@app.route('/')
def home():
  return render_template('index.html.j2')

@app.route('/verify', methods=['GET', 'POST'])
def verify():
  error = None
  teacher_string = request.form['teacher_string']
  student_string = request.form['student_value'] + ' ' + request.form['student_units']

  verify_temperature_result = verify_temperature (
                             teacher_string = teacher_string,
                             student_string = student_string)

  return render_template ('verify.html.j2',
  result=verify_temperature_result)
