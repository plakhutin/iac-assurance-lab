# Consolidated research state

**Updated:** 2026-08-08  
**Status:** authoritative project memory, subordinate to accepted ADR and explicit owner decisions

## 1. Origin

Проект начался с практической задачи: улучшить разработку Ansible-ролей с помощью LLM не только на уровне генерации YAML, но через более строгий engineering workflow.

Flagship example:

> Написать роль для установки и настройки `postgres_exporter` и включить её в существующий playbook exporters.

Обычный LLM быстро предлагает:

```text
create role
→ download binary
→ create user
→ render config
→ create systemd unit
→ start service
→ add role to playbook
```

Исходная идея состояла в том, что implementation decomposition должна быть следствием более раннего reasoning:

```text
Goal
→ current state and conventions
→ assumptions / unknowns
→ constraints
→ invariants
→ failure model
→ corner cases / counterexamples
→ lifecycle
→ security boundaries
→ verification obligations
→ implementation decomposition
```

## 2. Первоначальные полезные идеи

Несмотря на последующее сужение claims, несколько исходных принципов сохранены.

### 2.1. Invariant-first planning

LLM должна рассматривать не только действия, но и свойства, которые должны сохраняться. Для `postgres_exporter` были сформулированы candidate properties:

- повторный converge не создаёт изменений;
- роль не должна явно перезапускать или изменять PostgreSQL;
- exporter DB user не должен получать необоснованный `SUPERUSER`;
- credentials не должны утекать и должны иметь ограниченные permissions;
- exporter не должен становиться runtime dependency PostgreSQL;
- deployment success требует реального PostgreSQL scrape, а не только `systemd active` или HTTP 200;
- relevant config change должен перезапускать exporter, unchanged config — нет;
- изменение роли не должно затрагивать unrelated exporters.

Эти свойства относятся к разным классам: safety, functional, idempotency, noninterference и operational behavior. Их нельзя считать одинаково доступными одному backend.

### 2.2. Counterexamples выводятся из properties

Вместо произвольного списка edge cases используется вопрос:

> Какая последовательность событий или значений нарушит конкретное свойство?

Пример:

```text
Property:
  изменение exporter config не должно приводить
  к явному restart PostgreSQL

Counterexample:
  template changed
  → shared notification
  → handler loop
  → monitoring_services contains postgresql
  → service state=restarted
```

Такой counterexample должен атаковать design до implementation или verification.

### 2.3. Three-way epistemics

Бинарный PASS/FAIL недостаточен. Backend должен отличать:

- доказанный результат внутри своей модели;
- конкретный counterexample;
- возможный counterexample без подтверждённой feasibility;
- недостаток семантики или evidence.

Текущая рекомендуемая терминология:

```text
PROVEN_WITHIN_MODEL
CONCRETE_COUNTEREXAMPLE
POSSIBLE_COUNTEREXAMPLE
INCONCLUSIVE
OUT_OF_PROFILE
OBSERVED_IN_ENVIRONMENT
```

### 2.4. Cheapest sufficient evidence — гипотеза, не аксиома

Статический анализ, model-based tests, containers, VM и integration tests могут закрывать разные obligations. Однако реальная доля разрешения и экономический эффект должны измеряться. Нельзя заранее утверждать, что большинство obligations разрешится статически.

## 3. Главная критика исходной конструкции

Три раунда критического разбора привели к изменению центра проекта.

### 3.1. Specification problem и циркулярность

Исходная схема была потенциально циркулярной:

```text
LLM generates implementation
LLM generates specification
machine checks implementation against that specification
```

Если обе ветви делают согласованную ошибку, CI получает убедительный зелёный результат.

Поэтому LLM не является oracle или authority. Она только предлагает gaps, assumptions, invariants и counterexamples. Authoritative baseline должен приходить из:

- требований;
- architecture constraints;
- organization policies;
- существующих tests/ADRs;
- human decisions.

LLM proposal должен иметь provenance и статус `proposed`. Перевод в authoritative claim требует policy или человека.

При этом human gate сам не устраняет проблему автоматически. LLM не должна единолично решать, какие scope exclusions и risks попадут в summary для человека. Классы mandatory decisions определяются детерминированной policy; полный diff остаётся доступным; нужны seeded/random audits и измерение override/missed-decision rate.

### 3.2. Полная Ansible semantics недооценена

Произвольный Ansible включает:

- Jinja expressions, filters и lookups;
- complex variable precedence;
- runtime `register` и `set_fact`;
- dynamic includes;
- handlers, batching, `listen`, `flush_handlers`, failures и `force_handlers`;
- shell/command;
- collection modules и versioned Python behavior;
- dynamic inventory;
- multi-host execution, delegation и rollout semantics;
- внешние системы и OS-level effects.

Попытка построить общий sound analyzer является многолетним и постоянно поддерживаемым проектом. Поэтому текущий проект не анализирует произвольный Ansible и не обещает полную семантику.

