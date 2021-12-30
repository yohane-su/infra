COMPOSE_CD_ROOT='/home/ubuntu/srv'

include_recipe "../docker-compose"

git "/opt/compose-cd" do
  repository "https://github.com/sksat/compose-cd.git"
  revision "v0.3.0"
  depth 1
end

# instead of compose-cd install
link "/usr/bin/compose-cd" do
  to "/opt/compose-cd/compose-cd"
end

link "/etc/systemd/system/compose-cd.service" do
  to "/opt/compose-cd/compose-cd.service"
end
link "/etc/systemd/system/compose-cd.timer" do
  to "/opt/compose-cd/compose-cd.timer"
end

link "/etc/systemd/system/compose-cd-cleanup.service" do
  to "/opt/compose-cd/compose-cd-cleanup.service"
end
link "/etc/systemd/system/compose-cd-cleanup.timer" do
  to "/opt/compose-cd/compose-cd-cleanup.timer"
end

# config file
directory "/etc/compose-cd"
template "/etc/compose-cd/config" do
  variables(
    search_root: COMPOSE_CD_ROOT,
    git_pull_user: "ubuntu",
    discord_webhook: ENV["COMPOSE_CD_DISCORD_WEBHOOK"]
  )
end

# compose-cd root
directory COMPOSE_CD_ROOT

# start services
service 'compose-cd.timer' do
  action [:enable, :start]
end
service 'compose-cd.service' do
  action [:start] # for OnUnitActiveSec
end

service 'compose-cd-cleanup.timer' do
  action [:enable, :start]
end
