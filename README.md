srvkist
=======

  > Ansible scripts for bootstrapping, securing and managing an ubuntu server.

---

<!-- TOC -->

- [Requirements](#requirements)
- [Usage](#usage)
  - [First Run](#first-run)
  - [Bootstrapping](#bootstrapping)
  - [Setup nginx](#setup-nginx)
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


### Bootstrapping

``` sh
ansible-playbook playbook.yml -t bootstrap
```


### Setup nginx

``` sh
ansible-playbook playbook.yml -t nginx
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
