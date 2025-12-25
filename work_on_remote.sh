#!/bin/bash
# Helper script to work on the remote PC via SSH
# Usage: ./work_on_remote.sh [command]

REMOTE_HOST="maache@192.168.1.24"
REMOTE_PASS="1234"
REMOTE_WORKSPACE="~/55_flutterapps"

# Function to run command on remote
run_remote() {
    sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no "$REMOTE_HOST" "export PATH=\"\$PATH:\$HOME/flutter/bin\" && cd $REMOTE_WORKSPACE && $1"
}

# If command provided, run it
if [ $# -gt 0 ]; then
    run_remote "$*"
else
    # Interactive mode
    echo "══════════════════════════════════════════════════════════════"
    echo "   🖥️  Remote PC Workspace Helper"
    echo "══════════════════════════════════════════════════════════════"
    echo ""
    echo "Remote PC: $REMOTE_HOST"
    echo "Workspace: $REMOTE_WORKSPACE"
    echo ""
    echo "Available commands:"
    echo "  ./work_on_remote.sh 'ls -la'                    - List files"
    echo "  ./work_on_remote.sh 'flutter --version'          - Check Flutter"
    echo "  ./work_on_remote.sh 'cd 01_giggle_game/... && flutter build appbundle'"
    echo ""
    echo "Or connect interactively:"
    echo "  sshpass -p '$REMOTE_PASS' ssh $REMOTE_HOST"
    echo ""
fi

