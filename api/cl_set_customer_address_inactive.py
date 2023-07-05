from common.base_service import BaseService
from common.mssql import MSSQL
from collections import OrderedDict

input_params = OrderedDict()
input_params['customer_id'] = 1007
input_params['address_id'] = 1015


def post():
    service_info = CLSetCustomerAddressInactive()
    return service_info.execute_call()


class CLSetCustomerAddressInactive(BaseService):

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

            conn = MSSQL.connect()

            sp = "[dbo].[usp_set_customer_address_inactive]"

            results = MSSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code