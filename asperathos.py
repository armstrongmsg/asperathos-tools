import requests
import sys


class BrokerException(Exception):
    pass


class BrokerClient:
    ERROR_STATUS = "error"
    FAILED_STATUS = "failed"
    TERMINATED_STATUS = "terminated"
    ONGOING_STATUS = "ongoing"
    COMPLETED_STATUS = "completed"
    ERROR_STATUSES = (ERROR_STATUS, FAILED_STATUS, TERMINATED_STATUS)

    TEMPLATE_CONTROL_PARAMETERS = {
        "max_size": 2,
        "actuator": "k8s_replicas",
        "check_interval": 5,
        "trigger_down": 25,
        "trigger_up": 15,
        "min_rep": 1,
        "max_rep": 1,
        "actuation_size": 1,
        "metric_source": "redis"
    }

    TEMPLATE_CMD = ["python3", "/wrapper.py"]

    TEMPLATE_MONITOR_INFO = {
        "expected_time": 10
    }

    TEMPLATE_VISUALIZER_INFO = {
        "datasource_type": "influxdb"
    }

    def __init__(self, broker_ip, broker_port):
        self.broker_ip = broker_ip
        self.broker_port = broker_port
        self.broker_url = "http://%s:%s" % (self.broker_ip, self.broker_port)
        self.redis_client = None

    def _get_submission(self, job_id):
        r = requests.get("{}/submissions/{}".format(self.broker_url, job_id))
        return r.json()

    def _stop_submission(self, job_id):
        r = requests.put("{}/submissions/{}/stop".format(self.broker_url, job_id), json={
            "enable_auth": False
        })
        return r.ok

    def get_status(self, job_id):
        r = self._get_submission(job_id)
        return str(r['status'])

    def _check_error_status(self, status):
        if status in self.ERROR_STATUSES:
            raise BrokerException()

    def stop_application(self, job_id):
        self._stop_submission(job_id)


if __name__ == "__main__":
    command = sys.argv[1]
    ip = sys.argv[2]
    port = int(sys.argv[3])
    job_id = sys.argv[4]
    broker = BrokerClient(ip, port)

    if command == "status":
        print(broker.get_status(job_id))
    elif command == "stop":
        broker.stop_application(job_id)
