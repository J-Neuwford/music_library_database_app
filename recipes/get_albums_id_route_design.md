# {{ METHOD }} {{ PATH}} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

  Method: GET
  Path: /albums
  Query: id

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```
response 200 OK
```

## 3. Write Examples

_Replace these with your own design._

```html
<!-- Example for GET /albums/1 -->

<html>
  <head></head>
  <body>
    <h1>Doolittle</h1>
    <p>
      Release year: 1989
      Artist: Pixies
    </p>
  </body>
</html>

<!-- Example for GET /albums/2 -->

<html>
  <head></head>
  <body>
    <h1>Surfer Rosa</h1>
    <p>
      Release year: 1988
      Artist: Pixies
    </p>
  </body>
</html>
```


## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context 'GET /albums/:id' do
    it 'Get /albums/1' do
      response = get('/albums/1')
      
      expected_response = '<h1>Doolittle</h1>'

      expect(response.status).to be 200
      expect(response.body).to include expected_response
    end

    it 'Get /albums/2' do
      response = get('/albums/2')
      
      expected_response = '<h1>Surfer Rosa</h1>'

      expect(response.status).to be 200
      expect(response.body).to include expected_response
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.

