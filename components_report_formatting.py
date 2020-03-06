import csv
import time
import datetime
import sys

csv_filepath = sys.argv[1]

print("app_id,timestamp,proportional_component,derivative_component,integral_component,calculated_action")

with open(csv_filepath, newline='') as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=',', quotechar='|')
    csv_data = []
    for row in csv_reader:
        csv_data.append(row)           

    app_id = ""
    first_timestamp = 0

    for i in range(0, len(csv_data), 4):
        proportional_component = csv_data[i][3]
        derivative_component = csv_data[i + 1][3]
        integral_component = csv_data[i + 2][3]
        calculated_action = csv_data[i + 3][3]
        data_app_id = csv_data[i][1]

        timestamp = time.mktime(datetime.datetime.strptime(csv_data[i][0],"%Y-%m-%d_%H:%M:%S").timetuple())
        
        if app_id != data_app_id:
            app_id = data_app_id
            first_timestamp = timestamp

        print("%s,%s,%s,%s,%s,%s" % (app_id, timestamp - first_timestamp, proportional_component, derivative_component, integral_component, calculated_action))

