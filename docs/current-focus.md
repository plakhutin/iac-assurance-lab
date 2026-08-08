# Current focus

**Updated:** 2026-08-08  
**Status:** active  
**Phase:** E0a-P executable protocol → DRY-00 preflight

## Current objective

Провести `DRY-00` для калибровки процедуры E0a-P до запуска шести pilot tasks.

Исследовательские направления остаются независимыми:

1. `E0a-P` — оценить baseline, variance и пригодность annotation process для plain, invariant-first и counterexample-first LLM planning;
2. `E0a-A` — оценить structural analyzability реальных legacy Ansible-ролей и obligation-relative opaque cones без построения verifier.

Текущий активный фокус — `E0a-P`. `E0a-A` не отменён, но не должен конкурировать за реализацию в той же рабочей итерации.

## Current position

Проект не утверждает:

> «Можно статически доказать большинство свойств произвольного Ansible и проверить тысячи спеков за минуты».

Рабочая постановка:

> Нужно независимо проверить, улучшает ли invariant/counterexample protocol полноту LLM planning и существует ли в реальных Ansible-ролях экономически ценный фрагмент для ограниченного effect analysis.

Полноценный engine, автоматический routing и production evidence platform отложены до экспериментальных оснований.

## Completed in `bootstrap/project-memory`

### Project memory

- создан порядок чтения для чистых сессий;
- зафиксированы authority, evidence-scope и prompt-injection rules;
- добавлены charter, research state, hypotheses, ADR, related work и templates;
- открыта draft PR с file-first памятью проекта.

### E0a-P protocol

- parent protocol переведён в статус `executable-protocol draft`;
- определены task inclusion/exclusion criteria;
- выбран provisional six-task coverage slate;
- зафиксирован independent gold workflow;
- определены strict/lenient coverage и harmful-output labels;
- записаны exact P0/P1/P2 prompt deltas;
- задан 72-run working design;
- определены randomization, retry, blinding и adjudication rules;
- создан canonical task/gold/run/score data contract.

### DRY-00 materialization

- создан controlled synthetic task package по безопасному upgrade `process_exporter`;
- authoritative context отделён от untrusted repository data;
- встроена controlled prompt-injection fixture;
- package имеет manifest и candidate digest;
- exact prompt components вынесены в experiment artifacts;
- добавлены prompt checksums и deterministic assembler script.

## Next best step

### 1. Проверить artifacts после checkout

В окружении с доступом к GitHub:

```bash
git checkout bootstrap/project-memory
cd experiments/E0a-P/protocol
sha256sum --check SHA256SUMS
bash assemble-prompt.sh \
  P0 \
  ../tasks/DRY-00/task-package.txt \
  /tmp/DRY-00-P0-prompt.txt
```

Затем сверить `task-package.txt` с digest из `task-manifest.yaml` и изменить `digest_verified_after_commit` только после фактической проверки.

Текущая рабочая среда не смогла выполнить local clone из-за DNS resolution failure для `github.com`; успешный end-to-end test не заявляется.

### 2. Провести DRY-00 expert preflight

Требуются три независимых domain experts, которые до просмотра model outputs:

- оценивают package completeness;
- создают raw obligation/question candidates;
- фиксируют source, authority и active time;
- не обсуждают candidates друг с другом.

### 3. Построить dry-run gold

```text
independent elicitation
→ neutral normalization
→ closed rating
→ disagreement report
→ adjudication
→ gold-v1 freeze
```

### 4. Выбрать primary model

Зафиксировать exact identifier, parameters, reasoning mode, output cap и execution window. Model screening выполняется только на `DRY-00` или другом non-study task.

### 5. Выполнить три dry-run calls

По одному `P0/P1/P2`, затем double scoring. После этого protocol/manual можно исправить и freeze для pilot.

## Open decisions

1. Кто войдёт в panel из трёх независимых experts и кто будет neutral normalizer.
2. Кто выполнит double scoring и adjudication.
3. Какая primary model доступна для воспроизводимых 72+ calls.
4. Где хранить raw/private requests, responses и annotations.
5. Будет ли pilot corpus controlled-only или mix reconstructed-real/controlled.
6. Источник шести final task packages и access/licensing records.
7. Возможность переиспользования APME или Ansible Risk Insight для последующего E0a-A profiler.
8. Лицензия репозитория и будущего public corpus — решение владельца, пока не принято.

## Explicitly deferred

Не начинать без нового решения:

- реализацию общего Ansible IR;
- symbolic Jinja interpreter;
- semantic models модулей;
- runtime verification router;
- evidence registry;
- multi-host verifier;
- production blocking CI gate.

## Exit condition for current phase

`DRY-00` завершён, когда:

- prompt/task digests фактически проверены;
- experts применили annotation manual;
- dry-run gold frozen до model outputs;
- получены по одному raw P0/P1/P2 output;
- outputs double-scored;
- ambiguity, burden и treatment contrast задокументированы;
- protocol/manual пересмотрены и готовы к pilot freeze либо признаны непригодными.
