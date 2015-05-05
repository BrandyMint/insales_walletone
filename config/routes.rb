Rails.application.routes.draw do
  root 'main#index'

  post 'pay' => 'pay#pay'
  post 'fail' => 'pay#fail'
  post 'success' => 'pay#success'

  mount WalletoneMiddleware.new => '/walletone_result'

  namespace :main do
    get :manual
    get :initialize_payment_gateway
    get :new_payment_gateway
  end

  resource :accounts, only: :update do
    get :autologin
    get :install
    get :uninstall
  end

  resources :merchants, only: [:index, :show]
end
