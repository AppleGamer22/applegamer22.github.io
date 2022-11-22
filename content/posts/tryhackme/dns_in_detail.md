# TryHackMe [DNS in Detail](https://www.tryhackme.com/room/dnsindetail)
### References
* Try Hack Me. (2021). DNS in Detail - How the web works [YouTube Video]. In YouTube. https://youtu.be/jpTY1S5vs9k
## What is DNS?
### What does DNS Stand for?
* According to the information provided in the question:
> DNS (Domain Name System) provides a simple way for us to communicate with devices on the internet without remembering complex numbers.

**Answer**: `Domain Name System`
## Domain Hierarchy
### What is the maximum length of a subdomain?
* According to the information provided in the question:
> A subdomain name has the same creation restrictions as a Second-Level Domain, being limited to 63 characters and can only use a-z 0-9 and hyphens (cannot start or end with hyphens or have consecutive hyphens).

**Answer**: `63`
### Which of the following characters cannot be used in a subdomain: `3`, `b`, `_` or `-`?
**Answer**: `_`
### What is the maximum length of a domain name?
* According to the information provided in the question:
> You can use multiple subdomains split with periods to create longer names, such as `jupiter.servers.tryhackme.com`. But the maximum length must be kept below 253 characters.

**Answer**: `253`
### What type of TLD is `.co.uk`?
* According to the information provided in the question:
> There are two types of TLD, gTLD (Generic Top Level) and ccTLD (Country Code Top Level Domain).

**Answer**: `ccTLD`
## Record Types
### What type of record would be used to advise where to send email?
* According to the information provided in the question:
> #### MX Record
> These records resolve to the address of the servers that handle the email for the domain you are querying...

**Answer**: `MX`
### What type of record handles IPv6 addresses?
* According to the information provided in the question:
> #### AAAA Record
> These records resolve to IPv6 addresses, for example 2606:4700:20::681a:be5

**Answer**: `AAAA`
## Making A Request
### What field specifies how long a DNS record should be cached for?
* According to the information provided in the question:
> DNS records all come with a TTL (Time To Live) value. This value is a number represented in seconds that the response should be saved for locally until you have to look it up again.

**Answer**: `TTL`
### What type of DNS Server is usually provided by your ISP?
* According to the information provided in the question:
> A Recursive DNS Server is usually provided by your ISP, but you can also choose your own.

**Answer**: `recursive`
### What type of server holds all the records for a domain?
* According to the information provided in the question:
> An authoritative DNS server is the server that is responsible for storing the DNS records for a particular domain name and where any updates to your domain name DNS records would be made.

**Answer**: `authoritative`
## Practical
### What is the CNAME of `shop.website.thm`?
* Using the interactive terminal provided:
```bash
user@thm:~$ nslookup --type=CNAME shop.website.thm
Server: 127.0.0.53
Address: 127.0.0.53#53

Non-authoritative answer:
shop.website.thm canonical name = shops.myshopify.com
```

**Answer**: `shops.myshopify.com`
### What is the value of the TXT record of website.thm?
* Using the interactive terminal provided:
```bash
user@thm:~$ nslookup --type=TXT website.thm
Server: 127.0.0.53
Address: 127.0.0.53#53

Non-authoritative answer:
website.thm text = "THM{7012BBA60997F35A9516C2E16D2944FF}"
```

**Answer**: `THM{7012BBA60997F35A9516C2E16D2944FF}`
### What is the numerical priority value for the MX record?
* Using the interactive terminal provided:
```bash
user@thm:~$ nslookup --type=MX website.thm
Server: 127.0.0.53
Address: 127.0.0.53#53

Non-authoritative answer:
website.thm mail exchanger = 30 alt4.aspmx.l.google.com
```

**Answer**: `30`
### What is the IP address for the A record of `www.website.thm`?
* Using the interactive terminal provided:
```bash
user@thm:~$ nslookup --type=A website.thm
Server: 127.0.0.53
Address: 127.0.0.53#53

Non-authoritative answer:
Name: website.thm
Address: 10.10.10.10
```

**Answer**: `10.10.10.10`