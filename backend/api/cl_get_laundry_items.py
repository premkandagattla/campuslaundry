from common.base_service import BaseService
from common.mysql import MYSQL

input_params = {'wash': 2001}


def post():
    service_info = CLGetLaundryItems()
    return service_info.execute_call()


class CLGetLaundryItems(BaseService):

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

            sp = "dbo.usp_get_laundry_items"

            results = MYSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code
