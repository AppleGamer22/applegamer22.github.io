# TryHackMe [Passive Reconnaissance](https://tryhackme.com/room/passiverecon)
## `whois`
```bash
$ whois tryhackme.com
Domain Name: TRYHACKME.COM
Registry Domain ID: 2282723194_DOMAIN_COM-VRSN
Registrar WHOIS Server: whois.namecheap.com
Registrar URL: http://www.namecheap.com
Updated Date: 2021-05-01T19:43:23Z
Creation Date: 2018-07-05T19:46:15Z
Registry Expiry Date: 2027-07-05T19:46:15Z
Registrar: NameCheap, Inc.
Registrar IANA ID: 1068
Registrar Abuse Contact Email: abuse@namecheap.com
Registrar Abuse Contact Phone: +1.6613102107
Domain Status: clientTransferProhibited https://icann.org/epp#clientTransferProhibited
Name Server: KIP.NS.CLOUDFLARE.COM
Name Server: UMA.NS.CLOUDFLARE.COM
DNSSEC: unsigned
URL of the ICANN Whois Inaccuracy Complaint Form: https://www.icann.org/wicf/
```
### When was TryHackMe registered?
**Answer**: `20180705`
### What is the registrar of TryHackMe?
**Answer**: `namecheap.com`
### Which TryHackMe using for name servers?
**Answer**: `cloudflare.com`
## `nslookup` & `dig`
###	Check the TXT records of `thmlabs.com`, What is the flag there?
```bash
$ dig thmlabs.com TXT
; <<>> DiG 9.17.19-1-Debian <<>> thmlabs.com TXT
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 9130
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;thmlabs.com.                   IN      TXT

;; ANSWER SECTION:
thmlabs.com.            300     IN      TXT     "THM{a5b83929888ed36acb0272971e438d78}"

;; Query time: 508 msec
;; SERVER: 10.0.2.3#53(10.0.2.3) (UDP)
;; WHEN: Fri Nov 05 04:49:59 EDT 2021
;; MSG SIZE  rcvd: 90
```

**Flag**: `THM{a5b83929888ed36acb0272971e438d78}`
## DNSDumpster
### Lookup `tryhackme.com` on DNSDumpster. What is one interesting subdomain that you would discover in addition to `www` and `blog`?
**Answer**: `remote`
## `shodan.io`
### According to `shodan.io`, what is the 2nd country in the world in terms of the number of publicly accessible Apache servers?
* According to [`shodan.io`](https://www.shodan.io/search?query=Apache)

**Answer**: `Germany`
### Based on `shodan.io`, what is the 3rd most common port used for Apache?
* According to [`shodan.io`](https://www.shodan.io/search?query=Apache)

**Answer**: `8080`
### Based on shodan.io`, what is the 3rd most common port used for `nginx`?
* According to [`shodan.io`](https://www.shodan.io/search?query=Apache)

**Answer**: `8888`
