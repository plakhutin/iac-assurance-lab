# ADR-0001: Run calibration research before building a verification engine

- **Status:** Accepted
- **Date:** 2026-08-08
- **Decision owners:** repository owner / project research lead

## Context

Исходная концепция предполагала Semantic Verification Engine, который преобразует Ansible в semantic IR, проверяет invariants и направляет `UNKNOWN` в более дорогие backends.

Критический разбор выявил, что такой план преждевременно предполагает несколько недоказанных вещей:

- LLM-generated specifications достаточно полны и надёжны;
- значимая доля реальных roles попадает в анализируемый fragment;
- opaque constructs не обнуляют большую часть critical obligations;
- static/model analysis экономически выгоднее прямых runtime tests;
- analyzer возможно поддерживать при изменениях Ansible, collections и environment semantics.

Related work также показывает, что formal/symbolic verification небольших Ansible fragments и generic static validator platforms уже существуют. Основной открытый вопрос — применимость и экономика на production-like roles, а не сам факт возможности построить IR.

## Decision

До реализации общего Semantic Verification Engine проект выполняет два calibration pilots:

1. `E0a-P` — planner pilot для оценки baseline, variance, annotation process и sample size;
2. `E0a-A` — analyzability pilot на legacy roles as-is с obligation-relative opaque-cone.

После пилотов создаётся confirmatory preregistration. Узкий effect analyzer строится только если analyzability и optimistic economic ceiling оправдывают реализацию.

Verification routing и production evidence platform рассматриваются только после измерения точности и стоимости конкретных backends.

## Consequences

### Positive

- дешёвые эксперименты могут рано опровергнуть слабые ветки проекта;
- платформа не становится самоцелью;
- sample size и thresholds выводятся из pilot data;
- новизна проекта смещается к эмпирике, где остаётся реальный пробел;
- отрицательный результат сохраняет исследовательскую ценность.

### Negative

- нет немедленного большого engineering artifact;
- понадобится expert annotation и corpus work;
- результаты могут показать, что analyzer экономически не нужен;
- сроки до production tooling становятся условными.

## Alternatives considered

### Build the full engine first

Отклонено: слишком высокий риск потратить ресурсы до измерения analyzability и spec quality.

### Build only a linter

Не исключено как локальный outcome, но недостаточно для проверки planning/analyzability hypotheses.

### Run only integration tests

Остаётся baseline. Нельзя заранее считать его дороже без cost study.

### Trust LLM-generated specifications

Отклонено: specification problem и correlated errors создают ложную уверенность.

## Revisit conditions

ADR пересматривается только если:

- появляется внешний reusable artifact, радикально снижающий стоимость analyzer;
- владелец меняет цель проекта с research на конкретный production detector;
- pilot data уже существуют и подтверждают необходимость реализации.
