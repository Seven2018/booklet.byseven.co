#!/usr/bin/env bash

echo -e '\n127.0.0.1\tdb' | sudo tee -a /etc/hosts
echo -e '127.0.0.1\tredis' | sudo tee -a /etc/hosts
