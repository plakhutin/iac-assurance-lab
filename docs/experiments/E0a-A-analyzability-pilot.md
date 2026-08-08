# E0a-A: Real-role analyzability calibration pilot

- **Status:** draft
- **Type:** exploratory calibration pilot
- **Track:** A — Analyzability
- **Confirmatory use:** prohibited

## 1. Objective

Оценить, существует ли практически измеримый analyzable fragment в реальных legacy Ansible roles as-is, и проверить feasibility obligation-relative opaque-cone analysis без реализации полноценного semantic verifier.

Pilot должен ответить на калибровочные вопросы:

- какие unsupported/opaque constructs реально доминируют;
- насколько часто critical obligations имеют пустой opaque cone;
- сколько obligations загрязняет один opaque node;
- можно ли построить useful structural slice с ограниченной семантикой;
- какова оптимистичная верхняя граница потенциально избегаемой runtime-проверки;
- какой объём corpus нужен confirmatory study.

Pilot не доказывает correctness roles и не измеряет accuracy будущего analyzer.

## 2. Population and cohorts

### Primary pilot cohort: legacy as-is

Предварительно 12–15 реальных ролей без переписывания под analyzable profile.

Роли должны представлять разные конструкции и домены:

- exporter/systemd;
- NGINX/reverse proxy;
- log shipper;
- package/repository management;
- TLS/certificate lifecycle;
- database user/privileges;
- firewall/SELinux;
- application service deployment;
- shared handlers;
- shell-heavy role;
- multi-host orchestration or delegation;
- role with community collections.

### Optional descriptive cohort: greenfield constrained

Может быть добавлена позже только как отдельная когорта. Её метрики нельзя объединять с legacy-as-is.

### Controlled benchmark

Маленькие synthetic roles используются только для проверки profiler mechanics и не входят в external-validity result.

## 3. Inclusion criteria

Для каждой legacy role должны быть доступны:

- immutable repository commit;
- role/playbook entrypoint;
- минимально необходимый inventory/profile context;
- license/access decision;
- возможность экспертно сформулировать хотя бы несколько значимых obligations;
- достаточно полный dependency metadata для повторного разбора.

## 4. Exclusion policy

Роль не исключается только потому, что содержит:

- `shell`/`command`;
- dynamic include;
- custom collection;
- lookup/filter;
- multi-host constructs;
- unresolved variables.

Именно эти признаки являются предметом измерения. Исключение допускается только по access/legal/data-quality причинам и должно быть задокументировано.

## 5. Structural profiler scope

Profiler — не verifier. Он должен извлечь структуры, необходимые для первичного slicing:

### Nodes

- play;
- role invocation;
- task;
- block/rescue/always;
- handler;
- import/include;
- variable definition/use;
- loop;
- module call;
- opaque action.

### Edges

- sequential/control approximation;
- static include/import;
- unresolved dynamic include;
- notify/listen/handler resolution;
- variable source/use;
- loop source;
- role/task ownership;
- delegation/multi-host marker.

### Attributes

- module FQCN;
- file/line source;
- `when` expression presence and resolvability class;
- `changed_when`/`failed_when`;
- `no_log`;
- `delegate_to`, `run_once`, `serial`, strategy markers;
- collection and version metadata where available;
- static/concrete/symbolic/unresolved target class.

Не требуется строить полный runtime CFG или Jinja interpreter.

## 6. Opaque classification

Initial classes:

```text
OPAQUE_SHELL
OPAQUE_COMMAND
OPAQUE_CUSTOM_MODULE
UNRESOLVED_DYNAMIC_INCLUDE
UNRESOLVED_LOOKUP
UNRESOLVED_FILTER
UNRESOLVED_VARIABLE_TARGET
UNBOUNDED_LOOP_SOURCE
OUT_OF_PROFILE_MULTI_HOST
OUT_OF_PROFILE_EXECUTION_STRATEGY
UNKNOWN_COLLECTION_VERSION
```

Opaque node получает conservative capability envelope, например:

```yaml
kind: OPAQUE_SHELL
capabilities:
  - filesystem
  - process
  - service
  - network
scope: host
```

Capability envelope — analysis assumption, не утверждение о фактическом поведении.

## 7. Obligation model

Obligations формулируются людьми/policy, а не выводятся только profiler.

Минимальные поля:

```yaml
id: ROLE-01-OBL-001
statement: Exporter configuration change must not cause an explicit PostgreSQL service action
class: safety
severity: critical
claim_level: ansible_effect
scenario_roots:
  - input: exporter_configuration
    mutation: distinct_value
sinks:
  - operation: service.restart
    target: protected.postgresql
  - operation: service.stop
    target: protected.postgresql
authority:
  type: expert_policy
```

Property classes:

