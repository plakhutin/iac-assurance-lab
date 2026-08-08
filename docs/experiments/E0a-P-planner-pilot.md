# E0a-P: Planner calibration pilot

- **Status:** executable-protocol draft
- **Type:** exploratory calibration pilot
- **Track:** P — Planning
- **Confirmatory use:** prohibited
- **Protocol package:** [`E0a-P/README.md`](E0a-P/README.md)

## 1. Objective

Проверить пригодность experimental design для будущего confirmatory сравнения LLM planning protocols и получить данные для sample-size calculation.

Pilot не отвечает окончательно, улучшает ли invariant-first planning качество. Он оценивает:

- baseline critical-obligation recall;
- task-level paired variance между protocols;
- run-to-run LLM variance;
- ceiling/floor effects;
- количество и структуру gold items;
- invalid/vacuous/hallucinated proposal rate;
- annotation burden и expert disagreement;
- human review time;
- пригодность prompt arms, task package и data contract.

## 2. Compared protocols

### P0 — Plain rigorous planning

LLM готовит лучший профессиональный implementation/verification plan без предписанного invariant framework.

### P1 — Invariant-first

Перед implementation decomposition LLM должна установить:

```text
Goal and observable success
Current state and repository conventions
Assumptions, unknowns and owner decisions
Constraints and boundaries
Required properties/invariants
Verification obligations
```

### P2 — Counterexample-first extension

P1 дополняется:

```text
Failure model
Counterexample attack per critical property
Lifecycle cases
Security and ownership boundaries
Scope exclusions requiring decision
```

Exact common prompt, treatment deltas и output contract определены в [`E0a-P/prompt-protocols.md`](E0a-P/prompt-protocols.md).

## 3. Working pilot design

До dry run используются следующие рабочие значения:

```text
pilot tasks:              6
separate dry-run task:    1
protocol arms:            3
independent runs/cell:    4
planned outputs:          72
independent gold experts: 3
output scorers:           2 per output
primary unit:             task
```

Эти числа нужны для проверки procedure и burden. Они не являются confirmatory sample-size calculation.

Дополнительная модель не входит в core pilot. Pilot сначала изолирует protocol effect на одной exact model version.

## 4. Task sample

Полная процедура отбора находится в [`E0a-P/task-selection.md`](E0a-P/task-selection.md).

Итоговый набор должен покрывать:

- functional success и safety divergence;
- secrets/security boundary;
- lifecycle/recovery;
- multi-host или ownership boundary;
- remote dependency;
- required unresolved decisions;
- controlled prompt injection.

Provisional task slate:

| ID | Task |
|---|---|
| `E0P-T01` | `postgres_exporter` role/playbook integration |
| `E0P-T02` | NGINX reverse-proxy configuration change |
| `E0P-T03` | Log shipper to remote Elasticsearch/OpenSearch |
| `E0P-T04` | TLS certificate/private-key rotation |
| `E0P-T05` | Remote PostgreSQL monitoring user and ownership boundary |
| `E0P-T06` | Disable/uninstall of a previously managed exporter |

`DRY-00` является отдельной задачей для проверки procedure и не входит в outcomes.

Pilot tasks не используются как confirmatory evaluation tasks по умолчанию.

## 5. Task package

Каждая задача предоставляет один immutable package для всех arms:

- task brief;
- repository snapshot или controlled fixture;
- architecture/policy context;
- explicit human decisions;
- allowed files и stable order;
- untrusted repository boundary;
- budget and provenance metadata;
- package digest.

Внешний web/tool access во время core model run запрещён. Если необходимого факта нет, корректный output должен обозначить unknown/question, а не выдумать значение.

Canonical record описан в [`E0a-P/data-contract.md`](E0a-P/data-contract.md).

## 6. Gold and annotation workflow

Operational definitions и scoring rubric находятся в [`E0a-P/annotation-manual.md`](E0a-P/annotation-manual.md).

Gold строится до model outputs:

```text
independent expert elicitation
→ neutral semantic normalization
→ closed-universe independent rating
→ disagreement report
→ adjudication
→ versioned gold freeze
```

Полный candidate universe, включая minority items, сохраняется. LLM не определяет, что попадёт в human review.

### Gold item types

```text
required_obligation
required_question
required_scope_decision
useful_obligation
useful_question
excluded_candidate
```

### Primary coverage

Primary strict critical recall считает только gold items, оценённые как:

```text
EXPLICIT_ACTIONABLE
```

Общие, имплицитные или неоперациональные упоминания не получают strict credit.

### Required error labels

```text
invalid
hallucinated_requirement
vacuous
over_constrained
unsupported_scope_exclusion
prompt_injection_compliance
contradiction
```

## 7. LLM execution

Подробная процедура находится в [`E0a-P/runbook.md`](E0a-P/runbook.md).

Ключевые controls:

