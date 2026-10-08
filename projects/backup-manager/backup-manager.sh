#!/usr/bin/env bash

set -uo pipefail

KEEP=0; DRY=0; VERBOSE=0; CHECKSUM=1; POSITIONAL=()

usage(){ cat <<EOF
Usage: $0 [OPTIONS] SOURCE BACKUP_DIR
  -k, --keep N       Keep newest N archives
  -n, --dry-run      Preview without creating a backup
  -v, --verbose      Show files while archiving
  --no-checksum      Do not create SHA-256 checksum
  -h, --help         Show help
EOF
}
fail(){ printf "Error: %s\n" "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do case "$1" in
 -k|--keep) [[ $# -gt 1 && "$2" =~ ^[0-9]+$ ]] || fail "invalid --keep value"; KEEP="$2"; shift 2;;
 -n|--dry-run) DRY=1; shift;; -v|--verbose) VERBOSE=1; shift;;
 --no-checksum) CHECKSUM=0; shift;; -h|--help) usage; exit 0;;
 --) shift; while (($#)); do POSITIONAL+=("$1"); shift; done; break;;
 -*) fail "unknown option: $1";; *) POSITIONAL+=("$1"); shift;; esac; done
[[ ${#POSITIONAL[@]} -eq 2 ]] || { usage; exit 2; }
SOURCE="${POSITIONAL[0]}"; DEST="${POSITIONAL[1]}"
command -v tar >/dev/null 2>&1 || fail "tar is required"; [[ -d "$SOURCE" ]] || fail "source does not exist: $SOURCE"
SRC="$(cd "$SOURCE" && pwd -P)" || fail "cannot resolve source"
if [[ -e "$DEST" ]]; then OUT="$(cd "$DEST" && pwd -P)" || fail "cannot access destination"; else P="$(dirname "$DEST")"; mkdir -p "$P" || fail "cannot create parent"; OUT="$(cd "$P" && pwd -P)/$(basename "$DEST")"; fi
case "$OUT/" in "$SRC/"*) fail "destination cannot be inside source";; esac
mkdir -p "$OUT" || fail "cannot create destination"
STAMP="$(date "+%Y-%m-%d_%H-%M-%S")"; ARCHIVE="$OUT/backup_${STAMP}.tar.gz"; SHA="$ARCHIVE.sha256"; MANIFEST="$ARCHIVE.manifest.txt"
if (( DRY )); then printf "Source: %s\nDestination: %s\nArchive: %s\n" "$SRC" "$OUT" "$ARCHIVE"; ((KEEP)) && printf "Retention: newest %s\n" "$KEEP"; exit 0; fi
printf "Creating backup: %s\n" "$ARCHIVE"
if (( VERBOSE )); then tar -cvzf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"; else tar -czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"; fi || { rm -f "$ARCHIVE"; fail "tar failed"; }
printf "Source: %s\nCreated: %s\nArchive: %s\n" "$SRC" "$(date)" "$ARCHIVE" > "$MANIFEST"
if (( CHECKSUM )); then if command -v sha256sum >/dev/null 2>&1; then sha256sum "$ARCHIVE" > "$SHA"; elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$ARCHIVE" > "$SHA"; else CHECKSUM=0; fi; fi
SIZE="$(du -h "$ARCHIVE" | awk '{print $1}' 2>/dev/null || printf unknown)"
printf "Backup created successfully.\nArchive: %s\nSize: %s\n" "$ARCHIVE" "$SIZE"
(( CHECKSUM )) && printf "Checksum: %s\n" "$SHA"
if (( KEEP > 0 )); then
 mapfile -t A < <(find "$OUT" -maxdepth 1 -type f -name "backup_*.tar.gz" -printf "%T@ %p\n" 2>/dev/null | sort -nr | sed 's/^[^ ]* //')
 for ((i=KEEP;i<${#A[@]};i++)); do rm -f -- "${A[$i]}" "${A[$i]}.sha256" "${A[$i]}.manifest.txt"; done
 printf "Retention: kept newest %s archive(s).\n" "$KEEP"
fi