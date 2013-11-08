flatiron-playlister
===================

to use this program at the moment, you'll need a spotify account and node ([link here](nodejs.org/download/))
- in the root directory, make a file called .spotify_credentials
- in .spotify_credentials, put your username in quotes on line 1 + your password in quotes on line 2
- in your terminal from root, run `node node_server.js`
- in a seperate terminal, run `rackup`
- go to localhost:9292, add a song, and go to localhost:9292/playlist/start to fire it up, be sure to only run the start route once though! otherwise node and its async doings will play many songs simultaneously if you ask it too.


to work on the program
-----
-  fork this repositry
-  clone it locally
-  add this repo as the local upsteam like so:  
```git add remote upstream git@github.com:oneteam-onedream/flatiron-playlister.git```
-  checkout a branch for your work:  
```checkout -b <your_feature_name>``` 
  -  try to use descriptive name for branch eg. 'spotify-web', 'upvote-bugfix', etc
-  when feature is complete, push your feature branch up to your github account(origin)
    ```git push origin <your_feature_name>```
-  make a pull request to merge your feature branch to the oneteam-onedream master branch
    -  do not merge your pull requests, we should all be on the same page about the content being merged
    -  when you work, be sure to be up to date with the upstream/master branch. It's good habit to pull often

TODO
====
- a proper server?
- testing!
- jquery!
- etc!

down the line 
------
- rails and activerecord
- incorporate itunes, soundcloud, bandcamp, etc
