import json

from common.base_service import BaseService
from common.mssql import MSSQL
from collections import OrderedDict

input_params = OrderedDict()
input_params['customer_id'] = 1007
input_params['items_count'] = 3002
input_params['total_price'] = 3004
input_params['laundry_type'] = 3005
input_params['laundry_items'] = 3006
input_params['order_weight'] = 3003
input_params['subscribed_id'] = 5001
input_params['order_id'] = 3001


def post():
    service_info = CLSetCustomerOrder()
    return service_info.execute_call()


class CLSetCustomerOrder(BaseService):

    def __init__(self):
        super().__init__()

    def check_duplicates(self, json_data):
        products = [item['product_id'] for item in json_data]
        unique_products = set(products)

        if len(products) == len(unique_products):
            return True
        else:
            duplicated_products = [product for product in unique_products if products.count(product) > 1]
            self.get_response_body.header.error_code = 3006
            self.get_response_body.header.status = 400
            print("Duplicated products found")
            print(duplicated_products)
            raise Exception(f"Duplicated product_ids found")

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
                    if key == 'laundry_items' and self.check_duplicates(input_dict[key]):
                        params_list.append(json.dumps(input_dict[key]))
                    else:
                        params_list.append(input_dict[key])
                else:
                    params_list.append(None)

            conn = MSSQL.connect()

            sp = "[dbo].[usp_set_customer_order]"

            results = MSSQL.execute_sp_with_columns(conn, sp, params_list)
            self.get_response_body.results = results
            return_val, status_code = self.get_success_response(results)

        except Exception as ex:
            return_val, status_code = self.get_exception_response(str(ex))
        finally:
            if conn is not None:
                conn.close()
        return return_val, status_code