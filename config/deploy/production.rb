set :application, 'insale.walletone.com'
set :stage, :production
set :repo_url, 'git@github.com:BrandyMint/insales_walletone.git'
set :deploy_to, ->{"/home/insales_user/#{fetch(:application)}"}
server 'insale.walletone.com', user: 'insales_user', port: 2227, roles: %w{web app db}
set :rails_env, :production
set :branch, ENV['BRANCH'] || 'master'
fetch(:default_env).merge!(rails_env: :production)
