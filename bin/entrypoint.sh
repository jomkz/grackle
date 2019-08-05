#!/bin/sh -e

# This is documented here:
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines

if ! whoami &>/dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-grackle}:x:$(id -u):$(id -g):${USER_NAME:-grackle} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

exec $@