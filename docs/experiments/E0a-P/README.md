# E0a-P protocol package

- **Experiment:** `E0a-P` — Planner calibration pilot
- **Status:** executable-protocol draft
- **Type:** exploratory calibration
- **Confirmatory interpretation:** prohibited
- **Parent document:** [`../E0a-P-planner-pilot.md`](../E0a-P-planner-pilot.md)

Этот каталог превращает концептуальный draft E0a-P в исполнимую процедуру. Он фиксирует, как отбирать задачи, строить независимую экспертную разметку, запускать три protocol arms и сохранять результаты так, чтобы следующая чистая сессия могла продолжить работу без истории чата.

## Protocol documents

| Документ | Назначение |
|---|---|
| [`task-selection.md`](task-selection.md) | Population, inclusion/exclusion criteria, coverage matrix и provisional task slate |
| [`annotation-manual.md`](annotation-manual.md) | Определения obligation/assumption, gold-set workflow и правила scoring |
| [`prompt-protocols.md`](prompt-protocols.md) | Общий prompt envelope и точные treatment deltas `P0/P1/P2` |
| [`runbook.md`](runbook.md) | Dry run, randomization, execution, blinding, review и analysis workflow |
| [`data-contract.md`](data-contract.md) | Canonical YAML records для task, gold item, run и score |

## Pilot constants

Пока protocol не frozen, ниже находятся **рабочие значения для dry run и оценки трудоёмкости**, а не confirmatory design:

```text
pilot tasks:              6
separate dry-run task:    1
protocol arms:            P0, P1, P2
independent runs/cell:    4
planned model outputs:    6 × 3 × 4 = 72
independent gold experts: 3
output scorers:           2 per output
primary unit:             task
```

Изменения этих значений до первого pilot run допустимы, но должны попадать в change log родительского документа. После начала генерации нельзя менять число runs или состав задач на основании наблюдаемого качества отдельных arms.

## What is fixed by this package

- LLM output является предложением, а не authority.
- Gold set строится до просмотра model outputs.
- Задача, а не run или отдельная obligation, является primary unit of generalization.
- Все arms получают один task package, common security boundary, одинаковый output budget и одну модель.
- `P0`, `P1` и `P2` различаются только planning protocol instructions.
- Pilot оценивает baseline, variance, annotation burden и ceiling/floor effects; он не подтверждает H-P.
- Task packages pilot не переходят в confirmatory corpus по умолчанию.
- Полный список candidate items доступен экспертам; LLM не определяет, что попадёт в human review.

## What remains open

До статуса `pilot` необходимо выбрать и зафиксировать:

1. конкретные immutable task packages;
2. primary model и exact model identifier;
3. expert panel и output scorers;
4. execution harness;
5. randomization manifest;
6. storage location для raw outputs и annotations;
7. решение о public/private corpus material.

## Entry checklist for the dry run

- [ ] создан отдельный `DRY-00`, не входящий в pilot;
- [ ] task manifest проходит ручную проверку по `data-contract.md`;
- [ ] три эксперта выполнили independent elicitation по `DRY-00`;
- [ ] candidate universe нормализован без удаления minority items;
- [ ] scorers применили rubric к минимум трём тестовым ответам;
- [ ] exact common prompt и arm deltas имеют version/digest;
- [ ] runner сохраняет полный run manifest и raw response;
- [ ] reviewer видит task package и gold items, но не protocol label;
- [ ] измерение annotation/review time проверено на практике;
- [ ] все изменения manual после dry run занесены в change log.

## Promotion to `pilot`

Статус меняется с `executable-protocol draft` на `pilot` только после dry run и устранения неоднозначностей, из-за которых reviewers не могут стабильно:

- отличить obligation от implementation detail;
- отделить required question от придуманного requirement;
- применить strict coverage rubric;
- сослаться на конкретный source span;
- сохранить воспроизводимый run manifest.

Promotion означает готовность к калибровочному запуску, но не preregistration и не подтверждение исследовательской гипотезы.
