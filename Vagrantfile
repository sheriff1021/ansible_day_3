Vagrant.configure("2") do |config|
	config.vm.define "b1" do |b1|
		b1.vm.box = "hashicorp/precise32"
		b1.vm.provider "virtualbox" do |ob|
			ob.name = "k1"
			ob.customize ["modifyvm", :id, "--memory", "1024"]
			end
	end

	
end
