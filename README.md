# iac-assurance-lab

Исследовательская лаборатория по **invariant-first планированию Infrastructure-as-Code**, анализируемости реальных Ansible-ролей и построению честного evidence для CI-проверок.

Проект не заявляет полную формальную верификацию Ansible. Текущая цель — проверить две независимые гипотезы:

1. повышает ли protocol `assumptions → invariants → failure model → counterexamples` полноту планирования LLM;
2. существует ли в реальных Ansible-ролях достаточно большой и экономически полезный фрагмент для obligation-directed effect analysis.

Разработка полноценного Semantic Verification Engine отложена до результатов калибровочных и подтверждающих экспериментов.

## Текущий статус

**Фаза:** `E0a-P` executable protocol → `DRY-00` preflight.

Уже подготовлены:

- точные protocol arms `P0/P1/P2`;
- task-selection и expert-annotation manual;
- runbook, canonical data contract и reproducible prompt components;
- controlled synthetic `DRY-00` task package с authority boundary и prompt-injection fixture.

Текущий следующий шаг описан в [docs/current-focus.md](docs/current-focus.md): проверить digests после checkout, провести independent expert elicitation для `DRY-00`, freeze dry-run gold и только затем получить по одному P0/P1/P2 output.

Параллельный трек `E0a-A` по structural analyzability остаётся запланированным, но сейчас не является active implementation focus.

## Начать здесь

1. [AGENTS.md](AGENTS.md) — обязательные инструкции для AI-агентов и чистых сессий.
2. [docs/current-focus.md](docs/current-focus.md) — текущее состояние и следующий лучший шаг.
3. [docs/project/charter.md](docs/project/charter.md) — миссия, границы и нецели.
4. [docs/project/research-state.md](docs/project/research-state.md) — консолидированная память проекта.
5. [docs/README.md](docs/README.md) — оглавление документации.
6. [docs/experiments/E0a-P/README.md](docs/experiments/E0a-P/README.md) — исполнимый protocol package.
7. [experiments/E0a-P/README.md](experiments/E0a-P/README.md) — фактические protocol/task artifacts.

## Исследовательские треки

| Трек | Вопрос |
|---|---|
| `P` — Planning | Улучшает ли invariant/counterexample protocol планирование LLM? |
| `G` — Governance | Можно ли безопасно использовать LLM proposals при human/policy authority? |
| `A` — Analyzability | Насколько реальные Ansible-роли доступны ограниченному effect analysis? |
| `D` — Detection | Ловит ли узкий analyzer реальные дефекты с приемлемой точностью? |
| `E` — Economics | Снижает ли выбор verification jobs стоимость без роста серьёзных escapes? |

Треки независимы: провал LLM-planning не уничтожает анализатор с human- или policy-authored obligations, а провал анализатора не обесценивает planning protocol.

## Базовое эпистемическое правило

Любой результат должен отвечать на четыре вопроса:

```text
Что утверждается?
При каких assumptions?
В пределах какой модели и scope?
Каким evidence это подтверждено?
```

Формулировка `PROVEN` без квалификации scope запрещена.

## Структура

```text
.
├── AGENTS.md
├── CONTRIBUTING.md
├── README.md
├── docs/
│   ├── README.md
│   ├── current-focus.md
│   ├── project/
│   ├── decisions/
│   ├── experiments/
│   ├── research/
│   ├── templates/
│   └── worklog/
├── experiments/
│   └── E0a-P/
│       ├── protocol/
│       └── tasks/DRY-00/
└── .github/
```

Research harness и corpus artifacts добавляются только для конкретного experiment need. Общий analyzer, profiler и production platform по-прежнему отложены до experimental gates.
