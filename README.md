# Pieces

[![Gem Version](https://badge.fury.io/rb/pieces.svg)](http://badge.fury.io/rb/pieces)
[![Build Status](https://travis-ci.org/drpheltright/pieces.svg)](https://travis-ci.org/drpheltright/pieces)
[![Code Climate](https://codeclimate.com/github/drpheltright/pieces/badges/gpa.svg)](https://codeclimate.com/github/drpheltright/pieces)
[![Test Coverage](https://codeclimate.com/github/drpheltright/pieces/badges/coverage.svg)](https://codeclimate.com/github/drpheltright/pieces/coverage)

Pieces is a gem that will take your HTML and CSS components and compile them
into a static site or styleguide.

 - <h5>Build static sites and blogs</h5>
 - <h5>Produce styleguides for your rails applications</h5>
 - <h5>Mock up designs</h5>

With Pieces, you define the view of your application with components. Even
your layout is just another component.

## Welcome early adopters

I'd really appreciate feedback so please do try Pieces out for your current
or next project. Obviously it's new and changing but I adhere very closely
to semantic versioning and your styleguide should be a safe place to try
new things. Thanks in advance, Luke.

## Installation

If installing Pieces into a rails app, add it to your Gemfile:

``` ruby
gem 'pieces'
```

If building a standalone site, install globally:

```
gem install pieces
```

## Quick example

Let's start by defining some "pieces", or components, or views as they are
better known in the rails world. You'll notice Pieces looks for files in the
same places rails does.

**`app/views/article/article.html.erb`:**

``` erb
<article class="article">
  <h1 class="article__title"><%= title %></h1>
  <div class="article__content"><%= content %></div>
</article>
```

You should have a one to one relationship between components, and stylesheets.
For example, `.article` should be defined like so.

**`app/assets/stylesheets/components/article.css`:**

```css
.article {
  padding: 1em;
}

.article__content {
  padding-top: 1em;
}
```

You can use `.css`, `.scss`, `.sass` and `.less` with Pieces.

**`app/views/layouts/pieces.html.erb`:**

``` erb
<html>
  <head>
    <title>{{title}}</title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

We pull the pieces together with a configuration file. Here you can define
nested components and data to be used to generate a static site.

**`config/pieces.yml`:**

``` yml
index:
  _pieces:
    - layouts/pieces:
        title: 'My Articles'
        _pieces:
          - article: { title: 'A title', content: '<p>Content.</p>' }
          - article: { title: 'Another title', content: '<p>More content.</p>' }
```

With these three files in place and having installed pieces on your system
(`gem install pieces`) you can run:

```
pieces server
```

Now visit [http://localhost:8080](http://localhost:8080) to see your site! If
you change your `config/pieces.yml` or views they will be reflected on the site.

## Use as styleguide for rails

Firstly, ensure you have added Pieces to your `Gemfile`:

``` ruby
gem 'pieces'
```

Next you need to initialize your application to use Pieces:

```
bundle
bundle exec rails g pieces:rails:install
```

Edit your `config/pieces.yml` to demo some of your components.

Now boot up rails:

```
bundle exec rails s
```

And then visit [http://localhost:3000/styleguide](http://localhost:3000/styleguide)

### Do you use vagrant?

If you do you should update Pieces::Rails in your `config/routes.rb` as follows:

``` ruby
mount Pieces::Rails.new(force_polling: true).mount, at: '/styleguide' unless Rails.env.production?
```

This will tell `listen`, the gem that watches for changes, to poll your app
for changes. This is required for vagrant!

## Create new static site

To create a new static site with Pieces:

```
gem install pieces
pieces init hello_world
```

This will install `config/pieces.yml`, a layout and example header and footer
into `hello_world/` for you.

Once you've built the components and routes for your site all you have to do is
run:

```
pieces build
```

Your site will be built into `build/` directory. You can then use these HTML
files for your site.

Whilst developing you won't want to keep running `pieces build`. Pieces comes
with a server inbuilt that reloads everytime you make a change.

To run it:

```
pieces server
```

Now visit [http://localhost:8080](http://localhost:8080) in your browser.

## Configuration

Using configuration found in `config/pieces.yml` Pieces' will compile your
modular components ala BEM (or whatever you prefer) into a static HTML site.

At the top level of your `pieces.yml` you define your output files, or "routes".
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
piece will be found in either `app/views/intro.html.*`,
`app/views/intro/intro.html.*` or `app/views/application/intro.html.*`. The `*`
can be any format supported by [tilt](https://github.com/rtomayko/tilt).

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

Likewise you can structure your components in directories:

``` yml
about:
  _pieces:
    - header: {}
    - copy/intro: {}
    - galleries/photo: {}
    - footer: {}
```

"copy/intro" and "galleries/photo" will be found in
`app/views/copy/intro.html.*` and `app/views/galleries/photo.html.*`
respectively.

You can place your content in a layout quite easily with nested pieces.

``` yml
about:
  _pieces:
    - layouts/pieces:
        _pieces:
          - header: {}
          - copy/intro: {}
          - galleries/photo: {}
          - footer: {}
```

The child pieces will be rendered in order and passed into the parent
"layouts/application" piece as `yield`. If you had
`app/views/layouts/pieces.html.erb` then you can call yield like so:

``` erb
<html>
  <body>
    <%= yield %>
  </body>
</html>
```

## More Examples

 - [Original example][original] using .erb and .mustache (liek wtf!)
 - [Boilerplate example][boilerplate] used by `pieces init`
 - [Rails example][rails] using Pieces as a styleguide

[original]: https://github.com/drpheltright/pieces/tree/master/examples/original
[boilerplate]: https://github.com/drpheltright/pieces/tree/master/examples/boilerplate
[rails]: https://github.com/drpheltright/pieces/tree/master/examples/rails

## Contributing

1. Fork it ( https://github.com/drpheltright/pieces/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Luke Morton (again)
