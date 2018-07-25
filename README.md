srvkist
=======

  > Ansible scripts for bootstrapping, securing and managing an ubuntu server.

---

<!-- TOC -->

- [Requirements](#requirements)
- [Usage](#usage)
  - [First Run](#first-run)
  - [Bootstrapping](#bootstrapping)
  - [Letsencrypt](#letsencrypt)
    - [Creating certificates](#creating-certificates)
  - [nginx](#nginx)
    - [Update configs only](#update-configs-only)
  - [Docker](#docker)
  - [Create user](#create-user)
  - [Reboot](#reboot)
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

See `./group_vars/` for common task settings.  
Also take a look at the file templates in `templates/` within the respective
roles directory.


### Bootstrapping

``` sh
ansible-playbook playbook.yml -t bootstrap
```

… will run the following tasks:

  - Set hostname from `group_vars`
  - Update packages and set automatic unattended upgrades
  - Add public ssh keys for ansible/admin user (see `./roles/bootstrap/templates/public-keys/`)
  - Create SFTP group
  - Setup fail2ban
  - Set iptables rules and automatically restore them
    (see `./roles/bootstrap/templates/iptables/iptables.sh`)
  - Disallow ssh access for root and disable password auth
  - Delete root password
  - Set locale and timezone from `group_vars`
  - Setup ntp for time sync
  - Install optional packages from `group_vars`


### Letsencrypt

``` sh
ansible-playbook playbook.yml -t letsencrypt
```

… will run the following tasks:

  - Install certbot and letsencrypt from `ppa:cerbot/certbot`
  - Instruct openssl to produce "dsa-like" dhparams
    [security.stackexchange.com/a/95184](https://security.stackexchange.com/a/95184)
  - Create certificates for domains from `group_vars`
  - Create cronjob for certbot auto-renewal of existing certificates


#### Creating certificates

Add domains to the `letsencrypt_domains` list in `group_vars` to
create certificates when running the letsencrypt playbook tasks.

**Or** manually create a certificate for one or more domains using certbot:

``` sh
ansible-playbook cert.yml
```

However they were created, generated certificates will be automatically renewed.


### nginx

``` sh
ansible-playbook playbook.yml -t nginx
```

… will run the following tasks:

  - Install nginx
  - Copy nginx.conf, common configs and sites configs (see `./roles/nginx/templates/`)
  - Remove unmanaged configs
  - Ensure nginx cache and public html directory properties
  - Remove default nginx site configuration


#### Update configs only

``` sh
ansible-playbook playbook.yml -t nginxconf
```

… will run the following tasks:

  - Copy nginx.conf, common configs and sites configs (see `./roles/nginx/templates/`)
  - Remove unmanaged configs


### Docker

``` sh
ansible-playbook playbook.yml -t docker
```

… will run the following tasks:

  - Install docker and docker-compose with required dependencies and apt sources


### Create user

``` sh
ansible-playbook user.yml
```

… will prompt for options and create a system user.


### Reboot

``` sh
ansible-playbook reboot.yml
```

… will reboot the system and wait for it to come back.


## Development

You can use vargrant to create a virtual server for testing and development.

``` sh
vagrant up
ln -s .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory vagranthosts
ansible-playbook -i vagranthosts <PLAYBOOK> [-t <TAG>]
```

Calling `vagrant up` will automatically use `first-run-yml` for provisioning.


## License

The MIT License (MIT)  
Copyright © 2016 Simon Lepel <simbo@simbo.de>
