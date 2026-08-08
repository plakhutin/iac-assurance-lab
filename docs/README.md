# Documentation index

Это оглавление проектной памяти `iac-assurance-lab`. Новая или чистая сессия должна начинаться с `AGENTS.md`, затем переходить к документам ниже.

## Текущее состояние

- [current-focus.md](current-focus.md) — текущая фаза, ближайший результат, открытые решения и следующий лучший шаг.

## Проект

- [project/charter.md](project/charter.md) — миссия, scope, нецели и целевой пользователь.
- [project/research-state.md](project/research-state.md) — консолидированная память исследования и принятые выводы.
- [project/hypotheses.md](project/hypotheses.md) — независимые гипотезы, зависимости и decision branches.

## Решения

- [decisions/ADR-0001-research-before-engine.md](decisions/ADR-0001-research-before-engine.md) — сначала calibration/confirmatory research, затем условная реализация analyzer.
- [decisions/ADR-0002-file-first-project-memory.md](decisions/ADR-0002-file-first-project-memory.md) — file-first память для работы в отдельных сессиях.

## Эксперименты

- [experiments/README.md](experiments/README.md) — жизненный цикл и правила experiment documents.
- [experiments/E0a-P-planner-pilot.md](experiments/E0a-P-planner-pilot.md) — canonical calibration protocol LLM planning.
- [experiments/E0a-P/README.md](experiments/E0a-P/README.md) — исполнимый E0a-P package и dry-run checklist.
  - [task-selection.md](experiments/E0a-P/task-selection.md) — criteria и provisional six-task slate.
  - [annotation-manual.md](experiments/E0a-P/annotation-manual.md) — gold creation и scoring rubric.
  - [prompt-protocols.md](experiments/E0a-P/prompt-protocols.md) — exact P0/P1/P2 instructions.
  - [runbook.md](experiments/E0a-P/runbook.md) — randomization, execution, review и analysis.
  - [data-contract.md](experiments/E0a-P/data-contract.md) — canonical records и integrity checks.
- [experiments/E0a-A-analyzability-pilot.md](experiments/E0a-A-analyzability-pilot.md) — calibration pilot real-role analyzability и opaque-cone.

## Research

- [research/related-work.md](research/related-work.md) — проверенные соседние работы, инструменты и влияние на новизну.

## Шаблоны

- [templates/experiment.md](templates/experiment.md) — новый experiment protocol.
- [templates/decision.md](templates/decision.md) — новый ADR.
- [templates/session-handoff.md](templates/session-handoff.md) — передача состояния в чистую сессию.

## История работы

- [worklog/README.md](worklog/README.md) — формат кратких исторических записей.
- [worklog/2026-08-08-e0ap-protocol-and-dry-run.md](worklog/2026-08-08-e0ap-protocol-and-dry-run.md) — materialization E0a-P protocol, prompt artifacts и `DRY-00`.

## Правила актуальности

- `current-focus.md` должен отражать настоящее, а не историю.
- `research-state.md` хранит устойчивые выводы, а не подробный transcript обсуждений.
- ADR не переписывается после принятия, кроме исправления опечаток; новое решение оформляется новым ADR.
- Experiment document должен явно иметь статус: `draft`, `executable-protocol draft`, `pilot`, `preregistered`, `running`, `completed` или `superseded`.
- После изменения состава документов обновляй это оглавление.
