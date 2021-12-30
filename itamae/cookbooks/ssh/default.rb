HOME_DIR="/home/ubuntu"

directory "#{HOME_DIR}/.ssh" do
  owner "ubuntu"
end

http_request "#{HOME_DIR}/.ssh/sksat.keys" do
  action :get
  owner "ubuntu"
  sensitive true  # disable everytime show diff
  url "https://github.com/sksat.keys"
end

remote_file "#{HOME_DIR}/.ssh/deploy.keys" do
  owner "ubuntu"
  source "../../../deploy.pub"
end

file "#{HOME_DIR}/.ssh/authorized_keys" do
  action :create
  mode "600"
  cwd "#{HOME_DIR}/.ssh"
  block do |content|
    merged_keys = run_command("cat #{HOME_DIR}/.ssh/authorized_keys").stdout
    merged_keys +=run_command("cat #{HOME_DIR}/.ssh/deploy.keys").stdout
    merged_keys +=run_command("cat #{HOME_DIR}/.ssh/sksat.keys").stdout
    merged_keys = merged_keys.split("\n").uniq.join("\n") + "\n"

    content = merged_keys
  end
end
