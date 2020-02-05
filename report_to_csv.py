import json
import time
import datetime
import sys
import ntpath

print("filename,timestamp,error,replicas,job_progress,time_progress")

for file_path in sys.argv[1:]:
    js_file = open(file_path, "r")
    report_dict = json.load(js_file)
    file_name = ntpath.basename(file_path)

    report = report_dict['report']
    first_time = time.mktime(datetime.datetime.strptime(sorted(report)[0],"%Y-%m-%dT%H:%M:%SZ").timetuple())
    for key in sorted(report):
        timestamp = time.mktime(datetime.datetime.strptime(key,"%Y-%m-%dT%H:%M:%SZ").timetuple()) - first_time
        job_progress = report[key]['job_progress']
        error = report[key]['error']
        time_progress = report[key]['time_progress']
        replicas = report[key]['replicas']
        print("%s,%d,%f,%d,%f,%f" % (file_name, timestamp, error, replicas, job_progress, time_progress))

    js_file.close()
