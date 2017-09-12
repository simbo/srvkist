srvkist
=======

  > Ansible scripts for bootstrapping, securing and managing an ubuntu server.

---

<!-- TOC -->

- [Requirements](#requirements)
- [Usage](#usage)
  - [First Run](#first-run)
  - [Bootstrapping](#bootstrapping)
  - [nginx](#nginx)
  - [Docker](#docker)
  - [Letsencrypt](#letsencrypt)
    - [Create certificates using certbot](#create-certificates-using-certbot)
- [Development](#development)
- [License](#license)

<!-- /TOC -->

---


## Requirements

  - [ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)


## Usage


### First Run

We're assuming, you have just set up a server with Ubuntu Server 16.04 minimum
installation. There is `openssh-server` installed and you have root access using
a ssh key.

Edit `./hosts` to match your server ip and port.

Create `vault_password_file` containing the password for ansible vault:

``` sh
echo -n "secret-password" > vault_password_file
```

Run `first-run.yml` to install minimum requirements and create the admin user
for ansible:

``` sh
ansible-playbook --user root first-run.yml
```

You are now ready to use `playbook.yml` - all at once or by tags.


### Bootstrapping

``` sh
ansible-playbook playbook.yml -t bootstrap
```

  - Set hostname
  - Update packages and set automatic unattended upgrades
  - Add public ssh keys for ansible admin user
  - Create SFTP group
  - Install fail2ban
  - Set iptables
  - Disallow ssh access for root and disable password auth
  - Delete root password
  - Set local and timezone
  - Install ntp
  - Install optional packages defined in group_vars


### nginx

``` sh
ansible-playbook playbook.yml -t nginx
```

  - Install nginx
  - Copy nginx and sites configurations
  - Ensure nginx cache and public html directory properties
  - Remove default nginx site configuration


### Docker

``` sh
ansible-playbook playbook.yml -t docker
```

  - Install docker and docker-compose with required dependencies and apt sources


### Letsencrypt

``` sh
ansible-playbook playbook.yml -t letsencrypt
```

  - Add `ppa:cerbot/certbot` and install cerbot and letsencrypt
  - Create cronjob for certbot auto-renewal of existing certificates


#### Create certificates using certbot

Create a certificate for one or more domains using certbot:

``` sh
ansible-playbook cert.yml
```


## Development

You can use vargrant to create a virtual server for testing and development.

``` sh
vagrant up
ln -s .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory vagrant
ansible-playbook -i vagrant <PLAYBOOK>
```


## License

The MIT License (MIT)  
Copyright © 2016 Simon Lepel <simbo@simbo.de>
