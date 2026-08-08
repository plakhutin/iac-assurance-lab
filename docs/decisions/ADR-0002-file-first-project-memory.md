# ADR-0002: Use file-first project memory

- **Status:** Accepted
- **Date:** 2026-08-08
- **Decision owners:** repository owner / project research lead

## Context

Работа над проектом будет продолжаться в разных AI-сессиях, часть из которых не будет иметь полного chat history. Без явной памяти новые сессии склонны:

- возвращаться к уже отклонённым широким claims;
- повторно обсуждать принятые решения;
- проектировать большой engine вместо текущего pilot;
- терять границы authority, evidence и scope;
- смешивать exploratory и confirmatory results.

Chat history не является надёжным или переносимым source of truth.

## Decision

Долгоживущая память хранится в репозитории.

Обязательные точки входа:

```text
AGENTS.md
README.md
docs/README.md
docs/current-focus.md
docs/project/research-state.md
docs/project/hypotheses.md
```

Семантика документов:

- `AGENTS.md` — правила работы и чтения для агента;
- `current-focus.md` — настоящее и следующий шаг;
- `research-state.md` — консолидированные устойчивые выводы;
- `hypotheses.md` — независимые research branches;
- ADR — принятые решения и последствия;
- experiment documents — versioned protocol;
- worklog — исторические записи, когда Git history недостаточна.

После значимого изменения агент обязан обновить релевантную память в той же ветке/PR.

## Update rules

- Не хранить единственную копию важного решения только в issue, PR comment или чате.
- Не превращать `research-state.md` в полный transcript.
- Не переписывать историю ADR задним числом; новое решение — новый ADR.
- `current-focus.md` обновляется при изменении ближайшего результата.
- Все новые docs добавляются в `docs/README.md`.
- Handoff должен указывать exact branch/commit, completed work, unresolved decisions и next best step.

## Consequences

### Positive

- чистая сессия может быстро восстановить контекст;
- решения становятся reviewable и versioned;
- меньше повторного исследования и архитектурного drift;
- prompt injection из анализируемого corpus проще отделять от project instructions.

### Negative

- документацию необходимо поддерживать;
- возможна рассинхронизация документов;
- изменения требуют дисциплины и review.

## Mitigations

- короткий обязательный startup order в `AGENTS.md`;
- одно оглавление `docs/README.md`;
- различение current state, durable state и history;
- проверка ссылок и памяти при завершении PR.
