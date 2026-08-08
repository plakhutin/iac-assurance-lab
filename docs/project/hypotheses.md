# Research hypotheses and decision branches

**Status:** working model  
**Confirmatory thresholds:** not preregistered; calibration pilot required first

## Principle

Проект не имеет одного бинарного verdict. Он состоит из независимых гипотез. Провал одной ветки не должен маскироваться успехом другой и не всегда уничтожает весь проект.

## H-P — Planning value

### Hypothesis

Invariant-first и counterexample-first protocols повышают полноту LLM planning инфраструктурных изменений по сравнению с plain implementation-first planning при приемлемом росте human review effort.

### Compared protocols

```text
P0 — plain implementation planning
P1 — assumptions + constraints + invariants
P2 — P1 + failure model + counterexample attack + lifecycle
```

### Candidate outcomes

- critical obligation recall;
- additional critical obligations recovered per task;
- relative reduction in missed critical obligations;
- invalid critical proposal rate;
- vacuous proposal rate;
- silent scope narrowing rate;
- review time;
- run-to-run variance.

### Calibration needs

- baseline recall;
- task-level paired variance;
- ceiling effects;
- number of obligations per task;
- expert agreement;
- annotation burden.

### If rejected

Не использовать LLM-generated claims как основу assurance workflow. Track A/D может продолжиться с human- или policy-authored obligations.

## H-G — Governance safety

### Hypothesis

Deterministic mandatory-review policy, provenance, full diff availability и seeded/random audits способны удерживать missed mandatory decision rate на приемлемом уровне при использовании LLM proposals.

### Mandatory decision classes

- scope exclusion added or widened;
- severity lowered;
- protected resource set changed;
- waiver introduced;
- opaque contract accepted;
- proposed claim promoted to authoritative;
- lifecycle case declared out of scope.

### Candidate outcomes

- missed mandatory decision rate;
- reviewer override rate;
- seeded issue detection rate;
- reviewer time;
- automation-bias indicators;
- disagreement and escalation rate.

### If rejected

LLM proposals остаются advisory notes без authority promotion automation. Verification может работать только на утверждённых вручную/policy claims.

## H-A — Real-role analyzability

### Hypothesis

В legacy Ansible roles as-is существует достаточно большой и экономически значимый набор important obligations с пустым или устранимым obligation-relative opaque cone, чтобы оправдать дальнейший узкий effect analyzer.

### Primary objects

- real legacy roles without rewriting;
- expert-authored obligations;
- structural task/include/handler/variable graph;
- obligation-relative `OpaqueCone`;
- optimistic runtime-cost avoidance ceiling.

### Candidate outcomes

- global empty-cone rate;
- conditional empty-cone rate within declared profile;
- opaque fan-out;
- minimal opaque cut;
- distribution by property class and severity;
- unsupported construct distribution;
- multi-host/out-of-profile prevalence;
- optimistic cost-avoidance ceiling.

### Honest denominator

Global metrics включают:

- shell-heavy roles;
- multi-host cases;
- functional obligations;
- out-of-profile constructs.

Conditional profile metrics публикуются отдельно и не заменяют global result.

### If rejected

Не строить общий effect analyzer. Возможны только узкие deterministic checks с очевидной ценностью: handler target, secret mode, direct service action или policy lint.

## H-D — Defect detection

### Hypothesis

Узкий effect analyzer для поддерживаемого scope обнаруживает реальные high-severity IaC defects с приемлемой sensitivity и достаточно высокой prospective precision для advisory или blocking use.

### Primary defect sources

1. реальные ошибки plain LLM;
2. реальные ошибки invariant-first LLM;
3. historical fixes;
4. incidents/postmortems;
5. expert-seeded realistic defects;
6. mutants как secondary diagnostic corpus.

### Separate studies

- offline defect-enriched corpus — sensitivity/coverage;
- prospective shadow mode on normal changes — precision, false-positive burden, review cost.

### Promotion levels

```text
experimental
→ advisory
→ shadow-blocking
→ blocking
```

Promotion происходит по detector/rule family, а не для analyzer целиком.

### If rejected

Оставить structural profiler и advisory diagnostics; не использовать analyzer как blocking CI gate.

## H-E — Verification economics

### Hypothesis

После измерения точности backend'ов выбор набора verification jobs способен снизить p95 latency или compute cost при ограниченном росте high-severity defect escape.

### Required inputs

- measured obligation coverage per job;
- assertion-level evidence;
- false-negative/false-positive estimates;
- job reliability and flake rate;
- p50/p95 runtime;
- correlated failure domains;
- fallback behavior;
- build and maintenance cost.

### Baselines

- deterministic `ansible-lint + full integration suite`;
- fixed test-impact rules;
- простой deterministic test selection;
- при наличии данных — predictive test selection baseline.

### If rejected

Использовать полезные static checks и фиксированный runtime suite без автоматического router/optimizer.

## Dependency graph

```text
H-P ───────────────┐
                   ├─ integrated LLM-assisted assurance
H-G ───────────────┘

H-A → H-D → H-E
```

`H-P/H-G` и `H-A/H-D/H-E` могут давать независимые результаты.

## Decision matrix

| H-P | H-A | H-D | H-E | Решение |
|---|---|---|---|---|
| fail | fail | — | — | Остановить integrated vision; сохранить отрицательный result |
| pass | fail | — | — | Оставить planning protocol/checklist, не строить analyzer |
| fail | pass | pass/fail | — | Analyzer только для human/policy-authored obligations |
| any | pass | fail | — | Profiler/advisory diagnostics, без blocking gate |
| any | pass | pass | fail | Static checks + fixed runtime suite, без router |
| pass | pass | pass | pass | Возможен integrated workflow при прохождении H-G |

## Threshold policy

Числовые gates не назначаются до calibration pilot.

После pilot должны быть заранее зафиксированы:

- primary estimand;
- minimal practically important effect;
- sample size based on observed variance/baseline;
- confidence interval requirement;
- multiplicity policy;
- branch decision rule;
- stop/go economics.

Exploratory pilot results не используются как confirmatory evidence и не подменяют preregistration.
