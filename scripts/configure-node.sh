#!/bin/bash

check_os() {
  name=$(cat /etc/os-release | grep ^NAME= | sed 's/"//g' | cut -d= -f2)
  version=$(cat /etc/os-release | grep ^VERSION_ID= | sed 's/"//g' | cut -d= -f2)
  
  echo "K3S install process running on: $name $version"

  if [[ "$name" != "Ubuntu" ]]; then
    echo "Operating system not Ubuntu"
    exit 1
  fi
}

configure_ubuntu() {
  # Disable firewall 
  /usr/sbin/netfilter-persistent stop
  /usr/sbin/netfilter-persistent flush

  systemctl stop netfilter-persistent.service
  systemctl disable netfilter-persistent.service
  # END Disable firewall

  apt-get update
  apt-get install -y software-properties-common jq
  DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get upgrade -y

  # Fix /var/log/journal dir size
  echo "SystemMaxUse=100M" >> /etc/systemd/journald.conf
  echo "SystemMaxFileSize=100M" >> /etc/systemd/journald.conf
  systemctl restart systemd-journald
}

check_os
configure_ubuntu

INSTALL_PARAMS="--tls-san ${public_lb_ip} --flannel-backend=none --cluster-cidr=${k3s_subnet_cidr} --disable-network-policy --disable traefik"

%{ if k3s_version == "latest" }
K3S_VERSION=$(curl --silent https://api.github.com/repos/k3s-io/k3s/releases/latest | jq -r '.name')
%{ else }
K3S_VERSION="${k3s_version}"
%{ endif }


until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$K3S_VERSION sh -- $INSTALL_PARAMS); do
  echo 'k3s did not install correctly'
  sleep 2
done

until kubectl get pods -A | grep 'Running'; do
  echo 'Waiting for k3s startup'
  sleep 5
done

echo "End of server configuration"
