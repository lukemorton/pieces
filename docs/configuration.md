# Configuration

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
