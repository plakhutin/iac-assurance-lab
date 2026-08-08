# DRY-00

Controlled synthetic task package для dry run E0a-P.

## Purpose

`DRY-00` проверяет:

- task-package envelope;
- authority/untrusted-data separation;
- P0/P1/P2 treatment contrast;
- independent expert elicitation;
- normalization/adjudication workflow;
- strict output scoring;
- prompt-injection boundary;
- run/data manifests.

Он **не входит** в pilot outcomes и не может использоваться как confirmatory task.

## Files

- [`task-package.txt`](task-package.txt) — exact assembled package, который добавляется после common prompt components.
- [`task-manifest.yaml`](task-manifest.yaml) — provenance, digest, selection axes и readiness fields.
- [`assembly-manifest.yaml`](assembly-manifest.yaml) — candidate expected bytes/digests для assembled P0/P1/P2 prompts.

## Fixture notes

- Версии и checksum values являются synthetic fixture data.
- Domain name `example.invalid` намеренно не обозначает реальный Nexus.
- Repository section содержит controlled prompt-injection comment. Его текст является untrusted data, а не инструкцией.
- Gold items намеренно не хранятся рядом до завершения independent expert elicitation.

## Validation status

На временной локальной fixture, созданной из exact intended contents:

- `bash -n assemble-prompt.sh` прошёл;
- `sha256sum --check SHA256SUMS` прошёл;
- P0/P1/P2 были собраны;
- expected bytes/digests записаны в `assembly-manifest.yaml`.

Это проверяет script и intended bytes, но не заменяет проверку committed files после checkout. DNS restriction среды не позволило clone branch, поэтому `committed_bytes_verified_after_checkout` остаётся `false`.

## Required next actions

1. Независимо проверить digests exact committed bytes после checkout/download.
2. Оценить input tokens для выбранной primary model.
3. Провести task preflight тремя experts.
4. Создать independent raw candidates без просмотра model outputs.
5. Выполнить normalization, closed rating и dry-run gold freeze.
6. Зафиксировать primary model и provider parameters.
7. Запустить по одному P0/P1/P2 response.
8. Провести double scoring и пересмотреть protocol до pilot freeze.

## Prohibited

- Не использовать этот package для оценки H-P.
- Не добавлять gold items из model responses.
- Не менять package после gold freeze без новой version.
- Не раскрывать injection location model или scorer до предусмотренного этапа.
