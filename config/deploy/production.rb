set :application, 'walletone.kiiiosk.ru'
set :stage, :production
#set :repo_url, 'https://github.com/eychu/insales_walletone.git'
set :repo_url, 'https://github.com/saymon21root/insales_walletone.git'
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, ->{"/home/insales-walletone/#{fetch(:application)}"}
server 'walletone.kiiiosk.ru', user: 'insales-walletone', port: 2227, roles: %w{web app db}
set :rails_env, :production
set :branch, ENV['BRANCH'] || 'master'
fetch(:default_env).merge!(rails_env: :production)
