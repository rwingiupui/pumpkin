Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount BrowseEverything::Engine => '/browse'

  mount Blacklight::Engine => '/'
  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new
  resource :catalog, only: [:index], controller: 'catalog' do
    concerns :searchable
  end
  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  # May need to set this in production for search highlighting to work.
  # Rails.application.routes.default_url_options[:host]= 'example.iu.edu'
  devise_for(:users,
             controllers: { sessions: 'users/sessions',
                            omniauth_callbacks: "users/omniauth_callbacks" },
             skip: %i[passwords registration])
  devise_scope :user do
    get('global_sign_out',
        to: 'users/sessions#global_logout',
        as: :destroy_global_session)
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    get('users/auth/cas',
        to: 'users/omniauth_authorize#passthru',
        defaults: { provider: :cas },
        as: "new_user_session")
  end
  mount Hydra::RoleManagement::Engine => '/'

  resources :welcome, only: 'index'
  root to: 'welcome#index'
  # Add URL options
  default_url_options Rails.application.config.action_mailer.default_url_options

  # Collections have to go before CC routes, to add index_manifest.
  resources :collections, only: [] do
    member do
      get :manifest, defaults: { format: :json }
    end
  end
  mount CurationConcerns::Engine, at: '/'
  curation_concerns_collections
  curation_concerns_basic_routes
  curation_concerns_embargo_management

  get("/iiif/collections",
      defaults: { format: :json },
      controller: :collections,
      action: :index_manifest)

  namespace :curation_concerns, path: :concern do
    resources :parent, only: [] do
      %i[multi_volume_works scanned_resources].each do |type|
        resources type, only: [] do
          member do
            get :file_manager
            get :structure
          end
        end
      end
    end
    resources :multi_volume_works, only: [] do
      member do
        get :manifest, defaults: { format: :json }
        get "/highlight/:search_term", action: :show
        post :flag
        post :browse_everything_files
        patch :alphabetize_members
        get :structure
        post :structure, action: :save_structure
      end
    end
    resources :scanned_resources, only: [] do
      member do
        get "/pdf/:pdf_quality", action: :pdf, as: :pdf
        get "/highlight/:search_term", action: :show
        patch :alphabetize_members
        get :structure
        post :structure, action: :save_structure
        get :manifest, defaults: { format: :json }
        post :browse_everything_files
        post :flag
      end
    end
    resources :file_sets, only: [] do
      member do
        post :derivatives
      end
    end
  end

  namespace :curation_concerns, path: :concern do
    resources(:file_sets,
              only: [],
              path: 'container/:parent_id/file_sets',
              as: 'member_file_set') do
      member do
        get :text, defaults: { format: :json }
      end
    end
  end

  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Dynamic robots.txt
  get '/robots.:format' => 'pages#robots'

  # Purl redirects
  get '/purl/:id', to: 'purl#default', as: 'default_purl'

  # iiif search API
  get '/search/:id', to: 'search#search', as: :search
  get '/search', to: 'search#index', as: :default_search
end
