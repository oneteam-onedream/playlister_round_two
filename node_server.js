var express = require('express'),
    spotify = require('./node_spotify');

var path = require('path');

var app = express();

app.configure(function () {
  app.use(express.bodyParser());
});

app.get('/spotify', spotify.search);
app.get('/spotify/:uri', spotify.play);
app.get('/spotify/album/:uri', spotify.album);

app.listen(5002);