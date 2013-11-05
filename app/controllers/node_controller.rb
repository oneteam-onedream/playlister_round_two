class NodeController < ApplicationController
  get '/spotify' do
    open("http://localhost:5002/spotify?query=#{params[:q]}")
  end

  get '/spotify/:uri' do
    open("http://localhost:5002/spotify/#{params[:uri]}")
  end
end