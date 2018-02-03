#! /bin/sh

. ./common.inc

get_primary_service() {
  scutil <<EOF | awk '$1 == "PrimaryService" { print $3 }'
show State:/Network/Global/IPv4
EOF
}

servers='empty'

logger_debug "Changing the DNS configuration to use the default DNS resolvers"

service="$(get_primary_service)"
scutil <<EOF
get State:/Network/Service/$service/DNS
get State:/Network/Service/$service/DNS.dnscryptbackup
set State:/Network/Service/$service/DNS
remove State:/Network/Service/$service/DNS.dnscryptbackup
EOF

logger_debug "Flushing the local DNS cache"

dscacheutil -flushcache 2> /dev/null
killall -HUP mDNSResponder 2> /dev/null
exit 0
