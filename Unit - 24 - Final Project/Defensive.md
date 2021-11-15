# Blue Team: Summary of Operations

## Table of Contents
- Network Topology
- Description of Targets
- Monitoring the Targets
- Patterns of Traffic & Behavior
- Suggestions for Going Further

### Network Topology

The following machines were identified on the network:
- Kali
  - **Operating System**: Debian Kali 5.4.0
  - **Purpose**: The Pentester
  - **IP Address**: 192.169.1.90
- ELK
  - **Operating System**: Ubuntu 18.04
  - **Purpose**: The elastic stack (Elasticsearch and Kibana)
  - **IP Address**: 192.168.1.100
- Target 1
  - **Operating System**: Debian GNU/Linux 8
  - **Purpose**: The WordPress Host (Victim)
  - **IP Address**: 192.168.1.110
- Capstone
  - **Operating System**: Ubuntu 18.04
  - **Purpose**: The Vulnerable webserver
  - **IP Address**: 192.168.1.105

### Description of Targets

The target of this attack was: `Target 1` 192.168.1.110

Target 1 is an Apache web server and has SSH enabled, so ports 80 and 22 are possible ports of entry for attackers. As such, the following alerts have been implemented:

### Monitoring the Targets

Traffic to these services should be carefully monitored. To this end, we have implemented the alerts below:

#### Excessive HTTP Errors

Alert 1 is implemented as follows:
  - **Metric**: WHEN count() GROUPED OVER top 5 'http.response.status_code' 
  - **Threshold**:  IS ABOVE 400 FOR THE LAST 5 MINUTES
  - **Vulnerability Mitigated**: Enumeration/Brute Force
  - **Reliability**: Reliable - Measuring by 400 error codes will filter out any normal access activity. by having 400+ in 5 minutes we can easily tell an attack is happening.

![watcher1](./images/watcher_1.png)

#### HTTP Request Size Monitor

Alert 2 is implemented as follows:
  - **Metric**: WHEN sum() of http.request.bytes OVER all documents
  - **Threshold**: IS ABOVE 3500 FOR THE LAST 1 minute
  - **Vulnerability Mitigated**: Code Injection in http requests (XSS and CRLF) or DDOS
  - **Reliability**: Alert could potentially result in false positives. it is still fairly reliable but will need adjusting in the future as there is the possibility for legitimate HTTP traffic to cause alerts.

![watcher2](./images/watcher_2.png)

#### CPU Usage Monitor

Alert 3 is implemented as follows:
  - **Metric**: WHEN max() OF system.process.cpu.total.pct OVER all documents
  - **Threshold**: IS ABOVE 0.5 FOR THE LAST 5 minutes
  - **Vulnerability Mitigated**: Malicious Software, programs (malware or viruses) running and taking up resources.
  - **Reliability**: This alert is fairly reliable but may return a few false positives, but we can also use that to further optimise CPU usage on the machine aswell.

![watcher3](./images/watcher_3.png)


### Suggestions for Going Further (Optional)
 
- Each alert above pertains to a specific vulnerability/exploit. Recall that alerts only detect malicious behavior, but do not stop it. For each vulnerability/exploit identified by the alerts above, suggest a patch. E.g., implementing a blocklist is an effective tactic against brute-force attacks. It is not necessary to explain _how_ to implement each patch.

The logs and alerts generated during the assessment suggest that this network is susceptible to several active threats, identified by the alerts above. In addition to watching for occurrences of such threats, the network should be hardened against them. The Blue Team suggests that IT implement the fixes below to protect the network:


- Excessive HTTP Errors

  - **Patch**: Word Press Hardening. 
    - Implement updates to the following; WorPress core, PHP Version and Plugins. Perform these updates regularly.
    - Install Security based plugins, for example Wordfence
    - Disable Unused Wordpress Features for example;
      - WordPress XML-RPC
      - WordPress REST API
    - Block requests to /?author= by configuring web server settings correctly
    - Remove a Public Facing WordPress Login, specifically for;
      - /wp-admin
      - /wp-login.php
  - **Why It Works**: 
    - By keeping wordpress updated there will be patches that fix known and easily abused exploits.
    - WordPress security plugins can provide useful benifits such as;
      - Malware scans.
      - Firewall.
      - IP options (to block suspicious IPs)
    - REST API is used by WPscan to enumerate users and such is a vulnerability.
    - XML-RPC uses HTTP as a method of data transport - which is insecure and unencrypted.
    - Blocking Requests to view authors helps prevent enumeration.
    - Removing Public Facing access to the wordpress login helps reduce the surface for attack.

- HTTP Request Size Monitor

  - **Patch**: Implementation of HTTP request limits on the web server. Limits can include several things to aid in protection from code injection/ DDOS
    - Maximum URL length
    - Maximum query string length
    - Maximum size of request.
  - we can also include form validation upon completion to ensure there is no code injection.
  - **Why It Works**: If a HTTP URL length, query string go over a limit then return a 404 error.
    - this will reject any request that is too large
  - input validation will help protect against malicious data that an attacker sends to the server via the web application in or accross a HTTP request.

- CPU Usage Monitor

  - **Patch**: Add or Update a good Antivirus software and Implement a good HIDS (Host based Intrusion Detection System) for example Snort.
  - **Why It Works**: Antiviruses specialize in the detection, removal and prevention of potentially malicious software or threats. They also have an ever growing database of known malicious software so the antivirus will continue to expand it's Knowledge and become more effective.
  Using a HIDS allows for automatic detection and automatic responses to said attacks which will allow for an automated defense within the structure of the server itself. it can also monitor and analyze network packets.
