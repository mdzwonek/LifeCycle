var express = require('express');
var router = express.Router();

var path = require('path');
var pg = require('pg');
var connectionString = require(path.join(__dirname, '../', 'config'));

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

    // SQL Query > Select Data
    var query = client.query("SELECT b.id, b.owner_fk, b.location, u.name, u.photourl FROM public.bike b, public.user u WHERE b.owner_fk = u.id AND b.available = true;");

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

module.exports = router;
