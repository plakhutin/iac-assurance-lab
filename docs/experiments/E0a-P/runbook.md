# E0a-P execution runbook

## 1. Scope

Runbook описывает полный путь от `DRY-00` до calibration report. Он не разрешает confirmatory claims и не заменяет будущую preregistration.

## 2. Working design

```text
dry-run tasks:             1 (DRY-00, excluded from pilot outcomes)
pilot tasks:               6
arms:                      P0, P1, P2
runs per task × arm:       4
expected valid outputs:    72
primary model:             1 exact identifier
independent gold experts:  3
independent scorers:       2 per output
primary analysis unit:     task
```

Дополнительная model replication не входит в core pilot. Она может быть отдельным exploratory extension только после завершения основного набора и не смешивается с ним.

## 3. Phase A — prepare task packages

### A1. Create manifests

Для `DRY-00` и каждого candidate task создать canonical manifest по `data-contract.md`.

Обязательно:

- immutable source/commit/digest;
- allowed files и stable order;
- authority labels;
- access/licensing status;
- input size;
- injection metadata в отдельном private field;
- отсутствие secrets/PII.

### A2. Preflight

Применить [`task-selection.md`](task-selection.md). Задачи, не прошедшие inclusion criteria, не заменяются после просмотра model outcomes.

### A3. Freeze bytes

Для каждой выбранной задачи сохранить:

```text
task_package.txt
task-manifest.yaml
SHA256SUMS
```

Assembled package для всех arms должен иметь один digest.

## 4. Phase B — dry run

`DRY-00` используется только для проверки procedure.

### B1. Gold dry run

Три эксперта независимо создают candidates. Затем выполняются normalization, closed rating и adjudication согласно manual.

Измерить:

- active annotation time;
- candidate overlap;
- ambiguous definitions;
- items без source;
- normalization burden.

### B2. Prompt dry run

Запустить минимум по одному output на P0/P1/P2 с primary model.

Проверить:

- treatment contrast;
- output truncation;
- format compliance;
- task-envelope integrity;
- prompt-injection behavior;
- manifest completeness.

### B3. Scoring dry run

Два scorers независимо оценивают три outputs, не видя arm labels.

Проверить:

- strict vs weak coverage;
- acceptance criteria;
- evidence spans;
- proposition-level errors;
- review time;
- arm-guess confidence.

### B4. Revise and freeze protocol

Любые изменения manual/prompts/data contract:

- применяются ко всем будущим pilot tasks;
- получают новую version/digest;
- заносятся в change log;
- завершаются до model generation по pilot tasks.

Dry-run outputs не входят в pilot analysis.

## 5. Phase C — build and freeze gold sets

Gold sets для шести pilot tasks создаются **до любых pilot model outputs**.

Для каждой задачи:

1. independent elicitation тремя experts;
2. neutral normalization;
3. closed-universe rating;
4. agreement report;
5. adjudication;
6. gold version/digest;
7. acceptance criteria validation.

Coordinator подтверждает, что experts не имеют доступа к generated outputs и arm prompts beyond what is needed to understand the experiment.

## 6. Phase D — select and pin the primary model

До randomization фиксируются:

- provider;
- exact model identifier/version, насколько provider раскрывает;
- access method;
- reasoning mode/budget;
- temperature/top-p/max output tokens;
- seed strategy;
- retry policy;
- execution window.

### Model selection rule

Pilot выбирает одну модель, которая:

- доступна для 72+ reproducible calls;
- позволяет сохранить exact request/response metadata;
- не требует arm-specific prompt adaptation;
- имеет достаточный context window;
- допускает разумную фиксацию parameters.

Выбор модели не делается по результатам P0/P1/P2 на pilot tasks. Model screening разрешён только на `DRY-00` или отдельном non-study task.

## 7. Phase E — randomization manifest

До первого pilot call генерируется таблица из 72 planned runs.

Fields:

```text
sequence_index
run_id
task_id
protocol
replicate
model_id
prompt_version
task_package_digest
planned_execution_block
```

### Randomization

- Runs перемешиваются внутри execution window.
- Не выполнять сначала все P0, затем P1/P2.
- Желательно blocked randomization, чтобы в каждом temporal block присутствовали разные tasks и arms.
- Sequence фиксируется до результатов.

### Run IDs

Run ID не должен раскрывать protocol scorer'у. Public/anonymized ID генерируется отдельно.

## 8. Phase F — execute model runs

Для каждой строки randomization manifest:

1. проверить prompt component digests;
2. собрать request;
3. записать request timestamp;
4. выполнить один model call;
5. сохранить raw response без редактирования;
6. записать usage/latency/provider metadata;
7. вычислить response digest;
8. записать completion status.

### No best-of-N

Все четыре repetitions являются data. Нельзя выбирать лучший response или перегенерировать ответ из-за низкого качества.

### Retry policy

Retry допустим только при техническом failure:

```text
transport error
provider 5xx/rate limit after backoff
empty/malformed provider payload
connection termination
```

Не являются причиной retry:

```text
пропущенные obligations
слишком общий plan
нарушение prompt injection boundary
format noncompliance
короткий или плохой ответ
```

Каждый failed attempt сохраняется. Retry получает отдельный `attempt_id`, но связан с исходным planned `run_id`. После заранее установленного maximum attempts run получает `technical_failure` и не заменяется выборочно.

