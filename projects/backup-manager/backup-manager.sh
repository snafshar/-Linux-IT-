#!/usr/bin/env bash

set -uo pipefail

usage() {
    cat <<EOF
Usage: $0 [OPTIONS] SOURCE_DIRECTORY BACKUP_DIRECTORY

Options:
  -k, --keep N    Keep only the newest N backup archives
  -n, --dry-run   Show what would happen without creating a backup
  -v, --verbose   Show detailed tar output
  -h, --help      Show this help message
EOF
}

error() { printf "Error: %s\n" "$*" >&2; exit 1; }

KEEP=0
DRY_RUN=0
VERBOSE=0
POSITIONAL=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -k|--keep)
            [[ $# -ge 2 ]] || error "--keep requires a number"
            [[ "$2" =~ ^[0-9]+$ ]] || error "--keep must be a non-negative integer"
            KEEP="$2"; shift 2 ;;
        -n|--dry-run) DRY_RUN=1; shift ;;
        -v|--verbose) VERBOSE=1; shift ;;
        -h|--help) usage; exit 0 ;;
        --) shift; while [[ $# -gt 0 ]]; do POSITIONAL+=("$1"); shift; done; break ;;
        -*) error "unknown option: $1" ;;
        *) POSITIONAL+=("$1"); shift ;;
    esac
done

[[ ${#POSITIONAL[@]} -eq 2 ]] || { usage; exit 2; }
SOURCE="${POSITIONAL[0]}"
DESTINATION="${POSITIONAL[1]}"

command -v tar >/dev/null 2>&1 || error "tar is not installed"
command -v find >/dev/null 2>&1 || error "find is not installed"
[[ -d "$SOURCE" ]] || error "source directory does not exist: $SOURCE"
SOURCE_ABS="$(cd "$SOURCE" && pwd -P)" || error "cannot resolve source directory"

if [[ -e "$DESTINATION" ]]; then
    DEST_ABS="$(cd "$DESTINATION" 2>/dev/null && pwd -P)" || error "cannot access backup directory: $DESTINATION"
else
    PARENT="$(dirname "$DESTINATION")"
    mkdir -p "$PARENT" || error "cannot create parent directory: $PARENT"
    DEST_ABS="$(cd "$PARENT" && pwd -P)/$(basename "$DESTINATION")"
fi

case "$DEST_ABS/" in
    "$SOURCE_ABS/"*) error "backup directory cannot be inside the source directory" ;;
esac

mkdir -p "$DEST_ABS" || error "cannot create backup directory: $DEST_ABS"
TIMESTAMP="$(date "+%Y-%m-%d_%H-%M-%S")"
ARCHIVE="$DEST_ABS/backup_${TIMESTAMP}.tar.gz"

if (( DRY_RUN )); then
    printf "Dry run: source      = %s\n" "$SOURCE_ABS"
    printf "Dry run: destination = %s\n" "$DEST_ABS"
    printf "Dry run: archive     = %s\n" "$ARCHIVE"
    (( KEEP > 0 )) && printf "Dry run: retain newest %s archives\n" "$KEEP"
    exit 0
fi

if (( VERBOSE )); then
    tar -cvzf "$ARCHIVE" -C "$(dirname "$SOURCE_ABS")" "$(basename "$SOURCE_ABS")"
else
    tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_ABS")" "$(basename "$SOURCE_ABS")"
fi || { rm -f "$ARCHIVE"; error "backup failed"; }

if command -v du >/dev/null 2>&1; then SIZE="$(du -h "$ARCHIVE" | awk '{print $1}')"; else SIZE="unknown"; fi
printf "Backup created successfully:\n%s\nSize: %s\n" "$ARCHIVE" "$SIZE"

if (( KEEP > 0 )); then
    mapfile -t ARCHIVES < <(find "$DEST_ABS" -maxdepth 1 -type f -name "backup_*.tar.gz" -printf "%T@ %p\n" 2>/dev/null | sort -nr | sed 's/^[^ ]* //')
    if (( ${#ARCHIVES[@]} > KEEP )); then
        for (( i=KEEP; i<${#ARCHIVES[@]}; i++ )); do
            rm -f -- "${ARCHIVES[$i]}" || printf "Warning: could not remove %s\n" "${ARCHIVES[$i]}" >&2
        done
        printf "Retention cleanup: kept newest %s archive(s).\n" "$KEEP"
    fi
fi