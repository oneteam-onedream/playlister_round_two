class Playlist < Sequel::Model
  one_to_many :songs
  attr_accessor :current_song

  def added_by_user(user_ip)
    self.songs.collect do |song|
      users_songs ||= []
      users_songs << song if song.creator_ip == user_ip
    end
  end

  def add_song(spotify_hash, user_ip)
    Song.create do |s| 
      s.spotify_id  =  spotify_hash[:spotify_id]
       s.song_name  =  spotify_hash[:song_name]
     s.artist_name  =  spotify_hash[:artist_name]
      s.album_name  =  spotify_hash[:album_name]
     s.album_cover  =  spotify_hash[:album_cover]
      s.created_at  =  Time.now
     s.playlist_id  =  self.id
      s.creator_ip  =  user_ip
    end
  end

  def song_sort
    self.songs.sort_by { |song| song.upvotes }.reverse
  end

  def songs_in_queue
    self.song_sort
  end

  def after_play(uri)
    Song.find(:spotify_id => uri).voters.each do |voter|
      voter.destroy
    end
    Song.find(:spotify_id => uri).destroy
  end
end