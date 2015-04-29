#! /bin/bash
function test2() {
    echo '$1'
    echo "$1"
    echo $(cat docker.sh | awk 'NR<2 { print $1 }')
}

echo $(test2)
echo $(test2 2)
