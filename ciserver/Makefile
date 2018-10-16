remote_user = ubuntu
ssh_key_name = keys/terransible_provisioner

ansible/ec2.py:
	curl -o ansible/ec2.py \
		https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
	chmod u+x ansible/ec2.py

ansible/ec2.ini:
	curl -o ansible/ec2.ini \
		https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini

ansible_roles:
	ansible-galaxy install -r ansible/requirements.yml -p ansible/roles

ansible: ansible/ec2.ini ansible/ec2.py ansible_roles

keys:
	mkdir keys
	ssh-keygen -t rsa \
		-C terransible_provisioner \
		-f $(ssh_key_name) \
		-P ''

clean:
	rm -rf ansible/roles/
	rm ansible/ec2.py
	rm ansible/ec2.ini
	rm -rf keys

build: terraform apply

provision: ansible
	ANSIBLE_HOST_KEY_CHECKING=false \
	ANSIBLE_REMOTE_USER=$(remote_user) \
	ANSIBLE_PRIVATE_KEY_FILE=$(ssh_key_name) \
	ansible-playbook -i ansible/ec2.py ansible/main.yml \
		--extra-vars='{"pipeline_repo":"$(repo)", "pipeline_project_name":"$(project_name)", "jenkins_auth_user": "$(jenkins_auth_user)", "jenkins_auth_password": "$(jenkins_auth_password)"}'

jenkins: build provision