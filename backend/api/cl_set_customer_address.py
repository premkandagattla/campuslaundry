from common.base_service import BaseService

from collections import OrderedDict

from common.mysql import MYSQL

input_params = OrderedDict()

input_params['customer_id'] = 1007
input_params['street'] = 1008
input_params['city'] = 1009
input_params['province'] = 1010
input_params['postal_code'] = 1011
input_params['country'] = 1012
input_params['latitude'] = 1013
input_params['longitude'] = 1014
input_params['address_id'] = 1015


def post():
    service_info = CLSetCustomerAddress()
    return service_info.execute_call()


class CLSetCustomerAddress(BaseService):

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

            sp = "dbo.usp_set_customer_address"

            results = MYSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code