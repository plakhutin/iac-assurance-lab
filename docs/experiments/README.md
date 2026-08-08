# Experiments

Этот каталог хранит versioned protocols, preregistration и результаты исследований.

## Current experiments

| ID | Название | Стадия | Цель |
|---|---|---|---|
| `E0a-P` | Planner calibration pilot | draft | Оценить baseline, variance, annotation process и sample-size inputs |
| `E0a-A` | Analyzability calibration pilot | draft | Оценить prevalence opaque constructs и feasibility obligation-relative slicing |

## Lifecycle

```text
draft
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
