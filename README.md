# SpoofThatMail
Bash script to check if a domain or list of domains can be spoofed based in DMARC records


File with domains:
```
sh SpoofThatMail.sh -f domains.txt
```
One single domain:
```
sh SpoofThatMail.sh -d domain
```
![image](https://user-images.githubusercontent.com/23397910/149307857-43cc2593-47eb-4b7a-af32-c61d10b5e702.png)

The script may not work if sp param is before p param (currently working on this)

Test manually using nslookup -type=txt _dmarc.domain.com
