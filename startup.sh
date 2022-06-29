#!/bin/bash
if [ -n "$VSCODE_DRIVEN" ]; then
    echo "Waiting for debugger to connect..."
    # Too small of a wait duration closes the container before the debugger can connect.
    # Too large of a wait duration keeps the container running after the debugger disconnects.
    WAIT_DURATION=10
    bash -c "sleep ${WAIT_DURATION}" # Prevents the container from exiting before VS Code can launch OpenSCAD.
else
    echo "Container start: launching OpenSCAD"
    /openscad/build/openscad --debug=all
fi