#!/bin/bash
emulator -avd testAVD -wipe-data -noaudio -no-window -gpu off -verbose -qemu -vnc :2 &
/usr/bin/dumb-init gitlab-runner run --user=root --working-directory=/home/gitlab-runner
