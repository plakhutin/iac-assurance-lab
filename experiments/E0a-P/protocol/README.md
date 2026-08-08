# E0a-P prompt protocol artifacts

Exact prompt components for the E0a-P dry run.

## Assembly

```text
common-system.txt
+ P0.txt | P1.txt | P2.txt
+ common-output-contract.txt
+ task-package.txt
```

Use:

```bash
bash assemble-prompt.sh \
  P0 \
  ../tasks/DRY-00/task-package.txt \
  /tmp/DRY-00-P0-prompt.txt
```

The script:

1. runs `sha256sum --check SHA256SUMS`;
2. rejects unknown protocol IDs;
3. verifies that the task package exists;
4. concatenates exact bytes without editing source files;
5. prints output byte count and SHA-256.

It does not call a model.

## Files

- [`prompt-manifest.yaml`](prompt-manifest.yaml) — IDs, candidate hashes and treatment-integrity contract.
- [`SHA256SUMS`](SHA256SUMS) — standard component checksum file.
- [`assemble-prompt.sh`](assemble-prompt.sh) — deterministic assembler.
- [`prompts/common-system.txt`](prompts/common-system.txt) — shared authority/tool boundary.
- [`prompts/common-output-contract.txt`](prompts/common-output-contract.txt) — shared structure and output budget.
- [`prompts/P0.txt`](prompts/P0.txt) — plain rigorous planning.
- [`prompts/P1.txt`](prompts/P1.txt) — invariant-first treatment.
- [`prompts/P2.txt`](prompts/P2.txt) — invariant/counterexample-first treatment.

## Current integrity status

The exact intended contents passed syntax/checksum/assembly tests in a temporary local fixture. A checkout of the committed branch has not yet been used for hash reproduction because the working container could not resolve `github.com`.

Do not set `digest_verified_after_commit: true` until checks pass against a checkout or independently downloaded committed blobs.

## Change control

Before dry-run freeze, substantive text changes are allowed with version/digest updates. After freeze:

- prompt text is immutable for all six pilot tasks;
- no arm-specific domain hints;
- no output-budget difference;
- no quality-based retries or best-of-N;
- all prompt and task package digests are recorded per run.
