import pytest
import mock
from mock import patch
from common.constants import RESULTS, MESSAGE, ERROR_CODE
from common.mssql import MSSQL
from api.cl_get_all_employees import get, CLGetAllEmployeesData


@pytest.fixture
def mock_mssql_connect():
    """
    Mocks the MSSQL.connect() function
    """
    with patch("common.mssql.MSSQL.connect") as mock_connect:
        yield mock_connect


@pytest.fixture
def mock_mssql_execute_query_with_columns():
    """
    Mocks the MSSQL.execute_query_with_columns() function
    """
    with patch("common.mssql.MSSQL.execute_query_with_columns") as mock_execute_query:
        yield mock_execute_query


def test_get_with_data(mock_mssql_connect, mock_mssql_execute_query_with_columns):
    # Mock the return value of MSSQL.connect()
    conn_mock = mock.MagicMock()
    mock_mssql_connect.return_value = conn_mock

    # Mock the return value of MSSQL.execute_query_with_columns()
    rows = [("John", "Doe"), ("Jane", "Smith")]
    mock_mssql_execute_query_with_columns.return_value = rows

    # Call the get() function
    result = get()

    # Assert the expected result
    assert result == {RESULTS: rows}


def test_get_with_no_data(mock_mssql_connect, mock_mssql_execute_query_with_columns):
    # Mock the return value of MSSQL.connect()
    conn_mock = mock.MagicMock()
    mock_mssql_connect.return_value = conn_mock

    # Mock the return value of MSSQL.execute_query_with_columns()
    rows = []
    mock_mssql_execute_query_with_columns.return_value = rows

    # Call the get() function
    result = get()

    # Assert the expected result
    assert result == {RESULTS: None}


def test_get_with_exception(mock_mssql_connect, mock_mssql_execute_query_with_columns):
    # Mock the exception raised by MSSQL.connect()
    mock_mssql_connect.side_effect = Exception("Connection failed")

    # Call the get() function
    result = get()

    # Assert the expected result
    assert result == {ERROR_CODE: 400, MESSAGE: 'Something went wrong !!!'}
