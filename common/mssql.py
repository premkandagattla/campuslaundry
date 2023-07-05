import socket
import uuid
import sys

import pyodbc

from common import aes
from common.constants import log_err_message
from common.configparser_lib import ConfigReader
from datetime import datetime
from dotenv import dotenv_values

env_values = dotenv_values(".env")


class MSSQL:
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
            driver = ConfigReader.getconfig('database', "driver", None)
            port = ConfigReader.getconfig('database', "port", None)
            tds_version = ConfigReader.getconfig('database', "tds_version", None)

            if username is None or passwd is None or dbname is None or server_name is None:
                raise Exception("Failed to fetch DB Creds")

            server_windows = sys.platform

            if server_windows == 'win32':
                con_str = "DRIVER={driver};SERVER={servername};PORT={port};UID={user};PWD={password};DATABASE={database};TDS_Version={tds_version};TIMEOUT={timeout}"
                con_str = con_str.format(driver=driver, servername=server_name, port=port, user=username,
                                         password=passwd, database=dbname, tds_version=tds_version, timeout=5)

            else:
                driver = '{ODBC Driver 18 for SQL Server}'
                con_str = "DRIVER={driver};SERVER={servername};DATABASE={database};UID={user};PWD={password}"
                con_str = con_str.format(driver=driver, servername=server_name + ',' + port, user=username,
                                         password=passwd, database=dbname)

            conn = pyodbc.connect(con_str)

        except Exception as e:
            log_err_message(func_name, str(e))
            raise e
        return conn

    @staticmethod
    def execute_query_with_columns(conn, query, **kwargs):
        """
        Executes a parameterized query on a MSSql connection.

        Args:
            conn (MSSQL.Connection): The connection to the MSSql server.
            query (str): The parameterized query to execute.
            **kwargs: The parameter values to substitute in the query.

        Returns:
            list: The results of the query as a list of dictionaries.
        """
        func_name = f"{__name__}.MySql.execute_query_with_params"
        cursor = None
        data = []
        sql = query
        try:
            cursor = conn.cursor()
            cursor.execute(query)
            cols = [d[0].lower() for d in cursor.description]
            fetch_result = cursor.fetchall()
            for row in fetch_result:
                for i, j in enumerate(row):
                    try:
                        if isinstance(j, memoryview):
                            row[i] = str(uuid.UUID(bytes_le=str(j)))
                        elif type(j) == datetime:
                            row[i] = j.isoformat()
                        elif type(j) == bytearray:
                            row[i] = str(uuid.UUID(bytes_le=str(j)))
                    except Exception as e:
                        row[i] = None
            for rs in fetch_result:
                zip_data = dict(zip(cols, rs))
                data.append(zip_data)
        except Exception as e:
            log_err_message(func_name, str(e))
        finally:
            if cursor is not None:
                cursor.close()
        return data

    @staticmethod
    def execute_query_with_params(conn, query, **kwargs):
        """
        Executes a parameterized query on a MSSql connection.

        Args:
            conn (MSSQL.Connection): The connection to the MSSql server.
            query (str): The parameterized query to execute.
            **kwargs: The parameter values to substitute in the query.

        Returns:
            list: The results of the query as a list of dictionaries.
        """
        func_name = f"{__name__}.MySql.execute_query_with_params"
        cursor = None
        data = []
        sql = query
        try:
            cursor = conn.cursor()
            params = {k: v for k, v in kwargs.items()}
            cursor.execute(query, params)
            cols = [d[0].lower() for d in cursor.description]
            fetch_result = cursor.fetchall()
            for row in fetch_result:
                for i, j in enumerate(row):
                    try:
                        if isinstance(j, memoryview):
                            row[i] = str(uuid.UUID(bytes_le=str(j)))
                        elif type(j) == datetime:
                            row[i] = j.isoformat()
                        elif type(j) == bytearray:
                            row[i] = str(uuid.UUID(bytes_le=str(j)))
                    except Exception as e:
                        row[i] = None
            for rs in fetch_result:
                zip_data = dict(zip(cols, rs))
                data.append(zip_data)
        except Exception as e:
            log_err_message(func_name, str(e))
        finally:
            if cursor is not None:
                cursor.close()
        return data

    @staticmethod
    def execute_sp_with_columns_post_auth_save(conn, store_proc):
        func_name = __name__ + ".execute_sp"
        cursor = None
        result = None
        sql = "exec {sp}".format(sp=store_proc)
        try:
            cursor = conn.cursor()
            cursor.execute(sql)
            data = cursor.fetchall()
            data = data[0][1]
            cursor.commit()
        except Exception as e:
            raise Exception("module={module}, error={error}".format(module=func_name, error=str(e)))
        return data

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
        result = None
        try:
            cursor = conn.cursor()

            if len(params) > 0:
                cursor.execute("{CALL " + store_proc + "(" + ",".join(["?"] * len(params)) + ")}",
                               params)
            else:
                cursor.execute("{CALL " + store_proc + "}")
            cols = [d[0].lower() for d in cursor.description]
            result = []
            data = cursor.fetchall()
            cursor.commit()
            for row in data:
                for i, j in enumerate(row):
                    try:
                        if isinstance(j, memoryview):
                            row[i] = str(uuid.UUID(bytes_le=str(j)))
                        elif type(j) == datetime:
                            row[i] = j.isoformat()
                        elif type(j) == bytearray:
                            row[i] = str(uuid.UUID(bytes_le=str(j)))
                    except Exception as e:
                        row[i] = None

            for rs in data:
                zip_data = dict(zip(cols, rs))
                result.append(zip_data)

        except Exception as e:
            raise Exception("module={module}, error={error}".format(module=func_name, error=str(e)))
        return result
