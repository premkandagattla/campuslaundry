import pytest
import mock
from mock import patch
from common.constants import RESULTS, MESSAGE, ERROR_CODE
from api.cl_get_laundry_items import post, CLGetLaundryItems


@pytest.fixture
def mock_mssql_connect():
    """
    Mocks the MSSQL.connect() function
    """
    with patch("common.mysql.MYSQL.connect") as mock_connect:
        yield mock_connect


@pytest.fixture
def mock_mssql_execute_sp_with_columns():
    """
    Mocks the MSSQL.execute_sp_with_columns() function
    """
    with patch("common.mysql.MYSQL.execute_sp_with_columns") as mock_execute_sp:
        yield mock_execute_sp


@pytest.fixture
def mock_class():
    with patch("api.cl_get_laundry_items.CLGetLaundryItems") as mock_class:
        yield mock_class


def test_get_with_class(mock_class):
    rows = [("John", "Doe"), ("Jane", "Smith")]
    mock_instance = mock_class.return_value
    mock_instance.execute_call.return_value = rows

    # Call the get() function
    result = post()

    # Assert the expected result
    assert result == rows


