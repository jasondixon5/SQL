#! /usr/bin/env python

# education_import.py - a script to import UIS education data
# Note that mysql connector doesn't seem to be compatible with Python3



#query = ("SELECT description FROM indicators WHERE code = '20070'")
#query = ""
#cursor.execute(query)

#for (description,) in cursor:
#    print(description)

#cursor.close()
#cnx.close()
"""
Columns in file:
EDULIT_IND-0	Indicator-1	LOCATION-2	Country-3	TIME-4	Time-5	Value-6	Flag Codes-7	Flags-8
"""
import csv
csvFileObj = open('/Users/jasondixon/projects/Nepal/Education Data_All Indicators_UIS_export_to_db.csv')
csvReader = csv.reader(csvFileObj)

import mysql.connector

config = {
  'user': 'root',
  'password': 'xxxxxx',
  'host': '127.0.0.1',
  'database': 'indicators',
  'raise_on_warnings': True,
}

cnx = mysql.connector.connect(**config)

cursor = cnx.cursor()

IC_IDX = 0
INDICATOR_IDX = 1
COUNTRYCODE_IDX = 2
COUNTRY_IDX = 3
YEAR_IDX = 4
YEAR2_IDX = 5
VALUE_IDX = 6
FLAGCODE_IDX = 7
FLAGS = 8

# If value is missing csv reader will return empty string so this returns none instead or value if has a value
# Return None instead of 0 to show data is missing rather than value for that indicator is 0
def clean_missing_data(value):
    return None if value == '' else float(value)
    
def convert_percent_to_ratio(indicator_description, value):
    if indicator_description.endswith('(%)'):
        return value/100
    else:
        return value
        
def scrub_values(indicator_description, value):
    cleaned_data = clean_missing_data(value)
    if cleaned_data == None:
        return cleaned_data
    else:
        return convert_percent_to_ratio(indicator_description, cleaned_data)
    
for row in csvReader:
    ic = row[IC_IDX]
    cc = row[COUNTRYCODE_IDX]
    yr = row[YEAR_IDX]
    v = scrub_values(row[INDICATOR_IDX], row[VALUE_IDX])    
    print(ic, cc, yr, v)
    query = ("INSERT INTO data (indicator_code, country_code, year, value) VALUES (%s, %s, %s, %s)")
    cursor.execute(query, (ic, cc, yr, v))

cnx.commit()
cursor.close()
cnx.close()
