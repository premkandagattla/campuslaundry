// const stripe = require('stripe')('sk_test_51Ncz1XD6NSHlZgPuAQsxz87Le7Q2rVxe2xM91SRqXawjyzC3TTq26CH1cgeAyKT4HvKqlgvmeqc3islZsuBdj3Ja00EG1y4UFw');
// const express = require('express');
// const app = express();
// const cors = require('cors');

// app.use(express.static('public'));
// app.use(express.json());

// app.use(cors());

// const DOMAIN = 'http://localhost:4242';
// const FE_DOMAIN = 'http://localhost:5173';


// // app.post('/process-order', async (req, res) => {
// //   const { totalPrice,lastOrder } = req.body;

// //   const unit_amount = Math.round(totalPrice * 100); 

// //   const session = await stripe.checkout.sessions.create({
// //       line_items: [
// //           {
// //               price_data: {
// //                   currency: 'cad',
// //                   product_data: {
// //                       name: 'Wash and Iron',
// //                   },
// //                   unit_amount: unit_amount,
// //               },
// //               quantity: 1,
// //           },
// //       ],
// //       mode: 'payment',
// //       success_url: `${FE_DOMAIN}/orderstatus.html`,
// //       cancel_url: `${DOMAIN}/cancel.html`,
// //   });

// //   res.json({ sessionUrl: session.url });
// // });


// // app.listen(4242, () => console.log('Running on port 4242'));

// const API_ENDPOINT = 'http://127.0.0.1:5000/campus-laundry';  

// let orderId = 0;
// let custId = 0;
// app.post('/process-order', async (req, res) => {
//     const { totalPrice,lastOrder,customerId } = req.body;
//     const unit_amount = Math.round(totalPrice * 100); 
//     orderId = lastOrder;
//     custId = customerId;

//     const session = await stripe.checkout.sessions.create({
//         line_items: [{
//             price_data: {
//                 currency: 'cad',
//                 product_data: {
//                     name: 'Wash and Iron',
//                 },
//                 unit_amount: unit_amount,
//             },
//             quantity: 1,
//         }],
//         mode: 'payment',
//         success_url: `${FE_DOMAIN}/orderstatus.html`,
//         cancel_url: `${DOMAIN}/cancel.html`,
//     });

//     res.json({ sessionUrl: session.url });
// });

// app.post('/stripe-webhook', express.raw({type: 'application/json'}), async (req, res) => {
//     const sig = req.headers['stripe-signature'];

//     let event;
//     try {
//         event = stripe.webhooks.constructEvent(req.body, sig, 'whsec_13374000ae3f466d08a7b88ae60e290a12679a3684e2cd5c0ffead73c24aada8'); 
//     } catch (err) {
//         return res.status(400).send(`Webhook Error: ${err.message}`);
//     }

//     if (event.type === 'checkout.session.completed') {
//         const session = event.data.object;


//         const headers = {
//             'Content-Type': 'application/json'
//         };
//         const data = {
//             "customer_id": custId,
//             "order_id": orderId,
//             "payment_status": "success"
//         };

//         fetch(`${API_ENDPOINT}/cl_set_payment_status`, {
//             method: 'POST',
//             headers: headers,
//             body: JSON.stringify(data)
//         })
//         .then(response => response.json())
//         .then(data => {
//             console.log('Payment status updated:', data);
//         })
//         .catch(error => console.error('Error:', error));
//     }

//     res.json({ received: true });
// });

// app.listen(4242, () => console.log('Running on port 4242'));

require('dotenv').config();
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const express = require('express');
const app = express();
const cors = require('cors');
const fetch = require('node-fetch');

app.use(express.static('public'));
app.use(express.json());

app.use(cors());

const DOMAIN = process.env.DOMAIN || 'http://localhost:4242';
const FE_DOMAIN = process.env.FE_DOMAIN || 'http://localhost:8080';

// let orderIdnew = 0;
// let custId = 0;
    

app.post('/process-order', async (req, res) => {
  const { totalPrice,orderId,customerId } = req.body;
  const unit_amount = Math.round(totalPrice * 100); 
  const orderIdnew = parseInt(orderId, 10);  // Base 10 for the parseInt function
  const custId = parseInt(customerId, 10);   // Base 10 for the parseInt function
  const pay = "dkpsa";
    const session = await stripe.checkout.sessions.create({
        line_items: [{
            price_data: {
                currency: 'cad',
                product_data: {
                    name: 'Wash and Iron',
                },
                unit_amount: unit_amount,
            },
            quantity: 1,
        }],
        mode: 'payment',
        success_url: `${FE_DOMAIN}/orderstatus.html?customerId=${custId}&orderId=${orderIdnew}&pay=${pay}`,
        cancel_url: `${DOMAIN}/cancel.html`,
        metadata: {
          order_id: orderIdnew,
          customer_id: custId
      },
    });

    res.json({ sessionUrl: session.url });
});

app.post('/webhook', express.raw({ type: 'application/json' }), async (req, res) => {
    const sig = req.headers['stripe-signature'];

    let event;

    try {
      const event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
        } catch (err) {
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    if (event.type === 'checkout.session.completed') {
        const session = event.data.object;
        const orderId = parseInt(session.metadata.order_id, 10);
        const custId = parseInt(session.metadata.customer_id, 10);


        // Now you can make a POST request to update the payment status
        const apiUrl = 'http://127.0.0.1:5000/campus-laundry/cl_set_payment_status'; 
        const headers = {
            'Content-Type': 'application/json'
        };
        const data = {
            "customer_id": custId,   
            "order_id": orderId,
            "payment_status": "success"
        };

        fetch(apiUrl, {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(data => {
            console.log("Payment status updated:", data);
        })
        .catch(error => console.error('Error updating payment status:', error));
    }

    res.json({ received: true });
});

app.listen(4242, () => console.log('Running on port 4242'));
