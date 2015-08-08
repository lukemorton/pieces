Rails.application.routes.draw do
  mount Pieces::Rails.new.mount, at: '/styleguide'
end
