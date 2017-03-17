#!/bin/bash
scrot ~/tmp/screenshot.png
#convert ~/tmp/screenshot.png -blur 0x10 /tmp/screenshot.png
#convert ~/tmp/screenshot.png -blur 0x20 /tmp/screenshot.png
convert ~/tmp/screenshot.png -scale 5% -scale 2000% /tmp/screenshot.png
#convert ~/tmp/screenshot.png -scale 25% -blur 0x08 -scale 400% /tmp/screenshot.png
#rm ~/tmp/screenshot.png
i3lock -i /tmp/screenshot.png
