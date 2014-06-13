#! /usr/bin/env python
from os.path import dirname, realpath
from os import remove, system

path = dirname(realpath(__file__))+"/../"
db = "db.sqlite3"

remove(path+db)
system("python "+path+"manage.py syncdb --noinput")
system("sqlite3 "+path+db+" < "+path+"tools/data/dump.sql")