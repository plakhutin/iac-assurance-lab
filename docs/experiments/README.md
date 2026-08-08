# Experiments

Этот каталог хранит versioned protocols, preregistration и результаты исследований.

## Current experiments

| ID | Название | Стадия | Цель |
|---|---|---|---|
| `E0a-P` | Planner calibration pilot | executable-protocol draft | Оценить baseline, variance, annotation process и sample-size inputs |
| `E0a-A` | Analyzability calibration pilot | draft | Оценить prevalence opaque constructs и feasibility obligation-relative slicing |

### E0a-P protocol package

- [`E0a-P-planner-pilot.md`](E0a-P-planner-pilot.md) — canonical high-level protocol и readiness status.
- [`E0a-P/README.md`](E0a-P/README.md) — package index и dry-run entry checklist.
- [`E0a-P/task-selection.md`](E0a-P/task-selection.md) — inclusion/exclusion criteria и provisional task slate.
- [`E0a-P/annotation-manual.md`](E0a-P/annotation-manual.md) — independent gold creation и output scoring.
- [`E0a-P/prompt-protocols.md`](E0a-P/prompt-protocols.md) — exact common prompt и treatment deltas.
- [`E0a-P/runbook.md`](E0a-P/runbook.md) — execution, randomization, retries, blinding и analysis.
- [`E0a-P/data-contract.md`](E0a-P/data-contract.md) — canonical task/gold/run/score records.

## Lifecycle

```text
draft
→ executable-protocol draft
→ pilot
→ preregistered
→ running
→ completed
→ superseded
```

`pilot` и `preregistered` имеют разное назначение:

- pilot калибрует инструмент измерения, baseline, variance и procedure;
- preregistered experiment проверяет заранее зафиксированную hypothesis.

Pilot outcomes нельзя подавать как confirmatory result.

`executable-protocol draft` означает, что procedure уже описана достаточно точно для dry run, но task packages, participants, model и manifests ещё не frozen.

## Required sections

Каждый experiment document должен содержать:

- research question;
- hypothesis или calibration objective;
- population и sampling;
- inclusion/exclusion criteria;
- experimental arms;
- unit of analysis;
- annotations/gold set;
- primary и secondary outcomes;
- uncertainty/statistical plan;
- confounders и threats to validity;
- data/provenance manifest;
- stop/decision rules;
- status и change log.

## Reproducibility manifest

Для LLM runs сохраняются:

- provider/model identifier;
- timestamp и execution window;
- system/user prompt exact text;
- model parameters;
- input repository/task digest;
- response artifact и hash;
- randomization/order;
- retry/failure record;
- evaluator version.

Для Ansible corpus:

- repository URL или internal identifier;
- immutable commit digest;
- license/access constraints;
- role path;
- Ansible/collection metadata;
- anonymization transformation, если применимо.

## Result storage

До появления фактических данных каталог не должен содержать выдуманных цифр или synthetic «ожидаемых результатов». Expected structure и acceptance logic помечаются как proposal.

После выполнения experiment рекомендуется разделять:

```text
protocol/
raw/
annotations/
derived/
analysis/
report/
```

Но конкретная структура создаётся только при реальной необходимости.
