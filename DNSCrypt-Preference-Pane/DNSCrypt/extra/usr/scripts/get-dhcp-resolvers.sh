#! /bin/ksh

. ./common.inc

get_primary_service() {
  scutil <<EOF | awk '$1 == "PrimaryService" { print $3 }'
show State:/Network/Global/IPv4
EOF
}

get_ips_bkup() {
  service="$1"
  scutil <<EOF | sed -n -e '/ServerAddresses/,/}/ { /[{}]/n; s/.* : \(.*\)$/\1/ p; }'
get State:/Network/Service/$service/DNS
get State:/Network/Service/$service/DNS.dnscryptbackup
d.show
EOF
}

service="$(get_primary_service)"
ips=( $(get_ips_bkup "$service") )

echo "${ips[*]}"
