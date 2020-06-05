#!/usr//bin/env bash

# Colorize
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)

if [[ -f vpsin.txt ]]
    then

    if [[ -f macbase.txt ]]; then stat --format='%n last updated on %y' macbase.txt; fi

    grep -E 'ds|colo' vpsin.txt | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | uniq > iplist.txt

    printf '%s\n' "  IP present:${BRIGHT} $(wc -l < iplist.txt) ${NORMAL}"

    IPLIST=$(< iplist.txt)

    : > macbase.txt

    for ip in $IPLIST 
	    do
#        echo -ne "HW addr collected: ${BRIGHT}$(wc -l < macbase.txt)${NORMAL}. Processing IP: ${BRIGHT}$ip${NORMAL} \r"
        printf '%s\r' "  HW addr collected: ${BRIGHT}$(wc -l < macbase.txt)${NORMAL}. Processing IP: ${BRIGHT}$ip${NORMAL}   "
        arping -r -R -i eth0 -w 0.1 -c 1 $ip | tr '[:lower:]' '[:upper:]' >> macbase.txt
    done
        printf '%s\n' " " "${GREEN}✔${NORMAL} Processing IP: Done" "- - - - - - - - - - - - - -"
        printf '%s\n' " " "${GREEN}✔ Task completed successfully${NORMAL}" \
        "  ${BRIGHT}macbase.txt${NORMAL} has $(wc -l < macbase.txt) records" "${GREEN}▶${NORMAL} Grep ${BRIGHT}macbase.txt${NORMAL} for results"
    else
        printf '%s\n' "${GREEN}▶${NORMAL} Lack of important file vpsin.txt"
fi
