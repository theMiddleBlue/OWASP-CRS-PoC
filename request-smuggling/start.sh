#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function usage {
    echo "usage: $0 [[[-p pull_id ]] | [-h]]"
}

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

while [ "$1" != "" ]; do
	case $1 in
		-p | --pullid )
			shift
			pullid=$1
		;;
		-h | --help )
			usage
			exit
		;;
		* )
			usage
			exit 1
	esac
	shift
done

function wait_crs {
	echo "Waiting for crs..."
	until $(curl --output /dev/null --silent --head --fail http://localhost:3000); do
		printf '.'
		sleep 2
	done

	echo -e "\n[*] CRS Ready."
}

touch "${DIR}/logs/audit/debug.log"
chmod 777 ${DIR}/logs/audit

echo "[*] Build and run all containers"
docker-compose up -d

wait_crs

echo "[*] Pull all changes from OWASP CRS remote repository"
docker exec -ti nginx-modsec-crs git -C /opt/owasp-modsecurity-crs/ pull

echo "[*] Checkout Pull Request ${pullid}"
docker exec -ti nginx-modsec-crs git -C /opt/owasp-modsecurity-crs/ fetch origin pull/${pullid}/head:owasp-crs-poc-temp-branch
docker exec -ti nginx-modsec-crs git -C /opt/owasp-modsecurity-crs/ checkout owasp-crs-poc-temp-branch

echo "[*] Restarting CRS container"
docker restart nginx-modsec-crs

wait_crs

docker exec -ti nginx-modsec-crs chmod 777 /usr/local/nginx/logs/modsecurity

echo -e "\n[*] Done."
