import uuid
import sys

import mysql.connector

from common import aes
from common.constants import log_err_message
from common.configparser_lib import ConfigReader
from datetime import datetime, date
from dotenv import dotenv_values

env_values = dotenv_values(".env")


class MYSQL:
    """
    A utility class for MSSql database operations.
    """

    @staticmethod
    def connect():
        """
        Creates a connection to the given MSSql server.

        Returns:
            MSSql.Connection: The connection to the MSSql server.
        """
        conn = None
        func_name = f"{__name__}.MSSql.connect"
        try:
            username = env_values['USERNAME']
            passwd = aes.decrypt(env_values['PASSWORD'])
            dbname = ConfigReader.getconfig('database', 'dbname')
            server_name = ConfigReader.getconfig('database', 'server')
            port = ConfigReader.getconfig('database', 'port')

            if username is None or passwd is None or dbname is None or server_name is None:
                raise Exception("Failed to fetch DB Creds")

            server_windows = sys.platform

            if server_windows == "win32":
                server_name = '127.0.0.1'

            conn = mysql.connector.connect(user=username, password=passwd,
                                           host=server_name,
                                           port=port,
                                           database=dbname)
        except Exception as e:
            log_err_message(func_name, str(e))
            raise e
        return conn

    @staticmethod
    def execute_sp_with_columns(conn, store_proc, params):
        """
        Description: execute store given procedure

        parames:

             conn: connection object
             store_proc: store procedure

        return:
            Executed store procedure result with columns. Ex:[{key: value},...]
        """
        func_name = __name__ + ".execute_sp_with_columns"
        cursor = None
        result = []
        try:
            cursor = conn.cursor()

            if len(params) > 0:
                cursor.callproc(store_proc, tuple(params))
            else:
                cursor.callproc(store_proc)

            conn.commit()

            result = []

            for result_set in cursor.stored_results():
                cols = result_set.column_names
                rows = result_set.fetchall()

                for row in rows:
                    row_dict = dict(zip(cols, row))
                    for i, j in row_dict.items():
                        try:
                            if isinstance(j, memoryview):
                                row_dict[i] = str(uuid.UUID(bytes_le=str(j)))
                            elif type(j) == datetime or type(j) == date:
                                row_dict[i] = j.isoformat()
                            elif type(j) == bytearray:
                                row_dict[i] = str(uuid.UUID(bytes_le=str(j)))
                            elif j == 'true':
                                row_dict[i] = True
                            elif j == 'false':
                                row_dict[i] = False
                        except Exception as e:
                            row_dict[i] = None
                    result.append(row_dict)
        except Exception as e:
            raise Exception("module={module}, error={error}".format(module=func_name, error=str(e)))
        return result

    @staticmethod
    def execute_sp_with_mtable_columns(conn, store_proc, params):
        """
        Description: execute store given procedure

        parames:

             conn: connection object
             store_proc: store procedure

        return:
            Executed store procedure result with columns. Ex:[{key: value},...]
        """
        func_name = __name__ + ".execute_sp_with_columns"
        cursor = None
        result = []
        try:
            cursor = conn.cursor()

            if len(params) > 0:
                cursor.callproc(store_proc, tuple(params))
            else:
                cursor.callproc(store_proc)

            conn.commit()

            result = []

            for result_set in cursor.stored_results():
                cols = result_set.column_names
                rows = result_set.fetchall()
                sub_results = []
                for row in rows:
                    row_dict = dict(zip(cols, row))
                    for i, j in row_dict.items():
                        try:
                            if isinstance(j, memoryview):
                                row_dict[i] = str(uuid.UUID(bytes_le=str(j)))
                            elif type(j) == datetime or type(j) == date:
                                row_dict[i] = j.isoformat()
                            elif type(j) == bytearray:
                                row_dict[i] = str(uuid.UUID(bytes_le=str(j)))
                            elif j == 'true':
                                row_dict[i] = True
                            elif j == 'false':
                                row_dict[i] = False
                        except Exception as e:
                            row_dict[i] = None
                    sub_results.append(row_dict)
                result.append(sub_results)
        except Exception as e:
            raise Exception("module={module}, error={error}".format(module=func_name, error=str(e)))
        return result
