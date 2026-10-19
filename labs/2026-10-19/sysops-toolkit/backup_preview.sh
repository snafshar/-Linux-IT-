#!/usr/bin/env bash
set -u
if [[ $# -ne 2 ]]; then
  printf 'Usage: %s SOURCE DESTINATION\n' "$0" >&2
  exit 2
fi
source_path=$1
destination_path=$2
if [[ ! -e "$source_path" ]]; then
  printf 'Error: source does not exist: %s\n' "$source_path" >&2
  exit 1
fi
printf 'Dry run only; no files will be copied.\n'
printf 'Source:      %s\n' "$source_path"
printf 'Destination: %s\n' "$destination_path"
printf 'Suggested command: cp -a -- %q %q\n' "$source_path" "$destination_path"
