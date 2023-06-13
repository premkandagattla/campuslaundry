import connexion
import json
from common.json_lib import JsonSerializable
from datetime import datetime


class BaseService:
    def __init__(self):
        self.start_time = datetime.now()
        self.input_data = connexion.request.get_json(force=True)
        self.get_response_body = JsonSerializable()
        header = JsonSerializable()
        header.error_code = None
        header.error_message = None
        header.status = None
        header.rows_returned = None
        header.time_taken = None
        self.get_response_body.header = header

    def get_input_dict(self):
        return self.input_data

    def get_success_response(self, results):
        rows = len(results)
        self.get_response_body.header.status = 200
        self.get_response_body.header.error_code = 0
        self.get_response_body.header.error_message = ""
        self.get_response_body.header.rows_returned = rows
        self.get_response_body.header.time_taken = (datetime.now() - self.start_time).total_seconds()
        return json.loads(self.get_response_body.to_json()), self.get_response_body.header.status

    def get_exception_response(self, message):
        if self.get_response_body.header.status is None:
            self.get_response_body.header.status = 500
        if self.get_response_body.header.error_code is None:
            self.get_response_body.header.error_code = 1000
        self.get_response_body.header.error_message = message
        self.get_response_body.header.time_taken = (datetime.now() - self.start_time).total_seconds()
        self.get_response_body.results = []
        return json.loads(self.get_response_body.to_json()), self.get_response_body.header.status
