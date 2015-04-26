var express = require('express');
var router = express.Router();

var path = require('path');
var pg = require('pg');
var superagent = require('superagent');
var connectionString = require(path.join(__dirname, '../', 'config'));
/* Copyright 2013 PayPal */
"use strict";
var paypal_api = require('paypal-rest-sdk');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});


router.post('/add_user', function(req, res) {

  var results = [];

  // Grab data from http request
  var data = {name: req.body.name, login: req.body.login, photourl: req.body.photourl};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Insert Data
    var query = client.query("INSERT INTO \"user\"(id, \"name\", \"login\", \"photourl\")VALUES (DEFAULT, $1, $2, $3) RETURNING *",
        [data.name, data.login, data.photourl]);

    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });
});

router.post('/list_users', function(req, res) {

  var results = [];

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM public.user;");

    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });

});


router.put('/users/:user_id', function(req, res) {

  var results = [];

  // Grab data from the URL parameters
  var id = req.params.user_id;

  // Grab data from http request
  var data = {text: req.body.text, complete: req.body.complete};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Update Data
    client.query("UPDATE public.user SET text=($1), complete=($2) WHERE id=($3)", [data.text, data.complete, id]);

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM public.user ORDER BY id ASC");

    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });

});

router.delete('/users/:user_id', function(req, res) {

  var results = [];

  // Grab data from the URL parameters
  var id = req.params.user_id;


  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Delete Data
    client.query("DELETE FROM public.user WHERE id=($1)", [id]);

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM public.user ORDER BY id ASC");

    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });

});


//// bikes

router.post('/add_bike', function(req, res) {

  var results = [];

  // Grab data from http request
  var data = {owner_fk: req.body.owner_fk, latitude: req.body.latitude, longitude: req.body.longitude};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Insert Data
    var query = client.query("INSERT INTO public.bike(id, owner_fk, \"location\", available) VALUES (DEFAULT, $1, POINT($2, $3), true) RETURNING *",
        [data.owner_fk, data.latitude, data.longitude]);

    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });
});


router.post('/list_bikes', function(req, res) {
  var results = [];

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {
      var listPicturesQuery = "SELECT * FROM picture;";
      client.query(listPicturesQuery, [], function(err, result) {
          if (err) {
              console.log(err);
          } else {
              var pictures = {};
              for (var i = 0; i < result.rows.length; i++) {
                  var picture = result.rows[i];
                  var array = pictures[picture["bike_fk"]];
                  if (array == null) {
                      array = [];
                      pictures[picture["bike_fk"]] = array;
                  }
                  array.push(picture["url"]);
              }

              // SQL Query > Select Data
              var query = client.query("SELECT b.id, b.owner_fk, b.location, b.available, b.code, r.rating, u.name, u.photourl " +
                  "FROM public.bike b, public.user u, (SELECT  user_fk, AVG(rating) AS rating FROM public.rating GROUP BY user_fk) r " +
                  "WHERE b.owner_fk = u.id AND u.id = r.user_fk;");

              // Stream results back one row at a time
              query.on('row', function(row) {
                  row["pictures"] = pictures[row["id"]];
                  results.push(row);
              });

              // After all data is returned, close connection and return results
              query.on('end', function() {
                  client.end();
                  return res.json(results);
              });
          }
      });

    // Handle Errors
    if(err) {
      console.log(err);
    }
  });
});

router.post('/return_bike', function(req, res) {

  var results = [];

  // Grab data from http request
  var data = {id: req.body.id, latitude: req.body.latitude, longitude: req.body.longitude};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    var query = client.query("UPDATE public.bike SET \"location\"=POINT($2, $3), available=true WHERE id=$1 RETURNING *;",
        [data.id, data.latitude, data.longitude]);

    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    var config_opts = {
      'host': 'api.sandbox.paypal.com',
      'port': '',
      'client_id': 'Afp2yAdLXxHG6EYv1TDHaH9jsA7X-L2y3k5tblbXFvFM0evlPcxssqpVj8XJUaCJxbQDjcN7MG_J4wT-',
      'client_secret': 'EAZr787qN6AX0GfqR8lpkFh7-YwTR4c37q_-nLeQ0il9rjdMN4uw1mZtdtiZ25oQ3izvhLep42jObd33'
    };


    var create_payment_json = {
      "intent": "sale",
      "payer": {
        "payment_method": "paypal"
      },
      "redirect_urls": {
        "return_url": "http:\/\/localhost\/test\/rest\/rest-api-sdk-php\/sample\/payments\/ExecutePayment.php?success=true",
        "cancel_url": "http:\/\/localhost\/test\/rest\/rest-api-sdk-php\/sample\/payments\/ExecutePayment.php?success=false"
      },
      "transactions": [{
        "amount": {
          "currency": "USD",
          "total": "1.00"
        },
        "description": "This is the payment descriptionx."
      }]
    };


    paypal_api.payment.create(create_payment_json, config_opts, function (err, res) {
      if (err) {
        throw err;
      }

      if (res) {
        console.log("Create Payment Response");
        console.log(res);
      }

//      paypal_api.payment.
    });


    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });
});

router.post('/book_bike', function(req, res) {

  var results = [];

  // Grab data from http request
  var data = {id: req.body.id};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    var query = client.query("UPDATE public.bike SET available=false WHERE id=$1 RETURNING *;",
        [data.id]);


    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });
});

router.post('/update_bike_position', function(req, res) {

  var results = [];

  // Grab data from http request
  var data = {id: req.body.id, latitude: req.body.latitude, longitude: req.body.longitude};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    var query = client.query("UPDATE public.bike SET \"location\"=POINT($2, $3) WHERE id=$1 RETURNING *;",
        [data.id, data.latitude, data.longitude]);


    // Stream results back one row at a time
    query.on('row', function(row) {
      results.push(row);
    });

    // After all data is returned, close connection and return results
    query.on('end', function() {
      client.end();
      return res.json(results);
    });

    // Handle Errors
    if(err) {
      console.log(err);
    }

  });
});

router.post('/update_push_token', function(req, res) {

    var results = [];

    // Grab data from http request
    var data = {id: req.body.id, token: req.body.token};

    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {

        var query = client.query("INSERT INTO token(user_fk, token) VALUES($1, $2);",
            [data.id, data.token]);

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            return res.json(results);
        });

        // Handle Errors
        if(err) {
            console.log(err);
        }

    });
});

module.exports = router;
