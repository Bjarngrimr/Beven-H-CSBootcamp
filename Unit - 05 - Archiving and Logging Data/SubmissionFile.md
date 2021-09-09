## Week 5 Homework Submission File: Archiving and Logging Data

Please edit this file by adding the solution commands on the line below the prompt.

Save and submit the completed file for your homework submission.

---

### Step 1: Create, Extract, Compress, and Manage tar Backup Archives

1. Command to **extract** the `TarDocs.tar` archive to the current directory:
	tar xvvf TarDocs.tar

2. Command to **create** the `Javaless_Doc.tar` archive from the `TarDocs/` directory, while excluding the `TarDocs/Documents/Java` directory:
	tar -cvvf Javaless_Docs.tar --exclude=./TarDocs/Documents/Java ./TarDocs/Documents/

3. Command to ensure `Java/` is not in the new `Javaless_Docs.tar` archive:
	tar -tvf Javaless_Docs.tar | grep Java

**Bonus** 
- Command to create an incremental archive called `logs_backup_tar.gz` with only changed files to `snapshot.file` for the `/var/log` directory:
	sudo tar -cvvzf logs_backup.tar.gz --listed-incremental=logs_backup.snar --level=0 /var/log

#### Critical Analysis Question

- Why wouldn't you use the options `-x` and `-c` at the same time with `tar`?
-c is to create a new tar and -x is to extract from tar

---

### Step 2: Create, Manage, and Automate Cron Jobs

1. Cron job for backing up the `/var/log/auth.log` file:
	0 6 * * 3 sudo tar -cvvzf /auth_backup.tgz /var/log/auth.log

---

### Step 3: Write Basic Bash Scripts

1. Brace expansion command to create the four subdirectories:
	mkdir -p ~/backups/{freemem,diskuse,openlist,freedisk}

2. Paste your `system.sh` script edits below:

    ```bash
    #!/bin/bash

	#Listing Free memory, also includes other memory types for referance
	free -h > ~/backups/freemem/free_mem.txt

	#Displays the Disk usage
	du -h > ~/backups/diskuse/disk_usage.txt

	#creates a list of all currently open files, excluding */gvfs as even root has no access
	lsof -e /run/user/1000/gvfs > ~/backups/openlist/open_list.txt

	#Displays the stats of the disk while ommiting irrelevant results
	df -hx squashfs --total > ~/backups/freedisk/free_disk.txt

    ```

3. Command to make the `system.sh` script executable:
	chmod u+x system.sh

**Optional**
- Commands to test the script and confirm its execution:
	sudo ./system.sh
	ls -al ~/backups/{freemem,diskuse,openlist,freedisk}
 
**Bonus**
- Command to copy `system` to system-wide cron directory:
	sudo cp system.sh /etc/cron.weekly/
---

### Step 4. Manage Log File Sizes
 
1. Run `sudo nano /etc/logrotate.conf` to edit the `logrotate` configuration file. 

    Configure a log rotation scheme that backs up authentication messages to the `/var/log/auth.log`.

    - Add your config file edits below:

    ```bash
	# see "man logrotate" for details
	# rotate log files weekly
	weekly

	# use the syslog group by default, since this is the owning group
	# of /var/log/syslog.
	su root syslog

	# keep 4 weeks worth of backlogs
	rotate 4

	# create new (empty) log files after rotating old ones
	create

	# uncomment this if you want your log files compressed
	compress

	# packages drop log rotation information into this directory
	include /etc/logrotate.d

	# no packages own wtmp, or btmp -- we'll rotate them here
	/var/log/wtmp {
	    missingok
	    monthly
	    create 0664 root utmp
	    rotate 1
	}

	/var/log/btmp {
	    missingok
	    monthly
	    create 0660 root utmp
	    rotate 1
	}

	# system-specific logs may be configured here
	/var/log/auth.log {
	    weekly
	    rotate 7
	    notifempty
	    delaycompress
	    missingok
	}

    ```
---

### Bonus: Check for Policy and File Violations

1. Command to verify `auditd` is active:
	systemctl status auditd

2. Command to set number of retained logs and maximum log file size:

    - Add the edits made to the configuration file below:
	max_log_file = 35
	num_logs = 7
    ```bash
	#
	# This file controls the configuration of the audit daemon
	#

	local_events = yes
	write_logs = yes
	log_file = /var/log/audit/audit.log
	log_group = adm
	log_format = RAW
	flush = INCREMENTAL_ASYNC
	freq = 50
	max_log_file = 35
	num_logs = 7
	priority_boost = 4
	disp_qos = lossy
	dispatcher = /sbin/audispd
	name_format = NONE
	##name = mydomain
	max_log_file_action = ROTATE
	space_left = 75
	space_left_action = SYSLOG
	verify_email = yes
	action_mail_acct = root
	admin_space_left = 50
	admin_space_left_action = SUSPEND
	disk_full_action = SUSPEND
	disk_error_action = SUSPEND
	use_libwrap = yes
	##tcp_listen_port = 60
	tcp_listen_queue = 5
	tcp_max_per_addr = 1
	##tcp_client_ports = 1024-65535
	tcp_client_max_idle = 0
	enable_krb5 = no
	krb5_principal = auditd
	##krb5_key_file = /etc/audit/audit.key
	distribute_network = no
    ```

3. Command using `auditd` to set rules for `/etc/shadow`, `/etc/passwd` and `/var/log/auth.log`:
	auditctl -w /etc/shadow -p rwa -k hashpass_audit
	auditctl -w /etc/passwd -p rwa -k userpass_audit
	auditctl -w /var/log/auth.log -p rwa -k authlog_audit

    - Add the edits made to the `rules` file below:

    ```bash
	## First rule - delete all
	-D

	## Increase the buffers to survive stress events.
	## Make this bigger for busy systems
	-b 8192

	## This determine how long to wait in burst of events
	--backlog_wait_time 0

	## Set failure mode to syslog
	-f 1

	-w /etc/shadow -p wra -k hashpass_audit
	-w /etc/passwd -p wra -k userpass_audit
	-w /var/log/auth.log -p wra -k authlog_audit

    ```

4. Command to restart `auditd`:
	sudo systemctl restart auditd

5. Command to list all `auditd` rules:
	sudo auditctl -l

6. Command to produce an audit report:
	sudo aureport --auth

7. Create a user with `sudo useradd attacker` and produce an audit report that lists account modifications:
	sudo ausearch -k userpass_audit -i | less | grep -i attacker

8. Command to use `auditd` to watch `/var/log/cron`:
	auditctl -w /var/log/cron -k cron_audit
9. Command to verify `auditd` rules:
	
---

### Bonus (Research Activity): Perform Various Log Filtering Techniques

1. Command to return `journalctl` messages with priorities from emergency to error:

1. Command to check the disk usage of the system journal unit since the most recent boot:

1. Comand to remove all archived journal files except the most recent two:


1. Command to filter all log messages with priority levels between zero and two, and save output to `/home/sysadmin/Priority_High.txt`:

1. Command to automate the last command in a daily cronjob. Add the edits made to the crontab file below:

    ```bash
    [Your solution cron edits here]
    ```

---
© 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.
