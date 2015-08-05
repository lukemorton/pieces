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

## How it works

Using configuration found in `config/routes.yml` pieces will compile your
modular components ala BEM (or whatever you prefer) into a static HTML site.

At the top level of your `routes.yml` you define your output files, or "routes".
The following example will build both `index.html` and `about.html`.

``` yml
index:
  _pieces:
    - intro: { title: 'Welcome to my site' }

about:
  _pieces:
    - intro: { title: 'About me' }
```

Both `index.html` and `about.html` make use of a piece called "intro". This
piece will be found in either `pieces/intro.html.*`, `pieces/intro/intro.html.*`
or `pieces/application/intro.html.*`. The `*` can be any format supported by
[tilt](https://github.com/rtomayko/tilt).

You can generate your HTML into directories quite easily:

``` yml
portfolio/a-client:
  _pieces:
    - carousel: {}
    - case_study: {}
portfolio/another-client:
  _pieces:
    - carousel: {}
    - case_study: {}
```

Likewise you can structure your pieces in directories:

``` yml
about:
  _pieces:
    - header: {}
    - copy/intro: {}
    - galleries/photo: {}
    - footer: {}
```

"copy/intro" and "galleries/photo" will be found in `pieces/copy/intro.html.*`
and `pieces/galleries/photo.html.*` respectively.

You can place your content in a layout quite easily with nested pieces.

``` yml
about:
  _pieces:
    - layouts/application:
        _pieces:
          - header: {}
          - copy/intro: {}
          - galleries/photo: {}
          - footer: {}
```

The child pieces will be rendered in order and passed into the parent
"layouts/application" piece as `yield`. If you had
`pieces/layouts/application.html.erb` then you can call yield like so:

``` erb
<html>
  <body>
    <%= yield %>
  </body>
</html>
```

## More Examples

For more examples please see: https://github.com/drpheltright/pieces/tree/master/example

## Contributing

1. Fork it ( https://github.com/drpheltright/pieces/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Luke Morton (again)
