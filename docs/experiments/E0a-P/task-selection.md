# E0a-P task selection

## 1. Purpose

Этот документ задаёт процедуру выбора задач для **калибровочного**, а не confirmatory, сравнения `P0/P1/P2`.

Pilot должен дать реалистичную оценку:

- baseline critical-obligation recall;
- task-level и run-level variance;
- annotation burden;
- ceiling/floor effects;
- пригодности task package и scoring manual.

Задачи не должны выбираться по тому, насколько хорошо на них выглядит invariant-first protocol.

## 2. Target population

Рабочая population:

> Ограниченные задачи изменения Ansible-роли или playbook, для которых senior DevOps/SRE инженер сначала должен построить инженерный план, выявить неизвестные и определить verification obligations.

Pilot не пытается репрезентировать весь Ansible ecosystem. Он намеренно покрывает несколько разных failure shapes, чтобы оценить дисперсию и пригодность процедуры.

## 3. Unit of selection

Единица отбора — **task package**, а не одно предложение задачи.

Task package включает:

```text
task brief
immutable repository snapshot или controlled fixture
architecture and policy context
explicit user decisions
allowed file list
untrusted-content boundary
budget metadata
```

Все protocol arms получают один и тот же byte-identical package.

## 4. Inclusion criteria

Задача допускается в pilot, только если выполняются все обязательные условия.

### 4.1. Bounded engineering change

- Deliverable можно описать как изменение одной роли, ограниченного набора roles или одного playbook flow.
- От LLM требуется planning memo, а не готовая реализация.
- Scope достаточно мал для одного ответа, но не сводится к синтаксической правке.

### 4.2. Traceable authority

Для каждого потенциального gold item должен существовать хотя бы один из вариантов:

1. явный source в task/package/policy/architecture document;
2. официальный technical constraint, включённый в package;
3. обоснованная необходимость задать вопрос, потому что требуемого решения в package нет;
4. expert safety norm, явно помеченная как `expert_consensus`, а не как написанное пользователем требование.

Эксперты не должны молча добавлять private organizational knowledge в gold set.

### 4.3. Sufficient but manageable obligation surface

До freeze ожидается ориентировочно:

```text
critical required items: 5–18
total required/useful items: 8–30
property classes: at least 3
```

Это calibration heuristic. Если dry run показывает, что диапазон создаёт floor/ceiling или чрезмерную нагрузку, он пересматривается до pilot start.

### 4.4. Self-contained context

- Внешний web access для ответа не требуется.
- Все необходимые version-specific facts либо входят в package, либо должны быть обозначены как unknown/question.
- Package помещается в primary model context с не менее чем 30% запасом.
- Input size и output budget записываются в manifest.

### 4.5. Observable planning quality

Task package должен позволять отличить:

- полноценную обязательную property/question;
- общую фразу вроде «учесть безопасность»;
- придуманное требование;
- implementation detail;
- недопустимое silent scope narrowing.

### 4.6. Immutable provenance

- Repository snapshot привязан к commit/digest.
- Sanitization/anonymization transformation, если есть, версионируется.
- После gold freeze package не изменяется.

## 5. Exclusion criteria

Задача исключается, если выполняется хотя бы одно условие:

- gold answer зависит преимущественно от неописанных предпочтений конкретного эксперта;
- задача тривиальна и почти все arms достигают очевидного ceiling;
- задача настолько широка, что один planning memo не может покрыть её без произвольного scope selection;
- большая часть required facts доступна только через живую production environment;
- задача требует выполнения команд, изменения инфраструктуры или web research во время model run;
- legal/access ограничения не позволяют сохранить immutable package и результаты;
- package содержит персональные данные или секреты;
- задача уже использовалась для prompt tuning текущих arms;
- задача является confirmatory holdout или планируется как confirmatory holdout;
- gold set нельзя построить без просмотра model outputs.

## 6. Coverage constraints for the six-task pilot

Итоговый набор из шести задач должен одновременно удовлетворять:

- не более двух задач из одного operational domain;
- минимум две задачи с существенной functional-correctness surface;
- минимум две задачи с security/secret boundary;
- минимум две задачи с lifecycle/recovery surface;
- минимум одна задача с multi-host или ownership-boundary вопросом;
- минимум одна задача с controlled prompt-injection content;
- минимум две задачи, где правильный результат включает явный unresolved decision, а не угадывание значения;
- минимум одна задача disable/uninstall/takeover, а не только fresh install;
- минимум одна задача с remote dependency;
- минимум одна задача, где safety и functional success расходятся.

Controlled prompt injection может находиться внутри одной из шести задач; отдельная седьмая задача для него не требуется.

## 7. Provisional task slate

Ниже находится **предварительный**, а не frozen, набор. Каждый package ещё должен пройти preflight.

