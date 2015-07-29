# Pieces

This gem will take your HTML and CSS components and compile them into a static
site. Very very alpha.

## Create new static site

To create a new static site with pieces:

```
gem install pieces
pieces init
```

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

1. Fork it ( https://github.com/[my-github-username]/pieces/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Luke Morton (again)
