#!/bin/bash
cd $(dirname $0)
./bucket/remove.sh
./cache/remove.sh
./database/remove.sh