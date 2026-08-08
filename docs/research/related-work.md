# Related work and novelty boundary

**Last reviewed:** 2026-08-08  
**Rule:** первичные источники и официальные repositories предпочтительнее обзоров.

Этот файл не является общей библиографией IaC. Он фиксирует работы, которые непосредственно ограничивают claims и engineering novelty проекта.

## 1. Astrogator

- Paper: [Towards Formal Verification of LLM-Generated Code from Natural Language Prompts](https://arxiv.org/abs/2507.13290)
- Domain: LLM-generated Ansible
- Authors: Aaron Councilman et al.
- Status: arXiv preprint, 2025

### What it contributes

Astrogator уже реализует значительную часть первоначально предполагаемого formal core:

- human-reviewable Formal Query Language;
- State Calculus для представления side effects;
- compiler/translation для Ansible fragment;
- symbolic interpreter;
- unification-based verification;
- Knowledge Base для system-specific dependencies.

Авторы сообщают evaluation на 21 code-generation task с примерно 83% принятия корректных и 92% отклонения некорректных программ.

### Important limitations for this project

- benchmark состоит из маленьких Ansible programs, а не production roles;
- arbitrary `shell`/`command` не входят в поддержанный fragment;
- handlers и ряд control constructs находятся за пределами evaluation scope;
- основной источник ошибочно принятых программ связан с недоопределённостью formal query и дополнительными assumptions/actions;
- публичный официальный code artifact не подтверждён в текущем обзоре.

### Consequence

Нельзя заявлять новизной саму идею formal query + symbolic Ansible verification. Открытый вопрос проекта — external validity на real roles, specification authority, opaque cones и экономика.

### Planned use

- paper baseline;
- replication target, если artifact станет доступен;
- источник taxonomy unsupported semantics;
- доказательство важности specification completeness как empirical issue.

## 2. Rehearsal

- Paper: [Rehearsal: A Configuration Verification Tool for Puppet](https://arxiv.org/abs/1509.05100)
- Venue: PLDI 2016
- Domain: Puppet configuration verification

### What it contributes

- formal model Puppet configurations;
- determinacy analysis;
- SMT-based checking;
- применение к idempotency и real-world configurations.

### Consequence

Формальная проверка configuration-management DSL и idempotency не является новой областью. Проект должен сравнивать свой scope, soundness claims и empirical design с Rehearsal, а не подавать state/effect verification как новую идею.

## 3. GLITCH

- Paper: [GLITCH: Automated Polyglot Security Smell Detection in Infrastructure as Code](https://arxiv.org/abs/2205.14371)
- Venue: ASE 2022
- Project page/artifact: [Software Reliability Lab](https://sr-lab.github.io/publication/2022/ASE/)

### What it contributes

- technology-agnostic intermediate representation;
- polyglot smell detection;
- Ansible, Chef и Puppet support в исходной работе;
- large-scale empirical analysis;
- reusable artifact.

### Consequence

Generic IaC IR и cross-language validators сами по себе не являются достаточной research novelty. GLITCH является baseline для structural representation и empirical evaluation discipline, но его smell detection отличается от obligation-directed effect reachability.

## 4. Ansible Forward / APME

- Repository: [ansible/apme](https://github.com/ansible/apme)

### What it contributes

APME позиционируется как multi-validator static/semi-static analysis platform:

```text
parse once
→ structured hierarchy
→ fan out to native/OPA/other validators
→ unified findings
```

Проект явно не обещает доказать достижение desired runtime state и не заменяет integration testing.

### Consequence

Не следует строить ещё один generic validator host до проверки возможности переиспользовать APME. Потенциальный вклад `iac-assurance-lab` — new validator/analysis и empirical evaluation, а не parse-once platform.

### Required follow-up

- проверить API/data model;
- проверить поддержку handlers/includes/variable context;
- оценить extensibility для obligation-relative slicing;
- оценить maturity и version stability;
- сравнить с прямым использованием Ansible parser/AST.

## 5. Ansible Risk Insight

- Repository: [ansible/ansible-risk-insight](https://github.com/ansible/ansible-risk-insight)

### What it contributes

ARI строит статическое execution-oriented представление Ansible content, работает с call context и variable information и применяет risk rules.

### Consequence

ARI является кандидатом frontend/profiler dependency для `E0a-A`. Перед собственной реализацией call/handler/variable graph необходимо проверить, насколько его structures можно использовать или адаптировать.

### Status

Candidate, not yet technically evaluated in this repository.

## 6. Existing practical baselines

### ansible-lint

- Repository: [ansible/ansible-lint](https://github.com/ansible/ansible-lint)

Baseline для syntax/style/policy checks и custom rules. Он не заменяет transition/effect analysis, но любые новые detectors нужно сравнивать с простыми lint rules.

### Molecule and integration tests

- Repository: [ansible/molecule](https://github.com/ansible/molecule)

Runtime baseline для converge/idempotence/verification scenarios. Экономический claim нового analyzer должен сравниваться с parallelized/cached container tests, а не с соломенной моделью `1 spec = 1 full VM`.

### OPA / Conftest

- [Open Policy Agent](https://www.openpolicyagent.org/)
- [Conftest](https://www.conftest.dev/)

Подходят для policy decision над structured input. OPA verdict не является доказательством system-level correctness; его роль — policy evaluation.

## 7. Evidence and assurance concepts

### in-toto and SLSA

- [in-toto](https://in-toto.io/)
- [SLSA](https://slsa.dev/)

Полезны как модели subject identity, provenance и attestations. Они не определяют истинность Ansible property, но влияют на будущий evidence record и dependency/freshness semantics.

### Assurance cases / GSN

Claim–argument–evidence структуры релевантны будущей модели assurance. Они не решают specification problem и не заменяют empirical validation.

## 8. Test selection

Если static layer разрешает мало obligations, verification router фактически становится test-selection system. Поэтому Track E обязан сравниваться с deterministic и predictive test selection, а не только с запуском полного suite.

Detailed review отложен до E5/E6, чтобы не проектировать routing до появления measured backend coverage.

## 9. Current novelty statement

На текущем этапе защищаемая новизна находится не в создании generic IR или symbolic interpreter, а в комбинации и эмпирической проверке:

1. invariant/counterexample-first LLM planning;
2. explicit separation of proposal and authority;
3. obligation-relative opaque-cone analysis на legacy roles;
4. real LLM/historical defect corpus;
5. scoped and invalidatable evidence;
6. economic comparison against existing static/runtime baselines.

## 10. Research hygiene

При добавлении источника ответь:

```text
What exactly is already solved?
What is the evaluated population?
What assumptions/unsupported features matter?
Is an artifact available and reproducible?
Does this reduce project novelty or implementation cost?
How will it be used: baseline, dependency, replication, or context?
```

Не использовать число из paper вне исходного population без явной оговорки.
