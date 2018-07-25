srvkist
=======

  > Ansible scripts for bootstrapping, securing and managing an ubuntu server.

---

<!-- TOC -->

- [Requirements](#requirements)
- [Preparations](#preparations)
  - [First Run](#first-run)
- [Usage](#usage)
  - [Playbook `setup.yml`](#playbook-setupyml)
    - [Tag `bootstrap`](#tag-bootstrap)
    - [Tag `acme-sh`](#tag-acme-sh)
    - [Tag `nginx`](#tag-nginx)
    - [Tag `nginxconf`](#tag-nginxconf)
    - [Tag `docker`](#tag-docker)
  - [Playbook `issue-cert.yml`](#playbook-issue-certyml)
  - [Playbook `user.yml`](#playbook-useryml)
  - [Playbook `reboot.yml`](#playbook-rebootyml)
- [Development](#development)
- [License](#license)

<!-- /TOC -->

---


## Requirements

  - [ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)  
    Install via pip: `sudo easy_install pip && sudo pip install ansible`

  - `passlib` for creating hashes with ansible  
    Install via pip: `sudo pip install passlib`

  - [vagrant](https://www.vagrantup.com/downloads.html) and
    [VirtualBox](https://www.virtualbox.org/wiki/Downloads)  
    (if you want to run playbooks against a local vm for development)


## Preparations

We're assuming, you have just set up a server with **Ubuntu 18.04 LTS** minimum
installation and you have root access using ssh (password or keyfile)

Edit the project files according to your needs:

  - Edit `./hosts` to match your server ip and port.

  - Create `vault_password_file` containing the password for ansible vault:

    ``` sh
    echo -n "secret-password" > vault_password_file
    ```

  - Edit settings in `./group_vars/all` if necessary


### First Run

Run `first-run.yml` to install minimum requirements and create the admin user
for ansible. This is the only playbook that uses the root user. Specify keyfile
or password if necessary:

``` sh
ansible-playbook --user root [--ask-pass] [--key-file path/to/id] first-run.yml
```


## Usage

``` sh
ansible-playbook <PLAYBOOK> [-t <TAG>]
```

See `./group_vars/` for common task settings.

Read through playbooks and tasks. They are self-explaining.


### Playbook `setup.yml`

Runs all tags by order:

``` sh
ansible-playbook setup.yml
```


#### Tag `bootstrap`

``` sh
ansible-playbook setup.yml -t bootstrap
```

Changes:

  - set the hostname
  - update apt package cache; upgrade apt to the latest packages; install
    unattended-upgrades package; adjust apt update intervals; only installs from
    security channel
  - create `sftponly` group
  - setup iptables (see `./roles/bootstrap/templates/iptables/iptables.sh`)
  - setup fail2ban
  - disallow password authentication for all users; disallow ssh access for
    root; delete root password
  - set locale and timezone
  - setup ntp
  - install optional packages


#### Tag `acme-sh`

``` sh
ansible-playbook setup.yml -t acme-sh
```

  - setup acme.sh for letsencrypt certificate creation and renewal
  - set letsencrypt account email for notifications


#### Tag `nginx`

``` sh
ansible-playbook setup.yml -t nginx
```

Changes:

  - install nginx
  - copy nginx.conf, common configs and sites configs (see `./roles/nginx/templates/`)
  - remove unmanaged configs
  - ensure nginx cache and public html directory properties
  - remove default nginx site configuration


#### Tag `nginxconf`

``` sh
ansible-playbook setup.yml -t nginxconf
```

Changes:

  - copy nginx.conf, common configs and sites configs (see `./roles/nginx/templates/`)
  - remove unmanaged configs


#### Tag `docker`

``` sh
ansible-playbook setup.yml -t docker
```

Changes:

  - iXnstall docker and docker-compose with required dependencies and apt sources


### Playbook `issue-cert.yml`

``` sh
ansible-playbook issue-cert.yml
```

Issue a certificate using acme.sh for prompted domain (also cares for renewal).


### Playbook `user.yml`

``` sh
ansible-playbook user.yml
```

Create a system user from prompted options.


### Playbook `reboot.yml`

``` sh
ansible-playbook reboot.yml
```

Reboot the system and wait for it to come back.


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
