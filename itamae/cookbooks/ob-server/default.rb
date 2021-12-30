SRV_DIR="/home/ubuntu/srv/ob-server"

git SRV_DIR do
  user "ubuntu"
  repository "https://github.com/sksat/ob-server.git"
  revision "master"
end

# fix clone as "deploy"
execute "checkout master" do
  user "ubuntu"
  cwd SRV_DIR
  command "git switch master"
end

execute "start ob-server" do
  cwd SRV_DIR
  command "docker-compose up -d"
end
