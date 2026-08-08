# E0a-P: Planner calibration pilot

- **Status:** draft
- **Type:** exploratory calibration pilot
- **Track:** P — Planning
- **Confirmatory use:** prohibited

## 1. Objective

Проверить пригодность experimental design для будущего confirmatory сравнения LLM planning protocols и получить данные, необходимые для sample-size calculation.

Pilot не отвечает окончательно на вопрос, улучшает ли invariant-first planning качество. Он должен оценить:

- baseline critical-obligation recall;
- task-level paired variance между protocols;
- run-to-run LLM variance;
- ceiling effects;
- количество и структуру gold obligations на задачу;
- invalid/vacuous proposal rate;
- annotation burden и expert agreement;
- human review time.

## 2. Compared protocols

### P0 — Plain planning

LLM получает task/repository context и должна подготовить implementation plan без специального invariant protocol.

### P1 — Invariant-first

Перед implementation decomposition LLM должна явно пройти:

```text
Goal
Current state / repository conventions
Assumptions and unknowns
Constraints
Invariants / required properties
Verification obligations
Implementation decomposition
```

### P2 — Counterexample-first extension

P1 дополняется:

```text
Failure model
Counterexample attack per critical property
Lifecycle cases
Security boundaries
Scope exclusions requiring decision
```

Prompts должны отличаться только protocol instructions. Model, context budget и task inputs остаются одинаковыми.

## 3. Pilot sample

Предварительно:

- 6–8 задач;
- 3 protocols;
- 4–5 independent runs на `task × protocol`;
- 3 независимых domain experts для initial annotation;
- separate adjudication step.

Размер является pilot proposal, а не confirmatory sample size.

### Candidate task domains

Набор должен включать разные failure shapes:

1. exporter/systemd role;
2. reverse proxy configuration;
3. log shipper with secrets and remote dependency;
4. TLS certificate deployment/rotation;
5. package repository and upgrade;
6. database monitoring user/privileges;
7. disable/uninstall lifecycle;
8. multi-host or `delegate_to` case.

Хотя бы одна задача должна содержать controlled prompt-injection text внутри repository data.

### Exclusion

Задачи pilot не используются как confirmatory evaluation tasks, если не применяется заранее описанный blinded internal-pilot design.

## 4. Task package

Каждая задача должна содержать одинаковый пакет для всех protocols:

- task brief;
- immutable repository snapshot;
- relevant architecture/policy documents;
- explicit user decisions;
- ограничение token/time budget;
- список файлов, которые разрешено читать;
- untrusted repository content boundary.

Нельзя добавлять protocol-specific domain hints.

## 5. Gold/annotation model

### Annotation unit

Рабочая единица — `obligation candidate`, содержащая:

```yaml
id: TASK-01-OBL-001
statement: PostgreSQL must not be explicitly restarted by the exporter role
class: safety
severity: critical
source:
  type: architecture_policy
  reference: ADR-014
authority: required
scope: ansible_effect
notes: null
```

### Required annotation classes

- assumptions/questions;
- critical obligations;
- non-critical useful obligations;
- unacceptable scope exclusions;
- invalid claims;
- vacuous claims;
- hallucinated requirements;
- implementation details incorrectly presented as requirements.

### Independent annotation

Эксперты сначала работают независимо. После этого измеряется agreement и проводится adjudication.

Низкое agreement считается самостоятельным результатом о specification problem и не маскируется forced consensus.

### Open decision

Выбрать и обосновать agreement metric с учётом multiple labels и sparse obligations. Простое Cohen's kappa может быть недостаточно.

## 6. LLM execution

### Randomization

- protocol/task runs перемешиваются;
- order не должен быть сгруппирован по protocol;
- runs выполняются в узком временном окне для снижения API drift;
- evaluator не видит protocol label при первичной оценке, где это возможно.

### Recorded metadata

- provider и exact model identifier;
- timestamp;
- temperature/top-p/seed, если доступны;
- prompt version/digest;
- task package digest;
- response text и digest;
- errors/retries;
- latency/token usage.

Предпочтительно иметь pinned open-weight model для reproducibility и отдельную hosted frontier model как external-validity replication. Это пока open decision.

## 7. Pilot outcomes

### Primary calibration outputs

На уровне задачи:

- macro recall по critical obligations;
- paired differences `P1-P0`, `P2-P0`, `P2-P1`;
- standard deviation paired differences;
- missed-obligation count;
- relative miss reduction;
- review time.

### Secondary outputs

- invalid/vacuous proposal rate;
- assumption recall;
- scope-exclusion detection;
- counterexample usefulness;
- prompt-injection compliance failures;
- run-to-run variance;
- protocol output length/token cost.

### Unit of generalization

Primary unit — task. Отдельные runs уточняют stochastic variance, но не считаются независимыми задачами.

Не использовать pooled obligation count как единственный результат: задачи с большим количеством obligations не должны поглотить остальные.

## 8. Analysis approach for pilot

Pilot analysis является descriptive/exploratory:

- task-level distributions;
- paired plots/tables;
- bootstrap sensitivity checks;
- expert disagreement map;
- variance decomposition by task/run;
- ceiling assessment.

Не объявлять `p < 0.05` доказательством H-P на pilot sample.

## 9. Outputs required before E0b preregistration

1. Оценка baseline recall и paired SD.
2. Минимально практически значимый effect, определённый с владельцем проекта.
3. Confirmatory sample-size calculation.
4. Решение по primary estimand: absolute additional obligations, absolute recall difference, relative miss reduction или hierarchy.
5. Multiplicity policy для protocol comparisons.
6. Frozen annotation manual.
7. Frozen task inclusion/exclusion criteria.
8. Plan handling model/API drift.
9. Decision о pilot-task reuse.

## 10. Threats to validity

- expert gold set может быть неполным;
- эксперты могут не согласиться о criticality;
- model contamination from public repositories;
- task heterogeneity увеличит variance;
- output verbosity может искусственно повышать recall;
- protocol may induce more guesses rather than better claims;
- evaluator may infer protocol from answer structure;
- hosted model may change during experiment;
- prompt injection challenge may not represent real attacks.

## 11. Stop conditions

Pilot прекращается или redesign выполняется, если:

- annotation unit невозможно применять с приемлемой согласованностью;
- task package не позволяет отделить requirement inference от implementation knowledge;
- protocol variants случайно получают разный domain context;
- reproducibility metadata не сохраняются;
- review burden делает запланированный confirmatory sample практически невозможным.

## 12. Open tasks

- [ ] определить 6–8 task candidates;
- [ ] написать annotation manual;
- [ ] подготовить exact P0/P1/P2 prompts;
- [ ] выбрать models и execution harness;
- [ ] определить blind review workflow;
- [ ] определить review-time measurement;
- [ ] оформить data manifest;
- [ ] провести dry run на одной задаче, не входящей в pilot.

## 13. Change log

- 2026-08-08 — initial draft created during repository bootstrap.
