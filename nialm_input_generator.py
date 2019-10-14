import os
import swiftclient
import sys


def publish_result(container_name, key, value):
    os_options = {'project_name': os.environ['OS_PROJECT_NAME'],
                  'project_domain_name': os.environ['OS_PROJECT_DOMAIN_NAME'],
                  'user_domain_name': os.environ['OS_USER_DOMAIN_NAME']}

    conn = swiftclient.Connection(
       os.environ['OS_AUTH_URL'],
       os.environ['OS_USERNAME'],
       os.environ['OS_PASSWORD'],
       auth_version=3,
       os_options=os_options
    )
    print(value)
    conn.put_object(container_name, key, value)
    conn.close()


if __name__ == '__main__':
    swift_api_url = sys.argv[1]
    container_name = sys.argv[2]
    number_of_load_files = int(sys.argv[3])

    base_filename = sys.argv[4]
    sensor_ID = sys.argv[5]
    base_start_timestamp = int(sys.argv[6])
    base_end_timestamp = int(sys.argv[7])
    load_file_lines = []

    for i in range(-number_of_load_files/2, number_of_load_files/2, 1):
        start_timestamp = base_start_timestamp + i
        end_timestamp = base_end_timestamp + i

        filename = "{}-{}-{}".format(base_filename, start_timestamp, end_timestamp)
        load_file_line = "{};{};{}".format(sensor_ID, start_timestamp, end_timestamp)
        publish_result(container_name, filename, load_file_line)
        load_file_lines.append("{}{}{}{}".format(swift_api_url, container_name, os.sep, filename))
 
    publish_result(container_name, "{}-list".format(base_filename), "\n".join(load_file_lines))
