#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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


while getopts vd:f: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
		d) domain=${OPTARG};;
    esac
done

if [ -z "$domain" ] 
then
	if [ -z "$file" ] 
	then
		echo "Missing params"
	else
		COUNTER=0
		VULNERABLES=0
		input=$file
		while IFS= read -r line
		do

		  COUNTER=$((COUNTER=COUNTER+1))
		  output=$(nslookup -type=txt _dmarc."$line")
		  case "$output" in
			  *p=reject*)
			    echo "$line is ${GREEN}NOT vulnerable${NC}"
			  ;;
			  *p=quarantine*)
			    echo "$line ${YELLOW}can be vulnerable${NC} (email will be sent to spam)"
			  ;;
			  *p=none*)
			    echo "$line is ${RED}vulnerable${NC}"
			    VULNERABLES=$((VULNERABLES=VULNERABLES+1))
			  ;;
			  *)
			    echo "$line is ${RED}vulnerable${NC} (No DMARC record found)"
			    VULNERABLES=$((VULNERABLES=VULNERABLES+1))
			  ;;
			esac
		done < $file
		echo "\n$VULNERABLES out of $COUNTER domains are ${RED}vulnerable ${NC}"
	fi
else
	output=$(nslookup -type=txt _dmarc."$domain")
	case "$output" in
			  *p=reject*)
			    echo "$domain is ${GREEN}NOT vulnerable${NC}"
			  ;;
			  *p=quarantine*)
			    echo "$domain ${YELLOW}can be vulnerable${NC} (email will be sent to spam)"
			  ;;
			  *p=none*)
			    echo "$domain is ${RED}vulnerable${NC}"
			  ;;
			  *)
			    echo "$domain is ${RED}vulnerable${NC} (No DMARC record found)"
			  ;;
			esac
fi

