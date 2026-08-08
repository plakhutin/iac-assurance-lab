# Project charter

**Project:** `iac-assurance-lab`  
**Status:** active research  
**Primary domain:** Ansible-based Infrastructure-as-Code  
**Initial user:** DevOps/SRE engineer reviewing or implementing an Ansible change

## Mission

Исследовать, может ли invariant-first и counterexample-first подход сделать LLM-assisted разработку Infrastructure-as-Code более полной, проверяемой и экономически оправданной без ложного обещания полной формальной верификации реальной инфраструктуры.

## Core problem

Обычный LLM workflow быстро переходит от задачи к implementation decomposition:

```text
Task → tasks/files/templates/handlers → generated code
```

В результате часто пропускаются:

- assumptions и unknowns;
- safety boundaries;
- lifecycle cases;
- failure modes;
- counterexamples;
- functional verification obligations;
- границы того, что конкретная проверка действительно подтверждает.

Проект исследует более строгий workflow:

```text
Task
→ context and authority
→ assumptions / constraints
→ invariants and functional claims
→ failure model
→ counterexample search
→ verification obligations
→ implementation
→ scoped evidence
```

## Primary research questions

1. Повышает ли explicit invariant/counterexample protocol полноту LLM planning при приемлемой стоимости human review?
2. Какая часть важных obligations реальных Ansible-ролей имеет пустой obligation-relative opaque cone и потенциально доступна ограниченному effect analysis?
3. Ловит ли узкий analyzer реальные ошибки LLM и исторические дефекты с достаточной precision/recall?
4. Снижает ли комбинация static и runtime evidence стоимость проверки без неприемлемого роста high-severity defect escapes?
5. Какие governance controls нужны, чтобы LLM proposals не стали скрытым источником authority и silent scope narrowing?

## Scope

На первом этапе:

- Ansible roles и playbooks;
- преимущественно AlmaLinux/RHEL 9;
- одна зафиксированная версия `ansible-core` на конкретный experiment;
- concrete inventory snapshots;
- single-host/linear execution profile для потенциального analyzer;
- LLM planning protocols;
- expert-authored gold/annotation set;
- structural profiling;
- handlers, notify/listen, include/import, variable sources и opaque constructs;
- evidence scope, assumptions, exclusions и freshness как предмет модели.

## Non-goals

Проект сейчас не ставит целью:

- формально верифицировать произвольный Ansible;
- моделировать полную семантику Linux, RPM/DEB, systemd, PostgreSQL и сети;
- доказать availability production-системы по YAML;
- заменить Molecule, integration tests или production observability;
- полностью устранить human review спецификаций;
- сделать LLM источником требований;
- построить generic AI agent orchestration platform;
- немедленно создать blocking CI gate;
- заявить, что `1000 specs` проверяются за минуты без измерений.

## Foundational principles

### Authority before automation

Requirements, organization policies, ADR и human decisions имеют более высокий статус, чем LLM proposals.

### Claims must be scoped

Доказательство отсутствия явного Ansible-effect не равно доказательству отсутствия system-level последствия.

### Unknown is a valid result

Неподдерживаемая или непрозрачная семантика не интерпретируется оптимистично.

### Research before platform

Сначала измеряются planning value, analyzability и economic ceiling. Реализация analyzer и router условна.

### Negative results are useful

Высокий opaque-cone rate или отсутствие улучшения planning protocol являются допустимым результатом и могут остановить отдельный track.

### Legacy and greenfield are different populations

Роли as-is и роли, написанные под analyzable profile, оцениваются отдельно.

## Expected outputs

Возможные результаты проекта:

1. проверенный invariant/counterexample planning protocol;
2. открытый или внутренний benchmark/corpus реальных Ansible задач и дефектов;
3. structural analyzability profiler;
4. empirical map opaque constructs и их fan-out;
5. узкий effect analyzer для handler/service/file properties — только при положительном gate;
6. evidence schema и CI integration — только если появляется реальный потребитель и доказанная экономика;
7. отрицательный результат с ясными границами применимости.

## Success definition

Проект успешен не тогда, когда создан большой engine, а когда получен честный ответ на основные research questions и принято обоснованное решение:

- продолжать конкретный track;
- сузить его до специализированных checks;
- использовать результат только как advisory;
- либо прекратить направление до больших затрат.
