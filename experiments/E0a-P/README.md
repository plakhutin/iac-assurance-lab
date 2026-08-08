# E0a-P experiment artifacts

Этот каталог предназначен для фактических task packages, manifests, raw runs и annotations E0a-P.

Canonical procedure находится в:

- [`../../docs/experiments/E0a-P-planner-pilot.md`](../../docs/experiments/E0a-P-planner-pilot.md);
- [`../../docs/experiments/E0a-P/README.md`](../../docs/experiments/E0a-P/README.md).

## Current contents

```text
tasks/DRY-00/
```

`DRY-00` — controlled synthetic package для проверки task envelope, prompt arms, annotation manual, scorer workflow и prompt-injection boundary. Он не входит в pilot outcomes и не может использоваться как confirmatory task.

## Data policy

- Raw/private artifacts не добавляются в public Git без access/licensing review.
- Secrets, PII и production credentials запрещены.
- Model requests/responses должны иметь immutable digests и manifests.
- Task/gold/run artifacts не переписываются после freeze; correction создаёт новую version.
- Фактических model outputs и invented results в этом каталоге пока нет.
