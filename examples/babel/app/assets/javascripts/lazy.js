//= require ./vendor/load_css
//= require ./vendor/webfontloader
//= require_self

loadCSS('/assets/lazy.css')

WebFont.load({
  google: {
    families: ['Droid Sans', 'Droid Serif']
  }
})
