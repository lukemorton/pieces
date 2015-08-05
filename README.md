# Pieces

[![Build Status](https://travis-ci.org/drpheltright/pieces.svg)](https://travis-ci.org/drpheltright/pieces)
[![Code Climate](https://codeclimate.com/github/drpheltright/pieces/badges/gpa.svg)](https://codeclimate.com/github/drpheltright/pieces)
[![Test Coverage](https://codeclimate.com/github/drpheltright/pieces/badges/coverage.svg)](https://codeclimate.com/github/drpheltright/pieces/coverage)

This gem will take your HTML and CSS components and compile them into a static
site. Very very alpha.

## Create new static site

To create a new static site with pieces:

```
gem install pieces
pieces init hello_world
```

This will install some boiler plate in `hello_world/`.

## Create styleguide within existing application

Add pieces to your Gemfile:

```ruby
gem 'pieces'
```

Then run

```
bundle
pieces init styleguide
```

This will install pieces inside a subfolder called `styleguide/`.

## Building your site

Please follow examples for a howto right now. Once you've built the pieces
and routes for your site all you have to do is run:

```
pieces build
```

Make sure you run this from your pieces directory!

## Contributing

1. Fork it ( https://github.com/drpheltright/pieces/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Luke Morton (again)
