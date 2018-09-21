#!/usr/bin/env python

import re
import sys

class Temperature:
	def __init__ (self, value):
		self._value = value

	def toRankine(self):
		return self._value

	def toKelvin(self):
		return self._value * (5 / 9)

	def toCelsius(self):
		return (self._value - 491.67) * (5 / 9)

	def toFarenheit(self):
		return self._value - 459.67


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

teacher_value = str(sys.argv[1])
teacher_units = str(sys.argv[2])
student_units = str(sys.argv[3])
student_value = str(sys.argv[4])

teacher_string = teacher_value + ' ' + teacher_units
student_string = student_value + ' ' + student_units

try:
	teacher_temperature = parse_temperature(teacher_string)
except:
	print 'invalid'
	sys.exit()

try:
	student_temperature = parse_temperature(student_string)
except:
	print 'incorrect'
	sys.exit()

if ('student: %.0f' % (round (teacher_temperature.toRankine() * 10) / 10)
	== 'student: %.0f' % (round (student_temperature.toRankine() * 10) / 10)):
		print 'correct'
else:
	print 'incorrect'