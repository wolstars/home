#!/usr/bin/env bash

P4=$(df | grep /dev/nvme0n1p4 | tr -s " " | cut -d " " -f 5)
P5=$(df | grep /dev/nvme0n1p5 | tr -s " " | cut -d " " -f 5)


[ -z "$P5" ] && echo "$P4    ❌" && echo "$P4    ❌" && ([[ "$P4" > 80 ]] && echo "#e67e80" || echo "#a7c080") && exit 0

[[ "$P4" > 80 ]] || [[ "$P5" > 80 ]] && echo "$P4 ❌ $P5" && echo "$P4 ❌ $P5" && echo "#e67e80" && exit 0


echo "$P4   $P5" && echo "$P4    $P5"
echo "#a7c080"

exit 0
