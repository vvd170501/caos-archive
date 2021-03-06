#!/bin/bash

lastcnt=3

if [[ "$1" == "last" ]]; then
    contests=$(kks top -l $lastcnt | head -n 1 | python -c "print(' '.join([e.strip() for e in input().split('|')[-$lastcnt:]]))")
    # may sync extra contests if names contain spaces (rewrite?)
    kks sync -f $contests
else
    kks sync -f
fi

function copy () {
    grep -Fqv "Statement is not available" "$1" && cp "$1" "$2"  # don't overwrite old statements if they are deleted
    test -f "$2" || cp $1 $2  # if statement is not available, but there aren't any old versions
}

export -f copy

find -name statement.md | sed -E 's:[^/]*/([^/]+)/([^/]+).*:\0 ./statements/\1-\2.md:' | xargs -n2 bash -c 'copy "${0}" "${1}"'
find -name statement.html | sed -E 's:[^/]*/([^/]+)/([^/]+).*:\0 ./statements/html/\1-\2.html:' | xargs -n2 bash -c 'copy "${0}" "${1}"'
sed -E -i 's:SID=[a-z0-9]+:SID=00000000:g' statements/*.md statements/html/*.html
sed -E -i 's:\*\*\[hidden text\]\*\*.*:<details>\n<summary>hidden text</summary>\n:' statements/*.md
sed -E -i 's:\*\*\[end of hidden text\]\*\*.*:</details>:' statements/*.md
git add statements && git commit -m "Update to $(date "+%d.%m.%y %R")"
