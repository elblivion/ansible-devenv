#!/usr/bin/env bash

set -eo pipefail

site="$1"; shift
if [ $# -gt 0 ]; then
    email_file="$1"; shift
else
    email_file="$site"
fi

SESSION_VAR=OP_SESSION_contentful
ONEPASS_ACCOUNT=contentful
ONEPASS_SESSION="${!SESSION_VAR}"

# Either:
#  a. The user has no OP_SESSION_contentful variable (for example), and
#     will therefore need to sign in, or,
#  b. The user has a session variable, but the session has expired, which
#     we can detect by looking for an error on `op get account`
#
# Either way, we need to sign the user in.
if [ -z "${ONEPASS_SESSION}" ] || ! op get account --session="${ONEPASS_SESSION}" >/dev/null 2>&1 ; then
  echo "You appear to be signed out of 1Password, signing in..."
  ONEPASS_SESSION=$( op signin "${ONEPASS_ACCOUNT}" --output=raw )
  if [ -z "${ONEPASS_SESSION}" ]; then
    echo "Unable to sign in to 1password!"
    exit 1
  fi
fi

export OP_SESSION_contentful="$ONEPASS_SESSION"

ansible-playbook -i inventory --limit="$site" --ask-become-pass -v "site.yml" "$@"
