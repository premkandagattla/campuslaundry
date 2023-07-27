from common.base_service import BaseService
from common.mysql import MYSQL

from collections import OrderedDict

input_params = OrderedDict()

input_params['order_id'] = 5001
input_params['customer_id'] = 1001
input_params['order_status'] = 5002


def post():
    service_info = CLSetOrderStatus()
    return service_info.execute_call()


class CLSetOrderStatus(BaseService):

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
                params_list.append(input_dict[key])

            conn = MYSQL.connect()

            sp = "dbo.usp_set_order_status"

            results = MYSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code
