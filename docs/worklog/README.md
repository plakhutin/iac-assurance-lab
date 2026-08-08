# Worklog

Worklog хранит краткую историческую запись значимых исследовательских сессий, когда Git history и ADR недостаточны для понимания последовательности работы.

Не создавай запись для каждой мелкой правки. Используй worklog, если сессия:

- провела experiment или dry run;
- существенно изменила research design;
- выполнила replication/fact-check;
- обнаружила отрицательный результат;
- провела крупный corpus review;
- оставила важный незавершённый технический контекст.

## File name

```text
YYYY-MM-DD-short-topic.md
```

## Minimal structure

```markdown
# YYYY-MM-DD — Topic

## Objective

## Work performed

## Findings

## Decisions/ADRs

## Artifacts and verification

## Open questions

## Next best step
```

Worklog является history, а не current source of truth. Если вывод остаётся действующим, обнови также `docs/project/research-state.md`, `docs/current-focus.md` или ADR.
