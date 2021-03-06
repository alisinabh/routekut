#!/bin/bash -e

ARGUMENT_LIST=(
    "country:"
    "gateway:"
    "help"
)


# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --$opts

while [[ $# -gt 0 ]]; do
    case "$1" in
        --country)
            countryiso=$2
            shift 2
            ;;

        --gateway)
            gateway=$2
            shift 2
            ;;

	--help)
	  echo "This script helps you to add routes for a specific country."
	  echo ""
	  echo "In order to run interactiveley just call this script without the --help switch."
	  echo "This command requires superuser privilages! (MUST run as root)"
	  echo ""
	  echo "Arguments:"
	  echo -e "\t--country\tCountry of your choice as 2-letter ISO code. Example: US, IR"
	  echo -e "\t--gateway\tGateway used to route to these ip addresses. Example: 192.168.0.1 OR vpn0"
	  echo -e "\t--help\t\tShows this help."
	  exit
	  ;;

        *)
            break
            ;;
    esac
done


if [ -z ${countryiso+x} ];
then
	read -p 'Country ISO code (example US): ' countryiso
else
	echo "Country: $countryiso"
fi


if [ -z ${gateway+x} ];
then
	read -p "Enter the gateway that you want to use for $countryiso (example 192.168.0.1 OR vpn0): " gateway
else
	echo "Gateway: $gateway"
fi

countryiso=$(echo "$countryiso" | tr '[:upper:]' '[:lower:]')

input="db/country/$countryiso/ipv4.cidr"

while IFS= read -r line
do
		echo "ip route add dst-address=$line gateway=$gateway">>mikrotik_script.txt
		echo "ip route remove [find dst-address=$line gateway=$gateway]">>mikrotik_restore_script.txt
done < "$input"