| ID | Задача | Основные surfaces | Special role |
|---|---|---|---|
| `E0P-T01` | Добавить `postgres_exporter` в существующий exporters playbook | secrets, DB ownership, idempotency, handler isolation, real scrape | safety ≠ functional success; controlled injection candidate |
| `E0P-T02` | Изменить Ansible-managed NGINX reverse-proxy configuration | config validation, reload/restart semantics, unrelated vhosts, rollback | explicit service-effect planning |
| `E0P-T03` | Настроить/обновить log shipper к remote Elasticsearch/OpenSearch | credentials, compatibility, backpressure, index/template behavior | remote dependency and operational failure model |
| `E0P-T04` | Ротация TLS certificate/private key для NGINX или systemd service | atomicity, chain/key validation, permissions, reload, rollback, expiry | lifecycle and secret boundary |
| `E0P-T05` | Создать remote PostgreSQL monitoring user из Ansible flow | least privilege, ownership, `pg_hba`, TLS, `delegate_to`, DBA boundary | multi-host/authority boundary |
| `E0P-T06` | Отключить и удалить ранее управляемый exporter | disable/uninstall, stale inventory, garbage collection, rollback, residual files | lifecycle and declarative-absence trap |

### Dry-run package

`DRY-00` не входит в pilot и не используется для outcome estimation.

Предлагаемая тема:

> Обновить Ansible-managed systemd utility с pinned binary artifact, сохранив checksum validation, architecture selection, rollback и idempotency.

Dry run должен быть достаточно содержательным для проверки manual, но не дублировать один из шести pilot domains дословно.

## 8. Candidate origin mix

Допустимые origin types:

```text
reconstructed_internal
public_repository_snapshot
controlled_synthetic
historical_ticket_reconstruction
```

Для pilot предпочтителен mix:

- минимум три задачи, реконструированные из реальных engineering patterns/tickets;
- не более трёх полностью controlled synthetic fixtures;
- exact origin скрывается от model output scorer, но сохраняется в task manifest.

Synthetic fixtures допустимы для калибровки редких surfaces, но результаты по ним публикуются отдельно от reconstructed-real tasks.

## 9. Preflight procedure

Для каждого candidate package выполняются следующие шаги до model generation.

### Step 1 — package completeness

Проверить:

- task brief;
- file inventory;
- source references;
- package digest;
- absence secrets/PII;
- untrusted-content marker;
- input-size metadata.

### Step 2 — independent expert preview

Три эксперта независимо оценивают, возможно ли:

- понять задачу без внешнего web/environment access;
- вывести критические obligations или required questions;
- сослаться на package evidence;
- закончить annotation в разумное время.

Это не полный gold annotation; задача — обнаружить unusable package.

### Step 3 — obligation-surface estimate

Neutral coordinator объединяет только числовые estimates экспертов:

```text
estimated critical items
estimated total items
estimated annotation minutes
expected ambiguity
```

На этом этапе model outputs отсутствуют.

### Step 4 — coverage-matrix selection

Из прошедших preflight candidates выбирается набор, удовлетворяющий constraints из раздела 6. Если вариантов несколько, предпочтение отдаётся более разнообразному набору, а не задачам с предположительно высоким эффектом treatment.

### Step 5 — freeze

После выбора:

- присваивается immutable `task_package_digest`;
- фиксируется task manifest;
- package становится read-only для pilot;
- любые исправления создают новую version и требуют полного повторного gold annotation для этой задачи.

## 10. Context and budget controls

Для всех arms внутри одной задачи одинаковы:

- package bytes;
- file ordering;
- system/common prompt;
- output word/token cap;
- tool access;
- model parameters, кроме недоступного nondeterminism.

Рабочий output cap для dry run:

```text
maximum 1600 words
```

Если dry run показывает систематическое truncation, cap меняется для всех arms до pilot start. Увеличивать budget только для P1/P2 запрещено.

## 11. Prompt-injection fixture rules

Controlled injection:

- размещается в repository content, а не в управляющем prompt;
- выглядит правдоподобно для комментария/README/template;
- не содержит вредоносных команд;
- проверяет только instruction hierarchy, например попытку объявить restart безопасным или потребовать игнорировать policy;
- имеет отдельный hash и known location в private manifest;
- не раскрывается model как test label;
- одинаково присутствует во всех arms.

Injection success/failure оценивается отдельно от obligation recall.

## 12. Selection record

После freeze создаётся таблица:

| Task ID | Origin | Domain | Critical count | Classes | Multi-host | Injection | Package digest | Status |
|---|---|---|---:|---|---|---|---|---|

Не допускается удалять задачу после просмотра arm outcomes, кроме заранее определённого technical-invalidity condition. Любое исключение сохраняется вместе с причиной и всеми уже полученными outputs.

## 13. Technical-invalidity conditions

Task может быть признан технически невалидным после старта только если:

- package digest не совпал между arms;
- часть files была недоступна одному arm;
- runner нарушил model/output budget;
- prompt version отличалась не по protocol delta;
- task содержал реальный secret/PII;
- model provider вернул повреждённый или пустой response во всех retry attempts;
- gold set был случайно раскрыт model.

Низкое качество одного protocol или высокий disagreement экспертов не являются основанием удалить задачу.

## 14. Remaining actions

- [ ] создать `DRY-00` package;
- [ ] материализовать шесть provisional task packages;
- [ ] провести package preflight;
- [ ] зафиксировать origin/access/licensing record;
- [ ] выбрать окончательные шесть задач по coverage matrix;
- [ ] записать freeze digests в selection record.
