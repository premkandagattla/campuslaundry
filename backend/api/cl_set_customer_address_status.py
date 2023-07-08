from common.base_service import BaseService
from collections import OrderedDict

from common.mysql import MYSQL

input_params = OrderedDict()
input_params['customer_id'] = 1007
input_params['address_id'] = 1015
input_params['active'] = 8000


def post():
    service_info = CLSetCustomerAddressStatus()
    return service_info.execute_call()


class CLSetCustomerAddressStatus(BaseService):

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
        conn = None
        try:
            input_dict = self.get_input_dict()
            for key, value in input_params.items():
                if key in input_dict:
                    params_list.append(input_dict[key])
                else:
                    params_list.append(None)

            conn = MYSQL.connect()

            sp = "dbo.usp_set_customer_address_status"

            results = MYSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code