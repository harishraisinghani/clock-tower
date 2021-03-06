Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root to: "home#show"

  resource :session, only: [:new, :create, :destroy]
  resource :password, only: [:edit, :update]
  resource :profile, only: [:edit, :update]

  resources :password_resets, only: [:new, :create, :show]

  resources :time_entries, only: [:index, :new]
  resources :statements, only: [:index, :show]
  resources :api_keys, only: [:index, :create, :destroy]

  # For time entries
  namespace :api do
    resources :tasks, only: [:index]
    resources :projects, only: [:index]
    resources :time_entries, only: [:create, :update, :destroy, :index]
  end

  namespace :reports do
    get 'entries' => 'entries#show'
  end

  namespace :admin do
    namespace :api do
      resources :statements, only: [:index, :update]
      resources :time_entries, only: [:destroy, :update]
    end
    get 'statements/pay' => 'statements#pay', as: :pay_statements
    resources :statements
    resources :time_entries, only: [:index]
    resources :statement_periods
    post 'statement_periods/:id' => 'statement_periods#generate', as: :generate_statement_period
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :locations, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :rates, only: [:index, :new, :create, :edit, :update, :destroy]
    namespace :reports do
      get 'payroll' => 'payroll#show'
      get 'summary' => 'summary#show'
    end
    get 'sessions/impersonate/:id' => 'sessions#impersonate'
  end

end
