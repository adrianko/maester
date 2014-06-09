#! /usr/bin/env python
from os import listdir, devnull
from os.path import isfile, join
from re import compile
from subprocess import call, PIPE, STDOUT
DEVNULL = open(devnull, 'wb')

css_path = "static/css/"
js_path = "static/js/"

pattern = compile(".less$")
for f in listdir(css_path):
    if isfile(join(css_path, f)) and pattern.search(f):
        call(str("lessc -x "+css_path+f+" "+css_path+f[:-4]+"min.css").split())

pattern = compile(".js$")
mpattern = compile(".min.js$")
cpattern = compile(".coffee$")
for f in listdir(js_path):
    if isfile(join(js_path, f)) and cpattern.search(f):
        call(str("coffee -c "+js_path+f).split())
        name = f[:-6]
        call(str("minify "+js_path+name+"js").split(), stdin=PIPE, stdout=DEVNULL, stderr=STDOUT)
        call(str("rm "+js_path+name+"js").split())
