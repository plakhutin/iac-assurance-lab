# Current focus

**Updated:** 2026-08-08  
**Status:** active  
**Phase:** repository bootstrap → calibration pilot design

## Current objective

Подготовить два дешёвых калибровочных исследования до проектирования Semantic Verification Engine:

1. `E0a-P` — оценить baseline, variance и пригодность annotation process для сравнения plain, invariant-first и counterexample-first LLM planning;
2. `E0a-A` — оценить structural analyzability реальных legacy Ansible-ролей и obligation-relative opaque cones без построения verifier.

## Current position

Проект сознательно отказался от исходного широкого claim:

> «Можно статически доказать большинство свойств произвольного Ansible и проверить тысячи спеков за минуты».

Рабочая постановка теперь скромнее и фальсифицируема:

> Нужно независимо проверить, улучшает ли invariant/counterexample protocol полноту LLM planning и существует ли в реальных Ansible-ролях экономически ценный фрагмент для ограниченного effect analysis.

Полноценный engine, автоматический routing и production evidence platform отложены до экспериментальных оснований.

## Completed in the bootstrap branch

- создана ветка `bootstrap/project-memory`;
- определён порядок чтения для чистых сессий;
- зафиксированы эпистемические правила и prompt-injection boundary;
- создано оглавление документации;
- подготовлены charter, research state, hypotheses, ADR и черновики pilot protocols;
- начат related-work map;
- добавлены шаблоны handoff, experiment и decision.

## Next best step

Доработать `E0a-P` и `E0a-A` до уровня исполнимого pilot protocol. Сначала определить:

### Для `E0a-P`

- критерии отбора 6–8 pilot tasks;
- единицу разметки `critical obligation`;
- independent annotation и adjudication workflow;
- prompt variants `P0/P1/P2`;
- фиксируемые model/run metadata;
- primary pilot outputs: baseline, paired variance, run-to-run variance, ceiling effects и review time.

### Для `E0a-A`

- критерии отбора 12–15 legacy roles as-is;
- минимальную structural schema;
- точное построение `Roots`, `Sinks`, `Slice` и `OpaqueCone`;
- способы получения expert-authored obligations;
- глобальные и conditional знаменатели;
- optimistic cost-avoidance ceiling.

## Explicitly deferred

Не начинать без нового решения:

- реализацию общего Ansible IR;
- symbolic Jinja interpreter;
- semantic models модулей;
- runtime verification router;
- evidence registry;
- multi-host verifier;
- production blocking CI gate.

## Open decisions

1. Источник pilot tasks: synthetic briefs, реальные internal tasks или комбинация.
2. Источник legacy roles: публичные repositories, anonymized internal roles или оба набора.
3. Состав expert panel и способ измерения inter-rater agreement.
4. Основная pinned/open-weight model для воспроизводимости и external API model для replication.
5. Возможность переиспользования APME или Ansible Risk Insight для structural profiler.
6. Лицензия репозитория и будущего corpus — решение владельца, пока не принято.

## Exit condition for current phase

Bootstrap считается завершённым, когда:

- все ссылки в `README.md`, `AGENTS.md` и `docs/README.md` существуют;
- новая сессия может восстановить позицию проекта без chat history;
- pilot documents явно отделяют calibration от confirmatory study;
- текущий следующий шаг не требует проектирования большой платформы.

После этого следующий PR должен быть посвящён не «движку», а исполнимому design одного из pilot experiments.
