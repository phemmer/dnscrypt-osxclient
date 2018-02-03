#! /bin/sh

. ./common.inc

get_primary_service() {
  scutil <<EOF | awk '$1 == "PrimaryService" { print $3 }'
show State:/Network/Global/IPv4
EOF
}

set_ips_active() {
  service="$1"
  shift
  ips="$@"
  scutil <<EOF
get State:/Network/Service/$service/DNS
get State:/Network/Service/$service/DNS.dnscryptbackup
set State:/Network/Service/$service/DNS.dnscryptbackup
d.add ServerAddresses * ${ips[*]}
set State:/Network/Service/$service/DNS
EOF
}

servers="$@"

[ $# -lt 1 ] && exit 1

logger_debug "Setting DNS resolvers to [$servers]"

service="$(get_primary_service)"
set_ips_active "$service" "${servers[@]}"

logger_debug "Flushing local DNS cache"

dscacheutil -flushcache 2> /dev/null
killall -HUP mDNSResponder 2> /dev/null
exit 0