- safety;
- functional;
- idempotency;
- security/secret flow;
- recovery;
- lifecycle;
- noninterference.

Functional obligations остаются в global denominator, даже если structural profiler не может их разрешить.

## 8. Opaque-cone definition

Для obligation `o`:

```text
Roots(o)
  scenario inputs/mutations or entry conditions

Sinks(o)
  effect/state targets that can satisfy or violate the obligation

Slice(o)
  structural paths connecting roots/entrypoint to relevant sinks
  through tasks, variables, includes, notifications and handlers

OpaqueCone(o)
  nodes in Slice(o) whose semantics are opaque, unresolved
  or outside the declared profile
```

Формально:

```text
OpaqueCone(o) =
  { n ∈ Slice(o) |
    class(n) ∈ {OPAQUE, UNRESOLVED, OUT_OF_PROFILE} }
```

Поскольку profiler не является sound verifier, `empty OpaqueCone` означает только structural candidate for analysis, а не доказанную разрешимость property.

## 9. Pilot procedure

1. Зафиксировать repository commits и metadata.
2. Эксперты независимо формулируют important obligations или утверждают policy-derived baseline.
3. Profiler строит structural graph.
4. Для каждой obligation задаются roots/sinks.
5. Строится candidate slice и opaque cone.
6. Эксперт вручную проверяет plausibility slice на pilot subset.
7. Фиксируются opaque nodes, fan-out и minimal opaque cuts.
8. Для runtime obligations указывается baseline job и ориентировочная стоимость.
9. Рассчитывается optimistic cost-avoidance ceiling без claims об accuracy analyzer.

## 10. Metrics

### Global empty-cone rate

```text
number of obligations with empty candidate opaque cone
──────────────────────────────────────────────────────
all expert-authored obligations
```

В знаменателе остаются multi-host, functional и out-of-profile cases.

### Conditional empty-cone rate

Считается только внутри declared analyzable profile и публикуется отдельно.

### Opaque fan-out

Для каждого opaque node:

```text
number of obligations whose cone contains the node
```

### Minimal opaque cut

Минимальный набор opaque nodes, устранение/контрактирование которых структурно открыло бы obligation для дальнейшего анализа.

### Property/severity matrix

Результаты публикуются раздельно по:

- property class;
- critical/high/medium severity;
- role/domain;
- legacy vs optional greenfield cohort.

### Structural profiler quality

На ручной подвыборке:

- missing relevant edges;
- spurious edges;
- handler resolution errors;
- include classification errors;
- variable-source classification errors.

Это не полноценная precision/recall analyzer, но без проверки graph quality opaque-cone metrics бессмысленны.

### Optimistic cost-avoidance ceiling

Для obligations с пустым candidate cone оценивается стоимость runtime jobs, которые теоретически могли бы быть заменены или сокращены.

Это upper bound. Из него не вычитается runtime test до появления analyzer accuracy.

## 11. Honest reporting

Запрещено:

- исключать hard roles из знаменателя;
- считать одну role с 50 trivial file-mode obligations эквивалентной одной critical functional obligation;
- объединять legacy и greenfield results;
- называть empty cone `PROVEN`;
- считать declared script contract semantic truth;
- выдавать runtime trace за universal effect model;
- игнорировать стоимость будущих semantics packs и maintenance.

## 12. Pilot outputs

До confirmatory E0b должны быть получены:

1. corpus inclusion manual;
2. structural graph schema v0;
3. opaque classification manual;
4. obligation/root/sink annotation guide;
5. distribution opaque constructs by role;
6. candidate empty-cone and fan-out estimates;
7. manual graph-quality findings;
8. estimate variance/clustering across roles;
9. sample-size and sampling strategy proposal;
10. optimistic economic ceiling and explicit assumptions;
11. decision whether APME/ARI or another parser can be reused.

## 13. Stop/redesign conditions

Redesign выполняется, если:

- experts cannot define roots/sinks consistently;
- structural graph misses common handler/include paths;
- repository metadata is too incomplete for reproducibility;
- candidate slicing requires nearly full Ansible semantics;
- a small number of global opaque nodes contaminates almost all critical obligations;
- optimistic cost ceiling is already below conservative implementation/maintenance cost.

Последние два outcomes могут быть честным отрицательным результатом, а не поводом переписать corpus под красивую метрику.

## 14. Open tasks

- [ ] определить 12–15 legacy role candidates;
- [ ] определить data-access/licensing rules;
- [ ] выбрать parser/frontend candidates;
- [ ] разработать structural schema v0;
- [ ] разработать opaque capability taxonomy;
- [ ] определить expert obligation workflow;
- [ ] подготовить одну controlled role для dry run;
- [ ] определить baseline runtime-job cost model;
- [ ] описать ручную проверку graph quality.

## 15. Change log

- 2026-08-08 — initial draft created during repository bootstrap.
