#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

help () {
	echo "Accepted parameters:\n"
	echo "Use -d along with a domain name, example sh SpoofThatMail.sh -d domain.com"
	echo "Null string will be detected and ignored\n"
	echo "Use -f along with a file containing domain names, example sh SpoofThatMail.sh -f domains.txt"
	echo "Note that the path provided for the file must be a valid one\n"
}

check_url () {
	domain=$1

	retval=0
	output=$(nslookup -type=txt _dmarc."$domain")

	if [ -n "$(echo "$output" | egrep "\;[^s]*p[s]*\s*=\s*reject\s*")" ];then
		echo "$domain is ${GREEN}NOT vulnerable${NC}"
	elif [ -n "$(echo "$output" | egrep "\;[^s]*p[s]*\s*=\s*quarantine\s*")" ];then
		echo "$domain ${YELLOW}can be vulnerable${NC} (email will be sent to spam)"
	elif [ -n "$(echo "$output" | egrep "\;[^s]*p[s]*\s*=\s*none\s*")" ];then
		echo "$domain is ${RED}vulnerable${NC}"
		retval=1
	else
		echo "$domain is ${RED}vulnerable${NC} (No DMARC record found)"
		retval=1
	fi
	return $retval
}

check_file () {

		input=$1
		
		COUNTER=0
		VULNERABLES=0
		while IFS= read -r line
		do
			COUNTER=$((COUNTER=COUNTER+1))
			check_url $line
			VULNERABLES=$((VULNERABLES=VULNERABLES+$?))
		done < $input
		echo "\n$VULNERABLES out of $COUNTER domains are ${RED}vulnerable ${NC}"

}

main () {

	while getopts d:f: flag
	do
		case "${flag}" in
			f) file=${OPTARG};;
			d) domain=${OPTARG};;
		esac
	done

	if [ -n "$domain" ]; then
		check_url $domain
	elif [ -f "$file" ]; then
		check_file $file
	else
		help
	fi

}

echo "
███████╗██████╗  ██████╗  ██████╗ ███████╗                          
██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝                          
███████╗██████╔╝██║   ██║██║   ██║█████╗                            
╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝                            
███████║██║     ╚██████╔╝╚██████╔╝██║                               
╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝                               
                                                                    
████████╗██╗  ██╗ █████╗ ████████╗    ███╗   ███╗ █████╗ ██╗██╗     
╚══██╔══╝██║  ██║██╔══██╗╚══██╔══╝    ████╗ ████║██╔══██╗██║██║     
   ██║   ███████║███████║   ██║       ██╔████╔██║███████║██║██║     
   ██║   ██╔══██║██╔══██║   ██║       ██║╚██╔╝██║██╔══██║██║██║     
   ██║   ██║  ██║██║  ██║   ██║       ██║ ╚═╝ ██║██║  ██║██║███████╗
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝ by securihub.com 
                                                                 
"
if [ $# != 2  ];then
	echo "Wrong execution\n"
	help
	exit 0
fi

main $@
