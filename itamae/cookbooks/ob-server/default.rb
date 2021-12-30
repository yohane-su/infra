SRV_DIR="/home/ubuntu/srv/ob-server"

git SRV_DIR do
  repository "https://github.com/sksat/ob-server.git"
end

execute "start ob-server" do
  cwd SRV_DIR
  command "docker-compose up -d"
end
