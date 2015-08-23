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

## Table of Contents

 - [Installation](#installation)
 - [How pieces works](#quick-example)
 - [Create styleguide for rails](#styleguide-for-rails)
 - [Create static site](#create-static-site)
 - [Learn about pieces.yml configuration](https://github.com/drpheltright/pieces/blob/master/docs/configuration.md)
 - [More examples](#more-examples)
 - [Code of Conduct](https://github.com/drpheltright/pieces/blob/master/CODE_OF_CONDUCT.md)
 - [Contributing](#contributing)
 - [License](https://github.com/drpheltright/pieces/blob/master/LICENSE.md)

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

Ideally you should have a one to one relationship between components, and
stylesheets. For example, `.article` should be defined like so.

**`app/assets/stylesheets/components/article.css`:**

```css
.article {
  padding: 1em;
}

.article__content {
  padding-top: 1em;
}
```

You can use `.css`, `.scss`, `.sass` and `.less` with Pieces. In fact anything
supports by [Sprockets](https://github.com/rails/sprockets) since that is what
we use under the hood.

We also need to pull this stylesheet into your styleguide. By default pieces
will look for `pieces.css`.

**`app/assets/stylesheets/pieces.css`:**

```css
/*= require_tree ./components */
```

And we need a layout to pull the components together.

**`app/views/layouts/pieces.html.erb`:**

``` erb
<html>
  <head>
    <title>{{title}}</title>
    <link rel="stylesheet" src="/assets/pieces.css" />
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

## Styleguide for rails

Firstly, ensure you have added Pieces to your `Gemfile`:

``` ruby
gem 'pieces'
```

Next you need to initialize your application to use Pieces:

```
bundle
bundle exec rails g pieces:rails:install
```

Edit your `config/pieces.yml` to demo some of your components. Please see the
examples in this README as to how it should look. Detailed documentation coming
soon. Thanks for your patience!

Now boot up rails:

```
bundle exec rails s
```

And then visit [http://localhost:3000/styleguide](http://localhost:3000/styleguide)

To build a static version of your site:

```
bundle exec pieces build
```

This will build your styleguide into `build/`.

You can also run pieces server rather than rails for faster development:

```
bundle exec pieces s
```

And then visit [http://localhost:8080](http://localhost:8080)

### Do you use vagrant?

If you do you should update Pieces::Rails in your `config/routes.rb` as follows:

``` ruby
mount Pieces::Rails.mount(force_polling: true), at: '/styleguide' unless Rails.env.production?
```

This will tell `listen`, the gem that watches for changes, to poll your app
for changes. This is required for vagrant!

## Create static site

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

## More Examples

 - [Original example][original-example] using .erb and .mustache (liek wtf!)
 - [Boilerplate example][boilerplate-example] used by `pieces init`
 - [Rails example][rails-example] using Pieces as a styleguide
 - [Babel.js][babel-example] using Pieces as a styleguide

[original-example]: https://github.com/drpheltright/pieces/tree/master/examples/original
[boilerplate-example]: https://github.com/drpheltright/pieces/tree/master/examples/boilerplate
[rails-example]: https://github.com/drpheltright/pieces/tree/master/examples/rails
[babel-example]: https://github.com/drpheltright/pieces/tree/master/examples/babel

## Contributing

1. Fork it ( https://github.com/drpheltright/pieces/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
