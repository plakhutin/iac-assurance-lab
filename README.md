# iac-assurance-lab

Исследовательская лаборатория по **invariant-first планированию Infrastructure-as-Code**, анализируемости реальных Ansible-ролей и построению честного evidence для CI-проверок.

Проект не заявляет полную формальную верификацию Ansible. Текущая цель — проверить две независимые гипотезы:

1. повышает ли protocol `assumptions → invariants → failure model → counterexamples` полноту планирования LLM;
2. существует ли в реальных Ansible-ролях достаточно большой и экономически полезный фрагмент для obligation-directed effect analysis.

Разработка полноценного Semantic Verification Engine отложена до результатов калибровочных и подтверждающих экспериментов.

## Текущий статус

**Фаза:** bootstrap репозитория и подготовка calibration pilot.

Ближайшие направления:

- `E0a-P` — пилот plain planning против invariant-first и counterexample-first planning;
- `E0a-A` — пилот structural analyzability и opaque-cone на legacy Ansible-ролях;
- формирование corpus и схемы экспертной разметки;
- уточнение related work и возможностей повторного использования существующих инструментов.

## Начать здесь

1. [AGENTS.md](AGENTS.md) — обязательные инструкции для AI-агентов и чистых сессий.
2. [docs/current-focus.md](docs/current-focus.md) — текущее состояние и следующий лучший шаг.
3. [docs/project/charter.md](docs/project/charter.md) — миссия, границы и нецели.
4. [docs/project/research-state.md](docs/project/research-state.md) — консолидированная память проекта.
5. [docs/README.md](docs/README.md) — оглавление документации.

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
└── .github/
```

Код, corpus и profiler добавляются только после фиксации форматов пилотных экспериментов и явного решения о реализации.
