#!/usr/local/bin/python
import json
from decimal import Decimal


class DecEncoder(json.JSONEncoder):

    def default(self, obj):
        """
        default method is used if there is an unexpected object type
        in our example obj argument will be Decimal('120.50') and datetime
        in this encoder we are converting all Decimal to float and datetime to str
        """
        # =======================================================================
        # if isinstance(obj, datetime):
        #     obj = str(obj)
        # =======================================================================
        if isinstance(obj, Decimal):
            obj = float(obj)
        else:
            obj = super(DecEncoder, self).default(obj)
        return obj


class JsonSerializable(object):

    def datetime(self, date_time):
        return json.dumps(date_time.isoformat())

    def to_json(self):
        try:
            return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True).replace("\\\"", '')
        except Exception as e:
            raise Exception("Error Serializing JSOn " + str(e))

    def to_dec_encoder(self, result):
        try:
            return json.dumps(result, cls=DecEncoder)
        except Exception as e:
            raise Exception("Error Serializing JSOn " + str(e))