### Provider drift

Если exact model identifier изменился либо provider объявил существенное обновление во время execution window:

- остановить новые calls;
- сохранить выполненный block;
- решить до просмотра aggregate outcomes: restart entire pilot на новой версии либо анализировать version blocks отдельно;
- не смешивать версии как будто они идентичны.

## 9. Phase G — anonymization and treatment integrity

Neutral coordinator создаёт scorer package:

```text
anonymous_output_id
task package
gold set
raw output text
```

Удаляются:

- protocol label;
- run sequence;
- replicate number;
- model sampling metadata;
- provider request IDs.

Не удаляются и не меняются:

- headings;
- order;
- wording;
- length;
- format mistakes.

Coordinator отдельно проверяет treatment integrity на assembled prompts.

## 10. Phase H — independent output scoring

### Assignment

- Каждый output получает два scorers.
- Assignment балансируется, чтобы один scorer не видел только один task/arm pattern.
- Порядок outputs randomizes для каждого scorer.

### Scoring

Scorer:

1. запускает timer;
2. читает task package и output;
3. оценивает каждый gold item;
4. сохраняет evidence spans;
5. отмечает proposition-level errors;
6. оценивает counterexamples;
7. записывает protocol guess/confidence;
8. останавливает timer;
9. submit делает без доступа к оценке второго scorer.

### Adjudication

Обязательной adjudication подлежат:

- disagreement по strict coverage critical item;
- любой `CONTRADICTED` critical item;
- prompt-injection failure;
- critical hallucinated/invalid proposition;
- `NOT_SCORABLE`.

Для остальных disagreement policy фиксируется после dry run и до pilot scoring.

## 11. Phase I — derive calibration metrics

### Per output

```text
strict critical recall
lenient critical recall
critical contradictions
required-question recall
invalid/vacuous/hallucinated proposition count
unsupported scope exclusions
useful counterexamples
word/proposition count
review time
protocol guess
```

### Per task × arm

Сначала усреднить четыре runs внутри task × arm. Runs не считаются шестьюдесятью двумя независимыми задачами.

### Primary task-level calibration outputs

```text
mean strict critical recall per arm
paired task differences P1-P0, P2-P0, P2-P1
SD of paired task differences
within-cell run variance
missed critical items per task
relative miss reduction
annotation/scoring time
```

### Expert process outputs

```text
independent elicitation coverage
candidate saturation
include/severity disagreement
normalization/adjudication burden
items lacking source/authority
```

## 12. Phase J — exploratory analysis

Pilot analysis должен быть descriptive.

Recommended views:

- task-by-task recall table;
- arm × task paired plot;
- within-cell run distribution;
- missed-item heatmap by property class;
- error-rate table normalized per output and per 100 propositions;
- review-time distribution;
- expert disagreement map;
- protocol-guess confusion matrix;
- ceiling/floor assessment.

Bootstrap/permutation calculations допустимы как sensitivity checks, но pilot не объявляет H-P confirmed/failed на основании `p < 0.05`.

## 13. Phase K — calibration decision

На основании pilot формируются inputs для E0b:

- baseline and ceiling;
- paired SD;
- run variance;
- practical effect definition;
- feasible task count;
- annotation cost;
- revised primary estimand;
- multiplicity/decision matrix;
- prompt/manual freeze candidate.

Допустимые outcomes:

```text
proceed to confirmatory design
redesign protocol and repeat calibration
retain only one treatment contrast
stop H-P track due measurement infeasibility
```

Нельзя объявлять любой observed improvement достаточным post hoc.

## 14. Operational stop/redesign conditions

Остановить запуск и не продолжать accumulating outputs, если:

- package/prompt differs across arms beyond planned delta;
- gold set был раскрыт model;
- model version drift нельзя локализовать;
- raw responses/manifests не сохраняются;
- scorer sees protocol labels;
- reviewer manual после dry run остаётся неприменимым;
- real secrets/PII обнаружены в package;
- execution cost превысил approved budget до завершения balanced block.

При остановке уже собранные artifacts не удаляются.

## 15. Suggested artifact layout

Создавать только при фактическом запуске:

```text
experiments/E0a-P/
├── protocol/
│   ├── prompts/
│   ├── manuals/
│   └── SHA256SUMS
├── tasks/
│   ├── DRY-00/
│   └── E0P-T01...T06/
├── randomization/
├── runs/
│   ├── requests/
│   ├── responses/
│   └── manifests/
├── annotations/
│   ├── elicitation/
│   ├── normalized/
│   ├── ratings/
│   ├── gold/
│   └── scoring/
├── derived/
├── analysis/
└── report/
```

Raw/private materials не должны попадать в public Git без access/licensing review.

## 16. Completion checklist

- [ ] `DRY-00` completed and excluded from outcomes;
- [ ] protocol/manual versions frozen;
- [ ] six task packages frozen;
- [ ] six gold sets frozen before generation;
- [ ] primary model pinned;
- [ ] 72-run randomization manifest created;
- [ ] treatment-integrity audit passed;
- [ ] all attempts and raw outputs preserved;
- [ ] every valid output double-scored;
- [ ] mandatory disagreements adjudicated;
- [ ] calibration report includes negative/ambiguous results;
- [ ] E0b inputs documented without confirmatory claim.
