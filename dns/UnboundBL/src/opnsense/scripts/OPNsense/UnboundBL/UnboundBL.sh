# !/bin/sh
# UnboundBL, UnboundBL.sh

. /usr/local/opnsense/scripts/OPNsense/UnboundBL/data.sh
touch /tmp/hosts.working
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts.working"
done
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); print tolower($2)}' /tmp/hosts.working | sort | uniq | \
awk '{printf "server:\n", $1; printf "local-data: \"%s A 0.0.0.0\"\n", $1}' > /var/unbound/UnboundBL.conf
rm /tmp/hosts.working
