#!/bin/bash

CMDNAME=`basename $0`
TIMESTAMP=`TZ=UTC-9 date "+%Y%m%d%H%M%S"`
HISTORY=""

function usage_exit {
	cat <<EOM
Usage: ${CMDNAME} [OPTION] <ip_address>
Options: 
    -h		Display help.
    -f IP_LIST	Get IP Address list from file instead of STDIN.
    -p		Show the complete history of the host.
EOM

	exit 1
}

if [ $# -lt 1 ]; then
	usage_exit
fi

while getopts hpf: OPT
do
	case $OPT in
		"f" ) LIST=1; IPLIST="$OPTARG"
			;;
		"p" ) HISTORY="--history"
			;;
		"h" ) usage_exit
			;;
		\? ) usage_exit
			;;
	esac
done

shift `expr $OPTIND - 1`

mkdir recon_$TIMESTAMP

if [ $LIST ]; then
	for address in `cat $IPLIST`
	do
		echo "requesting info for ${address}"
		echo "============================"
		shodan host -O recon_$TIMESTAMP/$address $HISTORY $address
		echo "============================"
	done
else
	echo "requesting info for $1"
	echo "============================"
	shodan host -O recon_$TIMESTAMP/$1 $HISTORY $1
	echo "============================"
fi

echo "successfully got shodan results. parsing results..."
echo "============================"
zcat recon_$TIMESTAMP/*.json.gz | sed -e 's/\\u[0-9A-Fa-f]\{4\}//g' | jq -cr '[ .ip_str, .port, .os, (.domains|sort|join("|")), .product, .version, (if .vulns then (.vulns|keys|sort|join("|")) else "None" end), .timestamp ] | @csv' | sed '1s/^/"ip", "port", "os", "domains", "product", "version", "vulns", "timestamp"\n/' | tee recon_$TIMESTAMP/simple_shodan_recon_$TIMESTAMP.csv
