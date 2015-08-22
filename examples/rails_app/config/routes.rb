Rails.application.routes.draw do
  mount Pieces::Rails.mount, at: '/styleguide'
end
