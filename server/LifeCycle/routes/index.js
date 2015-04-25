var express = require('express');
var router = express.Router();

var path = require('path');
var pg = require('pg');
var connectionString = require(path.join(__dirname, '../', 'config'));

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});


router.post('/users', function(req, res) {

  var results = [];

  // Grab data from http request
  var data = {name: req.body.name, surname: req.body.surname, login: req.body.login, photourl: req.body.photourl};

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Insert Data
    client.query("INSERT INTO \"user\"(id, \"name\", \"surname\", \"login\", \"photourl\")VALUES (DEFAULT, $1, $2, $3, $4)",
        [data.name, data.surname, data.login, data.photourl]);

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM user");

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

router.get('/users', function(req, res) {

  var results = [];

  // Get a Postgres client from the connection pool
  pg.connect(connectionString, function(err, client, done) {

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM user;");

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
    client.query("UPDATE user SET text=($1), complete=($2) WHERE id=($3)", [data.text, data.complete, id]);

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM user ORDER BY id ASC");

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
    client.query("DELETE FROM user WHERE id=($1)", [id]);

    // SQL Query > Select Data
    var query = client.query("SELECT * FROM user ORDER BY id ASC");

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
