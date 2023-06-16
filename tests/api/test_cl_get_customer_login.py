import pytest
import mock
from mock import patch
from common.mssql import MSSQL
from api.cl_get_customer_login import post, CLGetCustomerLogin

input_params = {'email': 1001, 'password': 1002}


@pytest.fixture
def mock_mssql_connect():
    """
    Mocks the MSSQL.connect() function
    """
    with patch("common.mssql.MSSQL.connect") as mock_connect:
        yield mock_connect


@pytest.fixture
def mock_mssql_execute_sp_with_columns():
    """
    Mocks the MSSQL.execute_sp_with_columns() function
    """
    with patch("common.mssql.MSSQL.execute_sp_with_columns") as mock_execute_sp:
        yield mock_execute_sp


@pytest.fixture
def mock_class():
    with patch("api.cl_get_customer_login.CLGetCustomerLogin") as mock_class:
        yield mock_class


@pytest.fixture
def mock_aes_encrypt():
    """
    Mocks the aes.encrypt() function
    """
    with patch("common.aes.encrypt") as mock_encrypt:
        yield mock_encrypt


def test_post_with_valid_input(mock_class):

    results = [("John Doe", "john.doe@example.com")]

    mock_instance = mock_class.return_value
    mock_instance.execute_call.return_value = results

    # Call the post() function
    result = post()

    # Assert the expected result
    assert result == results



