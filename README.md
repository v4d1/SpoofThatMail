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
![image](https://user-images.githubusercontent.com/23397910/149308305-67364f17-9c17-45e5-a023-3ce53bce22ba.png)

The script may not work if sp param is before p param (currently working on this)

Test manually using nslookup -type=txt _dmarc.domain.com
vsvsd

vds
vdsv

vdsv
svdsvs