### 3.3. Abstraction leakage

Из недостижимости `service.restart(postgresql)` в Ansible effect graph нельзя вывести, что PostgreSQL физически не перезапустится или не потеряет availability. Возможны:

- package scriptlets;
- systemd dependencies;
- shell scripts;
- kernel/OOM behavior;
- resource exhaustion;
- внешние actors.

Корректный static claim:

> Для данного profile и scenario, во всех путях поддерживаемой effect model не достижим явно смоделированный Ansible effect над protected PostgreSQL service set.

Runtime claim имеет другую quantification:

> В конкретном AlmaLinux environment во время конкретного execution не наблюдалось изменение PID/start timestamp PostgreSQL.

Они дополняют друг друга, но не образуют простую линейную лестницу «слабое → сильное».

### 3.4. Opaque constructs заразны относительно obligation

`shell`, `command`, dynamic include или unresolved service name создают opaque node. Он не обязательно обнуляет весь playbook, но загрязняет каждую obligation, чей relevant slice проходит через этот node и чьи effects пересекаются с capability envelope.

Ключевая эмпирическая метрика — obligation-relative `OpaqueCone`, а не только общий процент unsupported tasks.

### 3.5. Экономика неизвестна

Claim «1000 specs за минуты» удалён. Важны:

- static/model/container/VM resolution by property class;
- p50/p95 latency;
- compute cost;
- review effort;
- analyzer build/maintenance cost;
- real-defect escape rate;
- false-positive burden.

Resolution rate нельзя считать по количеству автоматически сгенерированных trivial obligations. Нужна стратификация по property class и severity, честные знаменатели и comparison against existing lint/integration/test-selection baselines.

## 4. Current research formulation

Текущая постановка:

> Исследование проверяет независимо, повышает ли invariant- и counterexample-first protocol полноту LLM-планирования инфраструктурных изменений и существует ли в реальных Ansible-ролях достаточно большой и экономически ценный фрагмент для obligation-directed effect analysis. Только при положительных результатах строится узкий analyzer; только после измерения его точности исследуется автоматический выбор runtime verification jobs.

Это umbrella project с несколькими независимыми tracks.

### Track P — Planning

Проверяет plain planning против protocol variants:

```text
P0: implementation-first
P1: assumptions + constraints + invariants
P2: P1 + failure model + counterexample attack + lifecycle
```

Primary concerns:

- critical obligation recall;
- invalid/vacuous proposal rate;
- silent scope narrowing;
- human review time;
- LLM run-to-run variance;
- expert disagreement.

### Track G — Governance

Проверяет, можно ли безопасно использовать LLM proposals при human/policy authority.

Mandatory human/policy review classes включают:

- scope exclusions;
- severity changes;
- waivers;
- protected resource set changes;
- acceptance of opaque contracts;
- promotion of proposed claim to authoritative.

### Track A — Analyzability

Проверяет реальные roles as-is без переписывания. Structural profiler должен видеть:

- modules/FQCN;
- handlers, notify/listen;
- static/dynamic includes;
- loop sources;
- variable sources;
- shell/command;
- lookups/custom filters;
- collection modules;
- `delegate_to`, `run_once`, multi-host constructs.

Для expert-authored obligation строится structural slice и `OpaqueCone`.

### Track D — Detection

Строится только при достаточном analyzability/economic ceiling. Узкий analyzer ориентирован прежде всего на:

- handler/service effect reachability;
- forbidden file writes;
- protected resource sets;
- required notification paths;
- secret file permissions.

Primary defect corpus:

- реальные ошибки LLM;
- historical fixes;
- incidents/postmortems;
- expert-seeded realistic defects.

Mutants используются вторично.

### Track E — Economics

Изучается только после measurement backend accuracy. Routing рассматривается как выбор набора verification jobs, а не обязательная линейная escalation каждой obligation.

Нужны measured coverage, reliability, tail latency, assertion-level reporting и robustness margin.

## 5. Evidence model — текущая позиция

Нужно разделять три уровня.

### Backend conclusion

```text
PROVEN_WITHIN_MODEL
CONCRETE_COUNTEREXAMPLE
POSSIBLE_COUNTEREXAMPLE
INCONCLUSIVE
BACKEND_ERROR
```

### Evidence record

Хранит:

- claim/obligation identity;
- subject digest;
- assumptions;
- scope;
- exclusions;
- quantification;
- environment fidelity;
- backend и semantics version;
- dependency set;
- freshness.

### Policy decision

```text
ALLOW
BLOCK
REQUIRE_REVIEW
REQUIRE_RUNTIME_TEST
```

Policy decision не является частью самого доказательства.

Evidence — многомерный объект, а не линейный уровень. Static universal result в узкой модели и один runtime observation в реалистичной VM часто несравнимы.

## 6. Invalidation

Evidence является функцией от:

