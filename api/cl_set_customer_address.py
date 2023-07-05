from common.base_service import BaseService
from common.mssql import MSSQL

input_params = {
    'customer_id': 1007,
    'street': 1008,
    'city': 1009,
    'province': 1010,
    'postal_code': 1011,
    'country': 1012,
    'latitude': 1013,
    'longitude': 1014,
    'address_id': 1015,
}


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

            conn = MSSQL.connect()

            sp = "[dbo].[usp_set_customer_address]"

            results = MSSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code