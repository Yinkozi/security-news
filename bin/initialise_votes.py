#!usr/bin/python
# Filename: doesnt_work

import os
import hashlib

with open("links.txt","r") as f:
    for line in f.readlines():
        line = line.rstrip("\n")

        m = hashlib.sha256(line)
        print(m.hexdigest())