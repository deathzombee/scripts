#!/bin/bash

# Set this environment variable to point to the external mlocate.db file
# Example: export MLOCATE_DB_PATH=/some/path/mlocate.db
plocate -d "$MLOCATE_DB_PATH" "$@"
