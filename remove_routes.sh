#!/bin/bash -e

ARGUMENT_LIST=(
    "country:"
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
	  echo "This script helps you to remove routes for a specific country."
	  echo ""
	  echo "In order to run interactiveley just call this script without the --help switch."
	  echo "This command requires superuser privilages! (MUST run as root)"
	  echo ""
	  echo "Arguments:"
	  echo -e "\t--country\tCountry of your choice as 2-letter ISO code. Example: US, IR"
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


countryiso=$(echo "$countryiso" | tr '[:upper:]' '[:lower:]')

input="db/country/$countryiso/ipv4.cidr"

while IFS= read -r line
do
	ip route del "$line"
done < "$input"


