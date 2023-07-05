from common import aes
from common.base_service import BaseService
from common.mssql import MSSQL

from collections import OrderedDict

input_params = OrderedDict()
input_params['email'] = 1001
input_params['password'] = 1002


def post():
    service_info = CLGetCustomerLogin()
    return service_info.execute_call()


class CLGetCustomerLogin(BaseService):

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
                    if key == 'password':
                        params_list.append(aes.encrypt(input_dict[key]))
                    else:
                        params_list.append(input_dict[key])
                else:
                    self.get_response_body.header.error_code = value
                    self.get_response_body.header.status = 400
                    raise Exception(f'Invalid input parameter: {key}')

            conn = MSSQL.connect()

            sp = '[dbo].[usp_get_customer_login]'

            results = MSSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code
