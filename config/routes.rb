Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  concern :voteable do
    member do
      post :yea
      post :nay
      delete :nullify_vote
    end
  end

      # member do
    #   post :subscribe
    #   delete :unsubscribe
    # end

  resources :questions, concerns: [:voteable] do
    resources :comments, shallow: true,  defaults: { commentable: "question" }
    resources :answers, concerns: [:voteable], shallow: true do
      post :best, on: :member
      resources :comments, shallow: true, defaults: { commentable: "answer" }
    end
    resource :subscription, only: [:create, :destroy]
  end

  get "users/add_email_form", to: "users#add_email_form", as: :add_email_form
  post "users/add_email", to: "users#add_email", as: :add_user_email


  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  root to: 'questions#index'

end
