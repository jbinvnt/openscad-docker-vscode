#!/bin/bash
if [ -n "$VSCODE_DRIVEN" ]; then
    echo "Displaying logged messages from gdb..."
    touch /openscad/output.log
    xterm -e "tail -f /openscad/output.log"
    #sleep infinity # Prevents the container from stopping, but this is not necessary if tail -f is running.
else
    echo "Container start: launching OpenSCAD"
    /openscad/build/openscad --debug=all
fi