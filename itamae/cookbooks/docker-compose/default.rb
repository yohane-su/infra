# cookbook for docker-compose(v2)

package 'docker.io'

COMPOSE_VERSION="v2.2.2"
COMPOSE_ARCH="x86_64"
COMPOSE_BIN="https://github.com/docker/compose/releases/download/#{COMPOSE_VERSION}/docker-compose-linux-#{COMPOSE_ARCH}"

define :download_github_binary, tag: nil, file: nil, target: nil  do
  project = params[:name]

  url = "https://github.com/#{project}/releases/"
  # latest
  if params[:tag].nil?
    url += "latest/download/"
  else
    url += "download/#{params[:tag]}/"
  end
  url += "#{params[:file]}"

  target = params[:target]
  if target.nil?
    target = "/tmp/#{params[:file]}"
  end
  #basedir = run_command("dirname #{target}").stdout
  #run_command("mkdir -p #{basedir}")
  run_command("curl -fL \"#{url}\" -o #{target}")
end

define :install_github_binary, tag: nil, file: nil, target: nil  do
  p_file = params[:file]
  if p_file.nil?
    p_file = project.split('/')[1]
  end

  p_target = params[:target]
  if p_target.nil?
    p_target = "/usr/local/bin/#{p_file}"
  end

  p_tag = params[:tag]
  download_github_binary params[:name] do
    tag p_tag if p_tag
    file p_file if p_file
    target "#{p_target}"
  end

  run_command("chmod +x #{p_target}")
end

# install docker-compose(v2)
# https://docs.docker.com/compose/cli-command/#install-on-linux
run_command("mkdir -p /home/ubuntu/.docker/cli-plugins")
#directory "/home/ubuntu/.docker/cli-plugins" # なぜか動かない！！！

install_github_binary 'docker/compose' do
  file "docker-compose-linux-#{COMPOSE_ARCH}"
  target "/home/ubuntu/.docker/cli-plugins/docker-compose"
end