```text
source
specification
assumptions
inventory/facts
ansible-core
collections lock
analyzer
semantics pack
policy
runtime environment
```

Изменение значимого dependency переводит evidence в `STALE`. Предусмотрены состояния:

```text
VALID
STALE
REVOKED
SUPERSEDED
```

Полная schema отложена, но dependency/freshness semantics должны присутствовать с первой версии любого evidence artifact.

## 7. Cohorts

Результаты нельзя смешивать.

### Legacy as-is

Измеряет применимость к существующему Ansible, включая shell, collections и dynamic constructs.

### Greenfield constrained profile

Измеряет потенциальную пользу coding standard:

- no arbitrary shell;
- static includes;
- typed role arguments;
- pinned collections;
- explicit handlers;
- declared ownership boundaries.

Стоимость переписывания legacy под profile учитывается отдельно.

### Controlled benchmark

Используется для correctness algorithms и isolated constructs, но не для external validity.

## 8. Flagship example after scope correction

Для `postgres_exporter` claims распределяются по backend.

| Claim | Реалистичный backend |
|---|---|
| Нет достижимого явного restart/stop/reload PostgreSQL | narrow effect analysis |
| Config change уведомляет правильный handler | effect/handler analysis |
| Credential file заявлен с `0600` | static check + runtime inspection |
| Second converge имеет `changed=0` | container/VM converge |
| PostgreSQL process не перезапустился в сценарии | VM observation |
| `pg_up == 1` | PostgreSQL integration test |
| DB user не `SUPERUSER` | database query/integration |
| Exporter никогда не повлияет на availability PostgreSQL | не устанавливается данным проектом |

Remote PostgreSQL и `delegate_to` являются explicit multi-host cases. Для первого analyzer profile они дают `OUT_OF_PROFILE_MULTI_HOST`, но остаются в global analyzability denominator.

## 9. Related work and novelty boundary

Проверенные направления перечислены в `docs/research/related-work.md`.

Основные ограничения новизны:

- Astrogator уже реализует formal query language, State Calculus и symbolic verification для небольшого Ansible fragment;
- Rehearsal формализует Puppet и проверяет determinacy/idempotency;
- GLITCH использует polyglot IR для IaC smell detection;
- APME реализует parse-once/fan-out static and semi-static validation;
- Ansible Risk Insight строит static execution-oriented structures и variable context.

Следовательно, исследовательский вклад проекта — прежде всего эмпирический:

- planning protocol evaluation;
- real-role opaque-cone study;
- real LLM defect corpus;
- scoped evidence discipline;
- economic comparison.

Generic validator platform сама по себе является engineering, не главным научным вкладом.

## 10. Current sequence

```text
Phase 0:
  repository memory and research harness design

E0a-P:
  planner calibration pilot

E0a-A:
  analyzability calibration pilot

E0b:
  confirmatory preregistration based on pilot variance/baseline

E1/E2:
  confirmatory planning and analyzability studies

E3:
  real defect corpus

E4:
  narrow effect analyzer, conditional on E2

E5:
  prospective shadow validation, conditional on E4

E6:
  routing economics, conditional on measured backend quality
```

## 11. Current hard constraints

- Не строить platform ради ощущения прогресса.
- Не назначать confirmatory thresholds до calibration pilot.
- Не выдавать point estimate без uncertainty.
- Не использовать defect-enriched corpus для production precision claims.
- Не позволять LLM определять полный набор того, что увидит human reviewer.
- Не превращать declared script contract или single runtime trace в universal semantics.
- Не удалять multi-host и out-of-profile cases из global denominator.
- Не использовать chat history как единственную память проекта.

## 12. Open research questions

1. Как операционализировать `critical obligation` с приемлемым expert agreement?
2. Как выбирать task corpus без утечки между pilot и confirmatory phases?
3. Какая structural precision нужна profiler, чтобы opaque-cone result был полезен, но не превратился в verifier?
4. Как задавать Roots/Sinks для разных property classes?
5. Доступны ли artifacts Astrogator и насколько воспроизводимы результаты на production-like roles?
6. Можно ли переиспользовать APME/ARI без создания собственной generic parsing platform?
7. Как оценить cost ceiling до реализации analyzer?
8. Кто является реальным потребителем evidence: PR reviewer, CI gate, auditor или research evaluator?
9. Когда single-host profile перестаёт быть полезным из-за multi-host prevalence?
10. Как версионировать будущие semantics packs и инвалидировать evidence без чрезмерной полной перепроверки?

## 13. What a new session should do

После чтения этого файла новая сессия должна:

1. открыть `docs/current-focus.md`;
2. определить, относится задача к bootstrap, `E0a-P` или `E0a-A`;
3. не возвращаться к проектированию большого engine без нового owner decision;
4. сохранить новые устойчивые выводы в docs/ или ADR;
5. явно отметить, что является fact, inference, proposal и unresolved decision.
