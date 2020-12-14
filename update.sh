#!/bin/bash

kks sync -f
find -name statement.md | sed -E 's:[^/]*/([^/]+)/([^/]+).*:\0 ./statements/\1-\2.md:' | xargs -n2 cp
find -name statement.html | sed -E 's:[^/]*/([^/]+)/([^/]+).*:\0 ./statements/html/\1-\2.html:' | xargs -n2 cp
sed -E -i 's:\[/?code\]::g' statements/*.md
sed -E -i 's:SID=[a-z0-9]+:SID=00000000:g' statements/*.md statements/html/*.html
git add statements && git commit -m "Update to $(date "+%d.%m.%y %R")"
