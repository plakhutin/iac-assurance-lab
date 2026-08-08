#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash assemble-prompt.sh <P0|P1|P2> <task-package.txt> <output.txt>

The script verifies frozen candidate prompt component hashes, then concatenates:
  common system -> arm instruction -> common output contract -> task package

It does not call a model or modify the task package.
EOF
}

if [[ $# -ne 3 ]]; then
  usage >&2
  exit 2
fi

protocol="$1"
task_package="$2"
output="$3"

case "$protocol" in
  P0|P1|P2) ;;
  *)
    echo "Unsupported protocol: $protocol" >&2
    usage >&2
    exit 2
    ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$task_package" ]]; then
  echo "Task package does not exist: $task_package" >&2
  exit 1
fi

(
  cd "$script_dir"
  sha256sum --check SHA256SUMS
)

mkdir -p -- "$(dirname -- "$output")"

cat \
  "$script_dir/prompts/common-system.txt" \
  "$script_dir/prompts/${protocol}.txt" \
  "$script_dir/prompts/common-output-contract.txt" \
  "$task_package" \
  > "$output"

printf 'assembled_prompt=%s\n' "$output"
printf 'protocol=%s\n' "$protocol"
printf 'bytes=%s\n' "$(wc -c < "$output" | tr -d ' ')"
printf 'sha256=%s\n' "$(sha256sum "$output" | awk '{print $1}')"
