#!/bin/bash
#i3-msg "workspace 1; workspace 99; append_layout ~/.i3/output-basic-1.json"
i3-msg "workspace 1; exec firefox"
i3-msg "workspace 3; exec sleep 4 && thunderbird"
i3-msg "workspace 1"
