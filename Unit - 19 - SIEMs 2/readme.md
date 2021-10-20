## Unit 19 Homework: Protecting VSI from Future Attacks

### Scenario

In the previous class,  you set up your SOC and monitored attacks from JobeCorp. Now, you will need to design mitigation strategies to protect VSI from future attacks. 

You are tasked with using your findings from the Master of SOC activity to answer questions about mitigation strategies.

---

### Part 1: Windows Server Attack

Note: This is a public-facing windows server that VSI employees access.
 
#### Question 1
- Several users were impacted during the attack on March 25th.
- Based on the attack signatures, what mitigations would you recommend to protect each user account? Provide global mitigations that the whole company can use and individual mitigations that are specific to each user.

  On a global scale, the ideal mitigations are as follows;
  - Incorporating 2FA for all authorized users
  - Utilize a security protocol that only allows whitelisted IPs to access these servers
  - Utilize a security protocol that automatically blocks any IP on a designed blacklist
  - Institute stricter account lockout process that will keep accounts secure from attacks

  On an individual scale all affected users should change their passwords and use strong passwords with higher entropy so it becomes more challenging for their accounts to be accessed by unauthorized individuals. 
  
  you could also add in a bussiness policy that forces users to change their passwords every 3 months to make this type of attack harder for bad actors to pull off in the future.

#### Question 2
- VSI has insider information that JobeCorp attempted to target users by sending "Bad Logins" to lock out every user.
- What sort of mitigation could you use to protect against this?

  On top of utilizing the mitigations mentioned from question 1 we can tighten the threshhold for that specific signiture so splunk can alert us earlier to said attack being deployed against our systems.

---

### Part 2: Apache Webserver Attack:

#### Question 1
- Based on the geographic map, recommend a firewall rule that the networking team should implement.
- Provide a "plain english" description of the rule.
  - For example: "Block all incoming HTTP traffic where the source IP comes from the city of Los Angeles."
- Provide a screen shot of the geographic map that justifies why you created this rule. 
  
  Assuming that the company is only expecting IP accessing their servers to be from the US then we can institute a rule that states all IPs outside of the US is blocked.

  However if we are expecting traffic from outside of the US then we can block all IPs coming from Ukraine

![Geolocation Evidence](Images/ue.png)

#### Question 2

- VSI has insider information that JobeCorp will launch the same webserver attack but use a different IP each time in order to avoid being stopped by the rule you just created.

- What other rules can you create to protect VSI from attacks against your webserver?
  - Conceive of two more rules in "plain english". 
  - Hint: Look for other fields that indicate the attacker.
  
  - Only IP addresses from the selected whitelist can access company servers
  - Since VSI utilizes the Mozilla/5.0 user agent we can then design a rule that will block all other user agents, or specifically the Mozilla/4.0 since most of our attacks are coming from that user agent
---

© 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.
