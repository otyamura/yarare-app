#!/bin/bash

users=(manage shimamura huji kato tanaka nakamura kuroki yoshida sasaki seo)

for user in ${users[@]}
do
  useradd -m $user
  echo "$user:$user" | chpasswd
  echo "$user ALL=(ALL) ALL" >> /etc/sudoers
  chmod 711 /home/$user/
done
