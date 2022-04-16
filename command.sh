#!/bin/bash

# Make 3 new A record pointing to 1.1.1.1, domain name will be random 20 char (z66iwwue53jwkec8dtqj.example.com)
seq 3 \
| xargs -IX -n1 \
    bash -c 'clear \
        && dns.he new A "$(tr -dc a-z0-9 </dev/urandom | head -c 20)" 1.1.1.1'


# Update domain name that have 20 char long and A record type pointing to new A IP 1.2.3.4
awk '/[0-9a-z]{20}\./{ \
    for (i=1; i<=NF; i++) {printf "%s ",$i} print "1.2.3.4\n" \
    }' parsed-domain-list.txt \
        | xargs -IX -n1 \
            bash -c 'clear \
                && dns.he update X'


# Delete domain that have 20 char long
awk '/[0-9a-z]{20}\./{print $1}' parsed-domain-list.txt \
| xargs -IX -n1 \
    bash -c 'clear \
        && dns.he delete X'


# Check domain resolve that have 20 char long w/ dig
awk '/[0-9a-z]{20}\./{print $NF}' parsed-domain-list.txt \
| xargs -n1 \
    dig +noall +answer \
        | nl -s')  '