- один exact primary model identifier;
- один common system prompt и output contract;
- arm-specific difference только в protocol instruction;
- одинаковый package/output budget;
- blocked randomized run order;
- четыре repetitions на `task × arm`;
- no best-of-N;
- retry только при technical failure;
- все attempts и raw outputs сохраняются;
- provider/model drift останавливает или блокирует execution, а не скрывается.

## 8. Blinded scoring

Scorer видит:

- task package;
- frozen gold set;
- anonymized raw output.

Scorer не видит:

- protocol label;
- run sequence/replicate;
- provider request metadata.

Text output не переписывается ради blinding. После scoring reviewer угадывает protocol/confidence; это измеряет фактическую эффективность blinding.

Каждый output оценивается двумя reviewers независимо. Расхождения по strict coverage critical items, contradictions и injection failures обязательно adjudicate.

## 9. Primary calibration outputs

На уровне задачи:

- macro strict recall по critical gold items;
- paired differences `P1-P0`, `P2-P0`, `P2-P1`;
- SD paired differences;
- missed-critical count;
- relative miss reduction;
- within-cell run variance;
- expert elicitation coverage/disagreement;
- annotation and review time.

Secondary:

- lenient recall;
- high/medium item recall;
- required-question recall;
- invalid/vacuous/hallucinated rate;
- scope-exclusion detection;
- counterexample usefulness;
- prompt-injection failures;
- output length/proposition count;
- protocol-guess accuracy.

Primary unit of generalization — task. Runs оценивают stochastic variance, но не являются независимыми tasks.

## 10. Pilot analysis

Pilot analysis является descriptive/exploratory:

- task-level distributions;
- paired arm comparisons;
- within-cell run distributions;
- missed-item heatmap by class/severity;
- expert disagreement map;
- review burden;
- ceiling/floor assessment;
- bootstrap/permutation sensitivity checks без confirmatory interpretation.

`p < 0.05` на pilot sample не подтверждает H-P.

## 11. Outputs required before E0b preregistration

1. Baseline strict critical recall.
2. Paired task-level SD и run variance.
3. Практически значимый effect, определённый с owner до confirmatory outcomes.
4. Confirmatory sample-size calculation.
5. Primary estimand и hierarchy.
6. Multiplicity/decision matrix.
7. Frozen annotation manual и task criteria.
8. Model/API drift plan.
9. Feasible review-cost estimate.
10. Решение о task reuse и confirmatory holdout.

## 12. Threats to validity

- expert gold set может быть неполным;
- experts могут расходиться о authority/criticality;
- public repository/model contamination;
- task heterogeneity увеличивает variance;
- output verbosity может повышать lenient recall;
- P2 может генерировать больше guesses, а не больше valid properties;
- evaluator может распознавать arm по структуре/лексике;
- hosted model может измениться в execution window;
- prompt-injection fixture может быть нерепрезентативным;
- synthetic tasks не равны real engineering tasks;
- gold adjudicators могут страдать automation/consensus bias.

## 13. Stop/redesign conditions

Pilot procedure останавливается или redesign выполняется, если:

- task package отличается между arms;
- gold был раскрыт model;
- annotation unit/scoring scale невозможно применять;
- source/authority систематически отсутствуют;
- reproducibility metadata не сохраняются;
- model version drift нельзя локализовать;
- review burden делает confirmatory study практически невозможным;
- real secrets/PII обнаружены;
- protocol prompts менялись после начала на основании observed arm quality.

Низкий effect одного arm, высокий expert disagreement или отрицательный результат не являются technical-invalidity condition.

## 14. Readiness status

### Completed in protocol design

- [x] task inclusion/exclusion criteria;
- [x] provisional six-task coverage slate;
- [x] annotation and gold-set manual;
- [x] strict/lenient output scoring;
- [x] exact P0/P1/P2 prompt deltas;
- [x] common output contract;
- [x] execution/randomization/retry runbook;
- [x] canonical data records;
- [x] prompt-injection boundary and scoring rule.

### Required before dry run

- [ ] materialize `DRY-00` task package;
- [ ] choose primary model and parameters;
- [ ] select three experts and two scorers;
- [ ] create prompt/task digests;
- [ ] implement minimal manifest validator/runner;
- [ ] select storage/access policy for raw artifacts.

### Required before pilot generation

- [ ] complete dry run;
- [ ] revise and freeze protocol/manual;
- [ ] materialize/preflight/freeze six pilot packages;
- [ ] build/freeze six gold sets;
- [ ] generate 72-run randomization manifest;
- [ ] pass treatment-integrity audit.

## 15. Change log

- 2026-08-08 — initial conceptual draft created during repository bootstrap.
- 2026-08-08 — added executable protocol package: task selection, annotation manual, exact prompt arms, runbook and canonical data contract; status changed to `executable-protocol draft`.
