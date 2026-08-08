# 2026-08-08 — E0a-P protocol and DRY-00 materialization

## Objective

Перевести E0a-P из концептуального draft в процедуру, пригодную для dry run, и начать фактическую materialization experiment artifacts.

## Completed

### Protocol design

- определены task inclusion/exclusion criteria и coverage constraints;
- создан provisional six-task pilot slate;
- зафиксирован independent expert gold workflow;
- определены authority, severity, claim level и property classes;
- введены strict/lenient output coverage и harmful-output labels;
- записаны exact `P0/P1/P2` instructions и common output contract;
- задан 72-run working design;
- определены randomization, retries, blinding, double scoring и adjudication;
- создан canonical YAML data contract для task/candidate/gold/run/score records.

### Experiment artifacts

- создан root artifact catalog `experiments/E0a-P/`;
- материализован controlled synthetic `DRY-00` task package;
- authoritative context отделён от untrusted repository content;
- добавлена controlled prompt-injection fixture;
- вычислен candidate SHA-256 task-package digest;
- exact prompt components вынесены в отдельные files;
- добавлены `SHA256SUMS`, prompt manifest и deterministic assembler script.

### Project memory

- обновлены root/documentation/experiment indexes;
- `docs/current-focus.md` переведён на phase `DRY-00 preflight`;
- parent E0a-P document переведён в `executable-protocol draft`.

## Verification performed

- fetched созданный `DRY-00/task-package.txt` обратно через GitHub connector и визуально сверил структуру/содержимое;
- SHA-256 для исходного exact UTF-8 content и prompt components вычислен до записи;
- branch writes выполнялись только в `bootstrap/project-memory`;
- модельные runs и expert annotations не выполнялись;
- никакие synthetic results не создавались.

## Verification not completed

Попытка клонировать ветку и выполнить `sha256sum --check`/assembler из local container завершилась ошибкой DNS resolution для `github.com`. Поэтому:

- `digest_verified_after_commit` остаётся `false`;
- успешный end-to-end запуск assembler не заявляется;
- фактическая проверка после checkout остаётся первым следующим шагом.

## Decisions preserved

- `DRY-00` не входит в pilot outcomes и не переиспользуется как confirmatory task;
- gold создаётся до model outputs;
- protocol arms различаются только planning instruction;
- no best-of-N и no quality-based retries;
- один primary model используется для core calibration pilot;
- полноценный Semantic Verification Engine остаётся deferred.

## Remaining blockers

- три независимых domain experts;
- neutral normalizer/adjudication arrangement;
- два output scorers;
- primary model и reproducible execution access;
- private/raw artifact storage policy;
- local checkout verification of recorded digests.

## Next action

Проверить hashes/assembler после checkout, затем провести independent expert elicitation по `DRY-00` без model outputs.
