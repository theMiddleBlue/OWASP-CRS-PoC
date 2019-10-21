#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function usage {
    echo "usage: $0 [[-f fork url] [-b branch-name] | [-h]]"
}

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

while [ "$1" != "" ]; do
	case $1 in
		-f | --fork )
			shift
			fork=$1
		;;
		-b | --branch )
			shift
			branch=$1
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
	until $(curl --output /dev/null --silent --head --fail http://localhost:8001); do
		printf '.'
		sleep 2
	done

	echo -e "\n[*] CRS Ready."
}

touch "${DIR}/logs/modsec_debug.log"
touch "${DIR}/logs/modsec_audit.log"
chmod 777 ${DIR}/logs/modsec_*.log
chmod 777 ${DIR}/logs/audit

echo "[*] Build and run all containers"
docker-compose up -d

wait_crs

echo "[*] Pull all changes from OWASP CRS remote repository"
docker exec -ti modsec-crs rm -rf /etc/apache2/modsecurity.d/owasp-crs
docker exec -ti modsec-crs git clone $fork /etc/apache2/modsecurity.d/owasp-crs
docker cp conf/crs-setup.conf modsec-crs:/etc/apache2/modsecurity.d/owasp-crs/
docker exec -ti modsec-crs git -C /etc/apache2/modsecurity.d/owasp-crs/ checkout $branch

#docker exec -ti modsec-crs git -C /etc/apache2/modsecurity.d/owasp-crs/ pull
#echo "[*] Checkout Pull Request ${pullid}"
#docker exec -ti modsec-crs git -C /etc/apache2/modsecurity.d/owasp-crs/ fetch origin pull/${pullid}/head:owasp-crs-poc-temp-branch
#docker exec -ti modsec-crs git -C /etc/apache2/modsecurity.d/owasp-crs/ checkout owasp-crs-poc-temp-branch

echo "[*] Restarting CRS container"
docker restart modsec-crs

wait_crs

echo -e "\n[*] Done."
