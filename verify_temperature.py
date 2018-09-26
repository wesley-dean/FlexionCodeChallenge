#!/usr/bin/env python

## @package verify_temperature
#  @brief This is the base / parent class for *Temperature classes
#  @details
#  The Temperature class is designed to be overridden by *Temperature
#  classes.  We store the temperature values on the Rankine scale 
#  for simplicity of comparison; we also provide accessor methods to
#  retrieve temperatures on different scales.

import re
from flask import Flask, request, render_template
import unittest

class Temperature:
## @class Temperature
#  @brief parent class for storing temperatures
#  @details
#  initialize the instance variable '_value; note, this is overridden
#  by other child classes that will perform calculations to a common
#  temperature scale for simplified comparison

 	## @fn __init__()
 	#  @brief initializer
 	#
 	#  @param value the numeric value of the temperature
	def __init__ (self, value):
		self._value = value


	## @fn __eq__()
	#  @brief comparison function
	#  @details
	#  this is the comparison magic function; because we store all
	#  values in a common scale, we can simply compare the normalized
	#  values to each-other
	#
	#  @retval true if the two temperatures, normalized, are equal; false, otherwise
	def __eq__(self, other):
		return self.normalize() == other.normalize()


	## @fn __str__()
	#  @brief cast temperature to a string
	#  @details
	#  so that we can concatenate temperature objects with strings,
	#  we provide a method to cast temperature values to strings;
	#  note, the value returned is on the Rankine scale
	#
	#  @retval temperature value represented as string
	def __str__(self):
		return self.normalize()


	## @fn toRankine()
	#  @brief return the temperature on the Rankine scale
	#  @details
	#  we store all values on the Rankine scale; therefore we don't
	#  need to do anything special to return a Rankine value
	#
	#  @retval temperature value on the Rankine scale as a float
	def toRankine(self):
		return self._value


	## @fn toKelvin()
	#  @brief return the temperature on the Kelvin scale
	#
	#  @retval temperature value on the Kelvin scale as a float
	def toKelvin(self):
		return self._value * (5 / 9)


	## @fn toCelsius()
	#  @brief return the temperature on the Celsius scale
	#
	#  @retval temperature value on the Celsius scale as a float
	def toCelsius(self):
		return (self._value - 491.67) * (5 / 9)


	## @fn toFarenheit()
	#  @brief return the temperature on the Farenheit scale
	#
	#  @retval temperature value on the Farenheit scale as a float
	def toFarenheit(self):
		return self._value - 459.67


	## @fn normalize()
	#  @brief normalize a number by rounding it to one decimal point
	#
	#  @retval string of the temperature in Rankine, rounded to 1 decimal point
	def normalize(self):
		return str('%.0f' % (round (self.toRankine() * 10) / 10))

## @class CelsiusTemperature
#  @brief child class to represent temperatures in Celsius
class CelsiusTemperature(Temperature):
	def __init__(self,value):
		Temperature.__init__(self, (value + 273.15) * 9 / 5)


## @class FarenheitTemperature
#  @brief child class to represent temperatures in Farenheit
class FarenheitTemperature(Temperature):
	def __init__(self, value):
		Temperature.__init__(self, value + 459.67)


## @class KelvinTemperature
#  @brief child class to represent temperatures in Kelvin

class KelvinTemperature(Temperature):
	def __init__(self, value):
		Temperature.__init__(self, value * 9 / 5)


## @class RankineTemperature
#  @brief child class to represent temperatures in Rankine

class RankineTemperature(Temperature):
	def __init__(self, value):
		Temperature.__init__(self, value)




## @fn parse_temperature()
#  @brief parse a string and return a *Temperature object
#  @details
#  given a string (e.g., '212 Farenheit'), parse out the
#  temperature value (212) and units (Farenheit) and return
#  an object that represents the temperature that was passed
#
#  for ease of use, a regular expression is used to separate
#  the value from the units; moreover, only the first character
#  of the units is examined (and even then in lower-case);
#  whitespace is ignored
#
#  therefore, '212f and '212 Farenheit' and '212 fuzzy ballons'
#  all return a FarenheitTemperature object that represents 212
#  degrees Farehneit
#
#  if the temperature units doesn't match a recognized unit,
#  throw an 'invalid units' exception
#
#  finally, the value can only consist of numbers 0-9, ., and -
#  so, if an invalid value is passed (e.g., 'dog') then the
#  string won't match and the exception will be raised
#
# @param string the string to parse, value followed by units
# @retval *Temperature object
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


## fn verify_temperature()
#  @briefcompare two temperatures
#  @detailed
#  We accept two strings for comparison; one is what the teacher provides and one is
#  the combination of the student's response plus the required units.  We parse
#  those strings to create *Temperature objects, then compare their normalized
#  forms to determine if the correct answer was provided
#
#  @param teacher_string the string (value + space + units) passed for the correct answer
#  @param student_string the string (student reponse + space + required units)
#
#  @retval string "correct" if correct; "invalid" if teacher value isn't a number; "incorrect" otherwise
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


class TestIntegrations(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    def testcase0(self):
        response = self.app.get('/')
        assert b'input type' in response.data

    def testcase1(self):
        response = self.app.post('/verify', data=dict(teacher_string="84.2 Farenheitf", student_value="543.5", student_units="Rankine"))
        assert b'>correct<' in response.data

    def testcase2(self):
        response = self.app.post('/verify', data=dict(teacher_string="-45.2 Celsius", student_value="227.51", student_units="Kelvin"))
        assert b'>correct<' in response.data

    def testcase3(self):
        response = self.app.post('/verify', data=dict(teacher_string="317.33 Kelvin", student_value="110.5", student_units="Farenheit"))
        assert b'>incorrect<' in response.data

    def testcase4(self):
        response = self.app.post('/verify', data=dict(teacher_string="444.5 Rankine", student_value="-39.9", student_units="Celsius"))
        assert b'>incorrect<' in response.data

    def testcase5(self):
        response = self.app.post('/verify', data=dict(teacher_string="6.5 Farenheit", student_value="dog", student_units="Rankine"))
        assert b'>incorrect<' in response.data

    def testcase6(self):
        response = self.app.post('/verify', data=dict(teacher_string="dog Celsius", student_value="45.31", student_units="Celsius"))
        assert b'>invalid<' in response.data

# we use the Flask microframework to make it go; so, initialize it
app = Flask(__name__)

# if we have no path, return the rendered form
@app.route('/')
def home():
  return render_template('index.html.j2')

# if we have a path of '/verify', it's generally from a form
# submission, so extract the form fields, parse them,
# pass them along to be verified, and drop the result in
# the 'verify' template.
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

if __name__ == '__main__':
    unittest.main()
