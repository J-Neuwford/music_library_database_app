# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  # albums.all
  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all.sort_by {|album| album.id }

    return erb(:get_albums)
  end 

  

  # albums.create
  post '/albums' do
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ''
  end

  #artists.all
  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    return erb(:get_artists)
  end

  #artists.create
  post '/artists' do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
    return ''
  end

  get '/hello' do
    @name = params[:name]

    return erb(:index)
  end

  #albums.find
  get '/albums/:id' do
    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    id = params[:id]
    @album = album_repo.find(id)
    @artist = artist_repo.find(@album.artist_id)

    return erb(:find_album)
  end

  # artists.find
  get '/artists/:id' do
    artist_repo = ArtistRepository.new
    id = params[:id]
    @artist = artist_repo.find(id)

    return erb(:find_artist)
  end
end