# Contributing

`iac-assurance-lab` находится в исследовательской стадии. Главная цель изменений — повышать проверяемость проекта, а не увеличивать количество кода.

## Before starting

Прочитай:

1. `AGENTS.md`;
2. `docs/current-focus.md`;
3. `docs/project/research-state.md`;
4. релевантный experiment protocol или ADR.

## Branches

Не работай напрямую в `main` без явного решения владельца.

Рекомендуемые имена:

```text
bootstrap/<topic>
docs/<topic>
research/<topic>
experiment/<id>-<topic>
profiler/<topic>
fix/<topic>
```

## Change types

### Research/documentation

Должно быть ясно:

- что является fact;
- что является inference;
- что является proposal;
- что является approved decision;
- какой source/authority используется.

### Experiment protocol

Не смешивай calibration и confirmatory phases. После preregistration любые изменения protocol записываются как deviations.

### Code/profiler

До добавления implementation укажи:

- какой experiment need он закрывает;
- почему существующий tool нельзя переиспользовать;
- expected inputs/outputs;
- validation strategy;
- границы claims.

## Commit messages

Используй короткие сообщения в imperative/conventional стиле:

```text
docs: define planner pilot
research: add Astrogator baseline
profiler: extract handler notifications
fix: preserve unresolved includes
```

## Pull request expectations

PR должен содержать:

- цель и связь с current focus;
- список изменённых durable decisions;
- scope и explicit non-goals;
- verification performed;
- unresolved risks;
- обновление project memory, если изменился research state.

## Review checklist

- [ ] Change соответствует текущей фазе проекта.
- [ ] LLM proposal не представлен как authority.
- [ ] Claims квалифицированы scope/assumptions/exclusions.
- [ ] Нет silent denominator или cohort manipulation.
- [ ] Multi-host/out-of-profile cases не исчезли из global metrics.
- [ ] Exploratory result не назван confirmatory.
- [ ] Related-work claims имеют первичный source.
- [ ] Internal links and docs index актуальны.
- [ ] `docs/current-focus.md` обновлён при изменении следующего шага.

## Licensing

Лицензия проекта пока не выбрана. Не добавляй LICENSE или third-party corpus без отдельного решения владельца и проверки условий использования.
