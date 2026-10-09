#!/usr/bin/env bash
set -euo pipefail
KEEP=0; DRY=0; VERBOSE=0; CHECKSUM=1; POSITIONAL=()
usage(){ echo "Usage: backup-manager.sh [OPTIONS] SOURCE BACKUP_DIR"; }
fail(){ printf 'Error: %s\n' "$*" >&2; exit 1; }
while [[ $# -gt 0 ]]; do
 case "$1" in
  -k|--keep) [[ $# -gt 1 && "$2" =~ ^[0-9]+$ ]] || fail "invalid --keep"; KEEP="$2"; shift 2;;
  -n|--dry-run) DRY=1; shift;;
  -v|--verbose) VERBOSE=1; shift;;
  --no-checksum) CHECKSUM=0; shift;;
  -h|--help) usage; exit 0;;
  --) shift; while (($#)); do POSITIONAL+=("$1"); shift; done; break;;
  -*) fail "unknown option: $1";; *) POSITIONAL+=("$1"); shift;;
 esac
done
[[ ${#POSITIONAL[@]} -eq 2 ]] || { usage >&2; exit 2; }
SOURCE="${POSITIONAL[0]}"; DEST="${POSITIONAL[1]}"
command -v tar >/dev/null || fail "tar is required"; [[ -d "$SOURCE" ]] || fail "source does not exist"
SRC="$(cd "$SOURCE" && pwd -P)"; mkdir -p "$DEST"; OUT="$(cd "$DEST" && pwd -P)"
[[ "$OUT/" != "$SRC/"* ]] || fail "destination cannot be inside source"
STAMP="$(date '+%Y-%m-%d_%H-%M-%S')"; ARCHIVE="$OUT/backup_${STAMP}.tar.gz"
SHA="$ARCHIVE.sha256"; MANIFEST="$ARCHIVE.manifest.txt"
if (( DRY )); then printf 'Source: %s\nDestination: %s\nArchive: %s\n' "$SRC" "$OUT" "$ARCHIVE"; exit 0; fi
tar_args=(-czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")")
(( VERBOSE )) && tar_args=(-cvzf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")")
tar "${tar_args[@]}" || { rm -f "$ARCHIVE"; fail "tar failed"; }
printf 'Source: %s\nCreated: %s\nArchive: %s\n' "$SRC" "$(date)" "$ARCHIVE" > "$MANIFEST"
if (( CHECKSUM )); then
 if command -v sha256sum >/dev/null; then sha256sum "$ARCHIVE" > "$SHA"
 elif command -v shasum >/dev/null; then shasum -a 256 "$ARCHIVE" > "$SHA"
 else CHECKSUM=0; fi
fi
printf 'Backup created successfully.\nArchive: %s\nSize: %s\n' "$ARCHIVE" "$(du -h "$ARCHIVE" | awk '{print $1}')"
(( CHECKSUM )) && printf 'Checksum: %s\n' "$SHA"
if (( KEEP > 0 )); then
 mapfile -t archives < <(find "$OUT" -maxdepth 1 -type f -name 'backup_*.tar.gz' -printf '%T@ %p\n' | sort -nr | sed 's/^[^ ]* //')
 for ((i=KEEP; i<${#archives[@]}; i++)); do rm -f -- "${archives[$i]}" "${archives[$i]}.sha256" "${archives[$i]}.manifest.txt"; done
 printf 'Retention: kept newest %d archive(s).\n' "$KEEP"
fi