// JavaScript file (api.js)
import axios from 'axios';

    const url = 'https://campuslaundry.azurewebsites.net/campus-laundry/cl_set_customer_registration';
    const data = {
      "email": "dhoni1dq@csk.com",
      "first_name": "Dhoni",
      "last_name": "MS",
      "password": "test#123"
    };
  
    const config = {
      headers: {
        'Content-Type': 'application/json'
      }
    };
    function onAnalyzeButtonClick() {
    axios.post(url, data, config)
      .then(response => {
        console.log(response.data);
        // Handle the response data here
      })
      .catch(error => {
        console.error(error);
        // Handle the error here
      });
  }
  