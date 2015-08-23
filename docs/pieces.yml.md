# `pieces.yml`

In order to pull together your reusable UI components into web pages we use
`config/pieces.yml`. This file defines the pages of your site, what components
that page is made up of, the data passed into your components,
along with meta data such as where to publish your site or styleguide.

## Table of Contents

 - [Defining pages](#defining-pages)
 - [Components](#components)
 - [Data](#data)
 - [Global data](#global-data)
 - [Publishing to GitHub pages](#publishing-to-github-pages)

## Defining pages

At the top level of your `pieces.yml` you define your pages. The following
example will build `index.html` and `about.html`.

``` yml
index: # <-- index.html page
  _pieces:
    - intro: {}

about: # <-- about.html page
  _pieces:
    - intro: {}
```

Both `index.html` and `about.html` make use of a component called "intro". We'll
get onto components in a minute.

### Structuring pages in directories

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

## Components

All your reusable components can be assembled and nested within one another.
Under your page, you define which components or "pieces" under the `_pieces`
key.

``` yml
index:
  _pieces:
    - intro: {} # <-- intro component
```

The example above references an "intro" component. This piece will be found in
one of the following locations:

 - `app/views/intro.html.*`
 - `app/views/intro/intro.html.*`
 - `app/views/application/intro.html.*`

The `*` can be any format supported by [tilt](https://github.com/rtomayko/tilt).

### Structuring components in directories

You can specify a full path to your component which will often be the case. This
allows you to categories your components.

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

### Nesting components

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

## Data

To make components reusable you will inject data into them via `pieces.yml`.

``` yml
index:
  _pieces:
    - layouts/blog:
        title: 'Blog posts' # <-- data
        _pieces:
          - blog/post_summary:
              title: 'A great post' # <-- data
              excerpt: 'In where you will learn great things.' # <-- data
```

Here you can see "title" is injected into "layouts/blog". This data variable
will only be accessible to the layout file and not any nested pieces.
In the example you can also see another variable called "title" nested under
"blog/post_summary" along side "excerpt".

## Global data

If you have data that needs to be used in more than one page you can use
globals. These globals are available in every file and component but will be
overridden if the page or pieces use the same key.

``` yml
_global:
  site_name: 'My Blog' # <-- global

index:
  _pieces:
    - layouts/blog:
        title: 'Blog posts'
        _pieces:
          - blog/post_summary:
              title: 'A great post'
              excerpt: 'In where you will learn great things.'
```

The variable "site_name" will be available in all components.

### Per page globals

You can also specify globals per page. These will be available for all
components in the page.

``` yml
_global:
  site_name: 'My Blog'

index:
  _global:
    title: 'Blog posts' # <-- per page global

  _pieces:
    - layouts/blog:
        _pieces:
          - blog/post_summary:
              title: 'A great post'
              excerpt: 'In where you will learn great things.'
```

## Publishing to GitHub pages

You can specify your GitHub repo in order to publish to the gh-pages branch:

```
_publish:
  - type: github
    remote: https://github.com/username/repo
```
