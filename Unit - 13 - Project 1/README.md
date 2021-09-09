## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

[Project Diagram](Images/Project-Diagram.drawio.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook files may be used to install only certain pieces of it, such as Filebeat.

 [Elk Install](Playbooks/install-elk.yml)
 [Filebeat Install](Playbooks/filebeat-playbook.yml)
 [Metricbeat Install](Playbooks/metricbeat-playbook.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- Load balancer make sure that my DVWA is always available by routing traffic between all 3 of the servers at a time, thus, making sure they don't easily get overburdened and ensures the availability is maintained even if one machine is taken down for any reason. The Jumpbox acts as a gateway directly into the DVWA machines so only those with authorized access can log into the machines and make changes.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the Logs and system Traffic.
- Filebeat watches for all chages to the log files and locations we specify. it will also collect data and send it to elastic search so it is easier for us to observe these changes.
- Metricbeat records the metrics from the targeted operating system and can show us any changes to the services running on the server, it will also send this information through to elastic search to make it easier for us to observe.

The configuration details of each machine may be found below.

|         Name         	|  Function  	| IP Address 	|   Operating System   	|
|:--------------------:	|:----------:	|:----------:	|:--------------------:	|
| Jump-Box-Provisioner 	|   Gateway  	|  10.1.0.4  	| Linux - Ubuntu 18.04 	|
| Web-1                	| Web Server 	|  10.1.0.5  	| Linux - Ubuntu 18.04 	|
| Web-2                	| Web Server 	|  10.1.0.6  	| Linux - Ubuntu 18.04 	|
| Web-3                	| Web Server 	|  10.1.0.9  	| Linux - Ubuntu 18.04 	|
| Project-VM1          	|  ELK Stack 	|  10.0.0.4  	| Linux - Ubuntu 18.04 	|

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jumpbox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 159.196.248.219

Machines within the network can only be accessed by the Jump box via SSH.
- Only the Jumpbox has access to the ELK stack Server via SSH, the IP is 10.1.0.4

A summary of the access policies in place can be found in the table below.

|         Name         	|        Publicly Accessible        	|    Allowed IP Addresses    	|
|:--------------------:	|:---------------------------------:	|:--------------------------:	|
| Jump-Box-Provisioner 	|                Yes                	|       159.196.248.219      	|
| Web-1                	| Yes - via Load Balancer (HTTP:80) 	| 10.1.0.4 From jumpbox only 	|
| Web-2                	| Yes - via Load Balancer (HTTP:80) 	| 10.1.0.4 From jumpbox only 	|
| Web-3                	| Yes - via Load Balancer (HTTP:80) 	| 10.1.0.4 From jumpbox only 	|
| Project-VM1          	|        Yes - Via HTTP:5601        	| 10.1.0.4 From jumpbox only 	|

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- Using Ansible automates the creation process thus reducing the chance of human error if the server needs to be setup multiple times, thus, increasing the consistancy and ease of set up.

The playbook implements the following tasks:
- Install Docker
- Install Python
- Install Docker's Python Module
- Increase the available memory for the ELK stack
- Download and Launch the ELK container

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

[Docker ps Success](Images/elk-docker.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.1.0.5
- Web-2: 10.1.0.6
- Web-3: 10.1.0.9

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat collects information from logs and any changes made
- Metricbeat collects information on the metrics from the OS and reports changes through any services running

I also have the Visual Proof of Both Metricbeat and Filebeat are working correctly as intended;

[Filebeat](Images/filebeat-success.png)
[Metricbeat](Images/metricbeat-success.png)

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the Playbook file to The Ansible container.
- Update the hosts file to include;

 ## [webservers] 
 ## 10.1.0.5 ansible_python_interpreter=/usr/bin/python3 
 ## 10.1.0.6 ansible_python_interpreter=/usr/bin/python3 
 ## 10.1.0.9 ansible_python_interpreter=/usr/bin/python3

## [elk] 
## 10.0.0.4 ansible_python_interpreter=/usr/bin/python3

- Also update ansible.cfg to set the remote_user parameter since all of our VM's in this project use the same username.

- Run the playbook, and navigate to  http://20.36.33.3/setup.php to check that the installation worked as expected.
- Also navigate to 40.113.225.39:5601 to test is the Elk playbook has been correctly set up.

You can use these Specific commands to work these playbooks on MY Networks specifically;
ssh RedAdmin@20.36.33.3 - to connect to the Jump Box machine.
sudo docker ps -a - to list the installed containers
sudo docker start silly_franklin - to start the specific container
sudo docker attach silly_franklin - to attach to the said container
ansible webservers -m command -a "ps aux" - to run a command on all machines in the webservers group at the same time, in this case listing all running services
ansible-playbook elk-install.yml - to run a playbook, in this case the elk installation playbook.