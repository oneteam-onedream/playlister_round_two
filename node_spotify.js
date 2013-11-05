var Spotify = require('spotify-web');
var lame = require('lame');
var Speaker = require('speaker');

var xml2js = require('xml2js');
var async = require('async');

var fs = require('fs');

var request = require('request');

config = fs.readFileSync('./.spotify_credentials');
creds = config.toString().split('\n');

var username = creds[0];
var password = creds[1];

var spotify = Spotify.login(username, password, function (err, spotify) {
  if (err) throw err;
});

exports.album = function (req, res) {
 var uri = req.params.uri;

  spotify.get(uri, function (err, album) {
    if (err) throw err;
    console.log('Album Art URIs for "%s - %s"', album.artist[0].name, album.name);

    // print out the HTTP uris for each image size of the album covers
    album.cover.forEach(function (image) {
      console.log('%s: %s', image.size, image.uri);
    });

    spotify.disconnect();
  });
};

exports.search = function (req, res) {
  // Properly structured querystring can be used directly in the Spotify search function
  // req.query == { type: 'tracks', query: 'song or artist or whatever' }
  spotify.search(req.query, function (err, xml) {
    var parser = xml2js.Parser();
    var songList = [];
    parser.on('end', function (data) {
      // The response has an array of 'tracks' even though it seems there is only one, preferable to for each it anyway
      if (data.result.tracks[0] === '') {
        res.send("");
      }
      else {
        async.each(data.result.tracks, function (tracks, callback) {
          // Scary, nested async.each loops - this hits every individual track within the tracks array (of one tracks item)
          async.each(tracks.track, function (track, callback) {
            // Again, the response from Spotify has arrays where I typically would only expect one item?
            // Would a track really have multiple URIs and titles? I really don't think so, and haven't seen it, so I grab index 0
            album_uri = Spotify.id2uri('album', track['album-id'][0]);
            album_art = "";

            spotify.get(album_uri, function (err, album) {
              if (err) throw err;

              songList.push({
                artist: track.artist[0],
                title: track.title[0],
                album: track.album[0],
                album_art: album.cover[2].uri,
                uri: Spotify.id2uri('track', track.id[0])
              });
              // Callback to the nested async.each loop - done after each track is processed
              callback();
            });
          },
          function (err) {
            if (err) throw err;

            // Callback to the tracks async.each loop - called when the nested loop of every track inside 'tracks' is finished
            callback();
          });
        },
        function (err) {
          if (err) throw err;

          // When we have read all the tracks (and subsequently each 'track' under tracks) return the list of them we built out to the browser
          res.end(JSON.stringify(songList, null, 2));
        });
      }
    });
    parser.parseString(xml);
  });
};

exports.play = function (req, res) {
  var uri = req.params.uri;

  spotify.get(uri, function (err, track) {
    if (err) throw err;
    console.log('Playing: %s - %s', track.artist[0].name, track.name);

    track.play()
    .pipe(new lame.Decoder())
    .pipe(new Speaker())
    .on('finish', function () {
      // send route back to sinatra letting it know this track is done playing
      request('http://localhost:9292/playlist/played/' + uri, function(err, res, body) {
        console.log(body);
      });
    });
  });

  res.send('Playing your song');
};