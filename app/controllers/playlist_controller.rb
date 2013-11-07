class PlaylistController < ApplicationController
  enable :sessions

  @@current = nil

  get '/' do
    Playlist.create
    redirect '/playlist'
  end

  get '/search' do
    q = params[:q].gsub(' ', '%20')
    q = q.gsub('-','')
    @queries = JSON.parse(open(URI.escape("http://localhost:9292/spotify?q=#{q}")).read)
    session[:queries] = @queries[0..7]

    redirect '/playlist'
  end

  get '/playlist/start' do
    @@current = Playlist[1].songs_in_queue.first
    open("http://localhost:9292/spotify/#{@@current.spotify_id}")
    redirect '/playlist'
  end

  post '/playlist/add' do
    @song = Playlist[1].add_song(params[:song], request.ip)
    if @song == :user_limit_met
      redirect '/playlist/user_limit'
    elsif @song == :playlist_full
      redirect '/playlist/full'
    end
    # session[:queries] = nil
    redirect '/playlist'
  end

  get '/playlist/user_limit' do
    erb :'playlist/user_limit'
  end

  get '/playlist/full' do
    erb :'playlist/playlist_full'
  end

  get '/playlist' do 
  # binding.pry 
    @ip = request.ip
    @queries = session[:queries]
    @playlist = Playlist[1]
    if @@current
      @current_song = @@current
      @songs = @playlist.song_sort.reject{ |song| song if song == @current_song }
    else
      @songs = @playlist.song_sort
    end
    erb :'playlist/playlist'
  end

  get '/songs/:id/upvote' do
    @song = Playlist[1].songs.detect {|song| song.id == params[:id].to_i}
    @song.vote(request.ip)
    redirect '/playlist'
  end

  get '/playlist/played/:uri' do
    Playlist[1].after_play(params[:uri])
    @@current = Playlist[1].songs_in_queue.first
    open("http://localhost:9292/spotify/#{@@current.spotify_id}")
  end
end