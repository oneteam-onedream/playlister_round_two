require "bundler/setup"

Bundler.require

DB = Sequel.connect("sqlite://#{Dir.pwd}/db/playlister.db")

require_relative '../app/models/song'
require_relative '../app/models/playlist'
require_relative '../app/models/voter'
require_relative '../spotify_moc'
require_relative '../app/controllers/application_controller'
require_relative '../app/controllers/playlist_controller'
require_relative '../app/controllers/node_controller'