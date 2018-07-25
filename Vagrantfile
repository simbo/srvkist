Vagrant.configure(2) do |config|
  config.vm.define 'srvkist' do |machine|
    machine.vm.box = "ubuntu/bionic64"
    machine.vm.provision "ansible" do |ansible|
      ansible.playbook = "first-run.yml"
      ansible.become = true
    end
  end
end
