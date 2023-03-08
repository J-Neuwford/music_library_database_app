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
      
      expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to be 200
      expect(response.body).to eq expected_response
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

      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'

      expect(response.status).to be 200
      expect(response.body).to eq expected_response
    end
  end

  context "POST/artists" do
    it 'returns 200 OK' do
      response = post('/artists', 
                  name: 'Wild Nothing', 
                  genre: 'Indie')

      get_response = get('/artists')
      expected_get_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Wild Nothing'

      expect(response.status).to eq(200)
      expect(response.body).to eq ''
      expect(get_response.body).to eq expected_get_response
    end 
  end
end
