from common import aes
from common.base_service import BaseService
from collections import OrderedDict

from common.mysql import MYSQL

input_params = OrderedDict()

input_params['customer_id'] = 1007
input_params['email'] = 1001
input_params['gender'] = 1005
input_params['date_of_birth'] = 1006
input_params['phone_number'] = 1008


def post():
    service_info = CLSetCustomerDetails()
    return service_info.execute_call()


class CLSetCustomerDetails(BaseService):
    def __init__(self):
        super().__init__()

    def execute_call(self):
        """
          executes the function call

        :return:
        """
        return_val = None
        status_code = None
        conn = None
        params_list = []
        try:
            input_dict = self.get_input_dict()
            for key, value in input_params.items():
                if key in input_dict:
                    params_list.append(input_dict[key])
                else:
                    self.get_response_body.header.error_code = value
                    self.get_response_body.header.status = 400
                    raise Exception(f'Invalid input parameter: {key}')

            conn = MYSQL.connect()

            sp = 'dbo.usp_set_customer_details'

            results = MYSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code

