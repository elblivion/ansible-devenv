#!/bin/bash
set -euo pipefail
email="$1"; shift

echo 'Upgrading system packages...'
#sudo apt-get update
#sudo apt-get upgrade

echo 'Installing packages required to build ansible, lastpass-cli from source...'
sudo apt-get install --no-install-recommends \
	libssl-dev cmake libffi-dev libcurl4-openssl-dev \
	asciidoc xsltproc ansible libxml2-dev

#echo 'Creating virtualenv with Ansible snapshot (for lastpass integration)...'
#virtualenv virtualenv
#set +u; . virtualenv/bin/activate; set -u
#pip install ansible  # replace with ansible from apt once 2.3 reaches Apt

which lpass > /dev/null
if [ $? -ne 0]; then
  echo 'Installing lastpass-cli from source (Ubuntu has a broken, old version)...'
  mkdir -p ~/lastpass
  pushd ~/lastpass
  wget https://github.com/lastpass/lastpass-cli/archive/v1.3.1.tar.gz
  tar -xzf v1.3.1.tar.gz
  cd lastpass-cli-1.3.1
  cmake .
  make
  sudo make install install-doc
  popd
fi

echo 'LastPass login...'
lpass login "$email"

echo 'Ansible bootstrap.yml run...'
ansible-playbook bootstrap.yml -i inventory --ask-become-pass "$@"

echo 'Switch from https origin on this git repo to SSH'
git remote rm origin
git remote add origin git@github.com:elblivion/ansible-devenv.git
git fetch
git branch -u origin/master

echo 'Bootstrap done!'
