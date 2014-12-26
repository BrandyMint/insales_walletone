Rails.application.routes.draw do
  root 'mains#index'

  post 'pay' => 'pays#pay'
  post 'fail' => 'pays#fail'
  post 'success' => 'pays#success'
  post 'walletone_result' => 'pays#walletone_result'

  resource :main, only: [] do
    get :manual
    get :initialize_payment_gateway
    get :new_payment_gateway
  end

  resource :accounts, only: :update do
    get :install
    get :uninstall
  end
end
