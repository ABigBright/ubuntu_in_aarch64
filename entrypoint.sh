#!/bin/bash

USER=studio
user_id=${USER_ID:-1000}
group_id=${GROUP_ID:-1000}

if [ $user_id -eq `id -u` ]; then
    exec "$@"
else
    useradd --shell /bin/bash -u $user_id -g $group_id $USER
    exec gosu $USER "$@"
fi
