set :application, 'walletone.kiiiosk.ru'
set :stage, :staging
#set :repo_url, 'https://github.com/eychu/insales_walletone.git'
set :repo_url, 'git@github.com:BrandyMint/insales_walletone.git'
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, ->{"/home/insales-walletone/#{fetch(:application)}"}
server 'walletone.kiiiosk.ru', user: 'insales-walletone', port: 2228, roles: %w{web app db}
set :rails_env, :staging
set :branch, ENV['BRANCH'] || 'master'
fetch(:default_env).merge!(rails_env: :staging)
