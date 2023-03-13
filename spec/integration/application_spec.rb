require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
# /Users/joshneuwford/Projects/music_library_database_app/spec/seeds/albums_seeds.sql
# /Users/joshneuwford/Projects/music_library_database_app/spec/integration/application_spec.rb
  def reset_albums_table
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  def reset_artists_table
    seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_albums_table
    reset_artists_table
  end

  after(:all) do 
    reset_albums_table
    reset_artists_table
  end

  context 'GET /albums' do
    
    it 'returns the list of albums' do
      response = get('/albums')

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Albums</h1>'
      expect(response.body).to include '<a href="/albums/1">Doolittle</a>'
      expect(response.body).to include '<a href="/albums/2">Surfer Rosa</a>'
      expect(response.body).to include '<a href="/albums/3">Waterloo</a>'
    end

  end

  context 'GET /albums/new' do
    it 'returns the html form to create a new album' do
      response = get('/albums/new')

      expect(response.status).to eq 200
      expect(response.body).to include '<form method="POST" action="/albums">'
      expect(response.body).to include '<input type="text" name="title"/>'
      expect(response.body).to include '<input type="text" name="release_year"/>'
      expect(response.body).to include '<input type="text" name="artist_id"/>'
    end
  end

  context 'GET /artists/new' do
    it 'returns the html form to create a new artist' do
      response = get('/artists/new')

      expect(response.status).to eq 200
      expect(response.body).to include '<form method="POST" action="/artists">'
      expect(response.body).to include '<input type="text" name="name"/>'
      expect(response.body).to include '<input type="text" name="genre"/>'
    end
  end

  context "POST/albums" do
    it 'returns 200 OK' do
      response = post('/albums', 
      title: 'Voyage', 
      release_year: '2022', 
      artist_id: '2')

      expect(response.status).to eq(200)
      expect(response.body).to eq ''
    end
  end

  context 'GET /artists' do
    it 'returns the list of artists' do
      response = get('/artists')

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Artists</h1>'
      expect(response.body).to include '<a href="artists/1">Pixies</a>'
      expect(response.body).to include '<a href="artists/2">ABBA</a>'
    end
  end

  context "POST/artists" do
    it 'returns 200 OK' do
      response = post('/artists', 
                  name: 'Wild Nothing', 
                  genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq ''
    end 
  end

  context 'GET /albums/:id' do
    it 'Get /albums/1' do
      response = get('/albums/1')
      expected_response = '<h1>Doolittle</h1>'
      expected_response_2 = 'Artist: Pixies'

      expect(response.status).to be 200
      expect(response.body).to include expected_response
      expect(response.body).to include expected_response_2
    end

    it 'Get /albums/2' do
      response = get('/albums/2')
      expected_response_1 = '<h1>Surfer Rosa</h1>'
      expected_response_2 = 'Artist: Pixies'

      expect(response.status).to be 200
      expect(response.body).to include expected_response_1
      expect(response.body).to include expected_response_2
    end
  end

  context 'GET /artists/:id' do
    it 'Gets /artists/1' do
      response = get('/artists/1')
      expected_response_1 = '<h1>Pixies</h1>'
      expected_response_2 = 'Genre: Rock'

      expect(response.status).to eq 200
      expect(response.body).to include expected_response_1
      expect(response.body).to include expected_response_2
    end
  end

  context 'GET /artists/:id' do
    it 'Gets /artists/2' do
      response = get('/artists/2')
      expected_response_1 = '<h1>ABBA</h1>'
      expected_response_2 = 'Genre: Pop'

      expect(response.status).to eq 200
      expect(response.body).to include expected_response_1
      expect(response.body).to include expected_response_2
    end
  end

  
end
