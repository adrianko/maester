#! /usr/bin/env python
"""
Squishy

Description:
Compiles LESS files into minified css using 'lessc'
Converts CoffeeScript into JavaScript using 'coffee' and minifies js using 'minify'

Dependencies:
npm - coffee-script, less, minifier
"""
from os import listdir, devnull
from os.path import isfile, join
from re import compile
from subprocess import call, PIPE, STDOUT
from sys import argv
DEVNULL = open(devnull, 'wb')

#specify paths to less and coffee files
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
        if len(argv) > 1 and argv[1] == "debug":
            call(str("mv "+js_path+name+"js "+js_path+name+"min.js").split())
        else:
            call(str("minify "+js_path+name+"js").split(), stdin=PIPE, stdout=DEVNULL, stderr=STDOUT)
            call(str("rm "+js_path+name+"js").split())
