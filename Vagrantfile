Vagrant.configure(2) do |config|
  config.vm.define 'srvkist' do |machine|
    machine.vm.box = "ubuntu/xenial64"
    machine.vm.provision "ansible" do |ansible|
      ansible.playbook = "first-run.yml"
      ansible.sudo = true
    end
  end
end
