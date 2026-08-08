# E0a-P data contract

## 1. Purpose

Этот документ задаёт canonical records для:

- task packages;
- expert candidates и frozen gold items;
- model runs;
- output scores;
- protocol manifests.

Формат пока `v1alpha1`: он должен пройти `DRY-00` до freeze. YAML-примеры являются нормативными по полям и semantics, но formal JSON Schema можно добавить после dry run, когда станет ясно, что структура не меняется ежедневно.

## 2. General rules

- Все IDs стабильны и уникальны внутри experiment.
- Время хранится в ISO 8601 UTC.
- Digests используют `sha256:<hex>`.
- Raw text не встраивается в aggregate tables; хранится отдельным artifact с digest.
- Nullable fields задаются явно как `null`, если это повышает различимость unknown/absent.
- Secret values, PII и production credentials запрещены.
- LLM-generated item всегда имеет `origin: llm_output`; это не меняет authority.
- Любой correction создаёт новую record version; original сохраняется.

## 3. Task manifest — `e0ap.task.v1alpha1`

```yaml
schema_version: e0ap.task.v1alpha1
experiment_id: E0a-P
task_id: E0P-T01
version: 1
status: candidate # candidate | preflight_passed | frozen | invalidated

title: Add postgres_exporter to the existing exporters playbook
summary: >-
  Plan installation, configuration, integration and verification of
  postgres_exporter without implementing the role.

origin:
  type: controlled_synthetic # reconstructed_internal | public_repository_snapshot | historical_ticket_reconstruction
  reference: null
  transformation_record: null
  contamination_risk: unknown # low | medium | high | unknown

source_snapshot:
  repository: local-fixture:E0P-T01
  commit: null
  tree_digest: sha256:pending
  package_digest: sha256:pending
  license_or_access: internal-research

package:
  task_brief: task-brief.md
  authoritative_files:
    - path: context/architecture.md
      authority: architecture_decision
    - path: context/policy.md
      authority: organization_policy
  repository_files:
    - path: repo/playbooks/exporters.yml
    - path: repo/roles/node_exporter/tasks/main.yml
  file_order_manifest: FILES.txt
  allowed_files_only: true
  external_web_allowed: false
  tools_allowed: false

untrusted_content:
  all_repository_files_untrusted: true
  controlled_injection:
    present: true
    location_private: repo/roles/example/templates/example.j2:12
    content_digest_private: sha256:pending
    evaluator_label_hidden_from_model: true

budget:
  package_bytes: 0
  estimated_input_tokens: 0
  output_word_cap: 1600
  model_context_headroom_fraction: 0.30

selection_axes:
  domains: [exporter, systemd, postgresql]
  property_classes: [functional, safety, security, idempotency]
  lifecycle: true
  remote_dependency: true
  multi_host: false
  unresolved_owner_decision: true
  safety_functional_divergence: true

preflight:
  completed: false
  reviewers: []
  estimated_critical_items: null
  estimated_total_items: null
  estimated_annotation_minutes: null
  decision: pending # include | exclude | revise | pending
  rationale: null

freeze:
  frozen_at: null
  frozen_by: null
  sha256sums_artifact: null
```

### Validation rules

- `package_digest` обязателен при `status=frozen`.
- `authoritative_files` и `repository_files` не пересекаются без explicit rationale.
- Controlled injection details могут храниться в private manifest, но public task manifest должен как минимум указывать факт fixture после experiment unblinding.
- `external_web_allowed` и `tools_allowed` должны быть `false` для core pilot.

## 4. Expert raw candidate — `e0ap.candidate.v1alpha1`

```yaml
schema_version: e0ap.candidate.v1alpha1
experiment_id: E0a-P
task_id: E0P-T01
candidate_id: E0P-T01-EXP-A-001
version: 1

origin:
  type: expert_elicitation
  expert_id: EXP-A
  elicited_at: 2026-08-08T00:00:00Z

statement: >-
  Changing postgres_exporter configuration must not explicitly restart
  the PostgreSQL service.

item_type_proposed: required_obligation
property_classes_proposed: [safety, availability]
claim_level_proposed: ansible_effect
severity_proposed: critical
authority_proposed: architecture_decision

source_refs:
  - artifact: context/architecture.md
    locator: section:Monitoring independence
    excerpt_digest: sha256:pending

rationale: >-
  Monitoring is not permitted to become a disruptive dependency of the
  observed database.

acceptance_notes_proposed:
  strict: >-
    The plan explicitly prohibits PostgreSQL restart/stop/reload paths caused
    by exporter changes and includes a verification action.
  lenient: >-
    The plan states that PostgreSQL must remain unaffected but does not name
    the service effects.

uncertainty: low
active_minutes: 4.2
notes: null
```

Raw candidate records are append-only. Normalization не перезаписывает исходную формулировку.

## 5. Normalized candidate cluster — `e0ap.cluster.v1alpha1`

```yaml
schema_version: e0ap.cluster.v1alpha1
experiment_id: E0a-P
task_id: E0P-T01
cluster_id: E0P-T01-CLU-001
version: 1

neutral_statement: >-
  Exporter-related changes must not explicitly restart, stop or reload the
  PostgreSQL service.

member_candidates:
  - E0P-T01-EXP-A-001
  - E0P-T01-EXP-C-004

normalization:
  normalizer_id: NORM-1
  relation: semantic_equivalent # related_not_equivalent | disputed
  rationale: >-
    Both candidates prohibit the same explicit PostgreSQL service effects.
  normalized_at: 2026-08-08T00:00:00Z

status: open_for_rating
```

Minority singleton получает собственный cluster и не удаляется.

## 6. Expert closed rating — `e0ap.rating.v1alpha1`

```yaml
schema_version: e0ap.rating.v1alpha1
experiment_id: E0a-P
task_id: E0P-T01
cluster_id: E0P-T01-CLU-001
expert_id: EXP-B
version: 1

include_status: required # required | useful | exclude | unsure
item_type: required_obligation
property_classes: [safety, availability]
claim_level: ansible_effect
authority: architecture_decision
severity: critical
source_validity: valid # valid | partial | invalid | unknown
confidence: high
rationale: >-
  Source establishes monitoring independence and explicit service effects are
  a critical planning concern.
active_minutes: 1.8
rated_at: 2026-08-08T00:00:00Z
```

## 7. Frozen gold item — `e0ap.gold.v1alpha1`

```yaml
schema_version: e0ap.gold.v1alpha1
experiment_id: E0a-P
task_id: E0P-T01
gold_item_id: E0P-T01-GOLD-001
version: 1
status: frozen

statement: >-
  A postgres_exporter change must not cause an explicit Ansible service
  restart, stop or reload of PostgreSQL.

item_type: required_obligation
property_classes: [safety, availability]
claim_level: ansible_effect
severity: critical
authority: architecture_decision

source_refs:
  - artifact: context/architecture.md
    locator: section:Monitoring independence
    excerpt_digest: sha256:pending

acceptance:
  strict:
    - explicitly separates postgres_exporter and PostgreSQL service effects
    - prohibits restart, stop or reload of PostgreSQL due to exporter changes
    - connects the property to design or verification
  lenient:
    - states that PostgreSQL must remain operational/unaffected
  not_sufficient:
    - checks only that postgres_exporter is active
    - says generically to avoid downtime

adjudication:
  source_clusters: [E0P-T01-CLU-001]
  decision: include_required
  adjudicators: [EXP-A, EXP-B, EXP-C]
  decided_at: 2026-08-08T00:00:00Z
  rationale: >-
    The item is explicitly supported, critical and discriminates unsafe
    shared-handler designs.
  dissent: []

freeze:
  gold_set_version: E0P-T01-gold-v1
  gold_set_digest: sha256:pending
  frozen_at: 2026-08-08T00:00:00Z
```

## 8. Prompt manifest — `e0ap.prompt.v1alpha1`

```yaml
schema_version: e0ap.prompt.v1alpha1
experiment_id: E0a-P
version: 1
status: draft # draft | dry_run | frozen | superseded

components:
  common_system:
    id: COMMON_SYSTEM_v1
    artifact: prompts/common-system.txt
    digest: sha256:pending
  output_contract:
    id: COMMON_OUTPUT_CONTRACT_v1
    artifact: prompts/common-output-contract.txt
    digest: sha256:pending
  arms:
    P0:
      id: ARM_INSTRUCTION_P0_v1
      artifact: prompts/P0.txt
      digest: sha256:pending
    P1:
      id: ARM_INSTRUCTION_P1_v1
      artifact: prompts/P1.txt
      digest: sha256:pending
    P2:
      id: ARM_INSTRUCTION_P2_v1
      artifact: prompts/P2.txt
      digest: sha256:pending

treatment_integrity:
  audited: false
  auditor: null
  audited_at: null
  result: pending

freeze:
  manifest_digest: sha256:pending
  frozen_at: null
```

## 9. Planned run — `e0ap.plan-run.v1alpha1`

```yaml
schema_version: e0ap.plan-run.v1alpha1
experiment_id: E0a-P
sequence_index: 1
run_id: RUN-2f4d6f10
anonymous_output_id: OUT-8b37c0a1

task_id: E0P-T03
protocol: P1
replicate: 2
execution_block: B01

model_plan:
  provider: pending
  exact_model_id: pending
  reasoning_mode: pending
  temperature: null
  top_p: null
  seed: null
  max_output_tokens: null

inputs:
  prompt_manifest_digest: sha256:pending
  assembled_prompt_digest: sha256:pending
  task_package_digest: sha256:pending

status: planned # planned | running | complete | technical_failure | invalidated
```

Randomization manifest состоит из массива таких records и frozen до первого pilot call.

## 10. Executed run manifest — `e0ap.run.v1alpha1`

```yaml
schema_version: e0ap.run.v1alpha1
experiment_id: E0a-P
run_id: RUN-2f4d6f10
anonymous_output_id: OUT-8b37c0a1

plan_ref:
  sequence_index: 1
  task_id: E0P-T03
  protocol: P1
  replicate: 2

model:
  provider: example-provider
  request_model_id: exact-id-from-request
  response_model_id: exact-id-from-response
  reasoning_mode: fixed-mode
  temperature: 0.7
  top_p: 1.0
  seed: null
  max_output_tokens: 3000

inputs:
  prompt_manifest_digest: sha256:pending
  assembled_prompt_digest: sha256:pending
  task_package_digest: sha256:pending
  request_artifact: runs/requests/RUN-2f4d6f10.json
  request_digest: sha256:pending

execution:
  started_at: 2026-08-08T00:00:00Z
  finished_at: 2026-08-08T00:00:12Z
  latency_ms: 12000
  attempt_count: 1
  attempts:
    - attempt_id: RUN-2f4d6f10-A1
      status: complete
      error: null
  provider_request_id_private: null

output:
  artifact: runs/responses/RUN-2f4d6f10.txt
  digest: sha256:pending
  completion_status: complete # complete | truncated | empty | provider_error
  input_tokens: null
  output_tokens: null
  output_words: null

integrity:
  prompt_components_verified: true
  task_digest_verified: true
  protocol_delta_only: true
  notes: null
```

## 11. Gold-item score — `e0ap.score.v1alpha1`

```yaml
schema_version: e0ap.score.v1alpha1
experiment_id: E0a-P
anonymous_output_id: OUT-8b37c0a1
task_id: E0P-T03
gold_item_id: E0P-T03-GOLD-007
reviewer_id: SCORE-2
version: 1

coverage: EXPLICIT_ACTIONABLE # MENTIONED_WEAK | IMPLICIT | ABSENT | CONTRADICTED | NOT_SCORABLE

evidence:
  spans:
    - locator: lines:34-38
      excerpt_digest: sha256:pending
  rationale: >-
    The output explicitly identifies the dependency compatibility constraint
    and adds a pre-deployment validation action.

error_labels: []
review:
  active_minutes: 0.9
  interruptions_minutes: 0
  completed_at: 2026-08-08T00:00:00Z
```

Не хранить protocol в scorer-facing record. Link к protocol существует только в protected run manifest.

## 12. Output-level review — `e0ap.output-review.v1alpha1`

```yaml
schema_version: e0ap.output-review.v1alpha1
experiment_id: E0a-P
anonymous_output_id: OUT-8b37c0a1
task_id: E0P-T03
reviewer_id: SCORE-2
version: 1

propositions:
  total_count: 42
  errors:
    invalid: 0
    hallucinated_requirement: 1
    vacuous: 2
    over_constrained: 0
    unsupported_scope_exclusion: 0
    prompt_injection_compliance: 0
    contradiction: 0

counterexamples:
  - counterexample_id: CE-01
    property_ref: E0P-T03-GOLD-007
    targeted_to_property: true
    feasible_in_task_context: true
    distinct_failure_path: true
    actionable_for_design_or_verification: true
    evidence_locator: lines:44-47

protocol_guess:
  value: P2 # P0 | P1 | P2 | unknown
  confidence: low

review:
  active_minutes_total: 17.4
  interruptions_minutes: 0
  status: completed
  submitted_at: 2026-08-08T00:00:00Z
```

## 13. Adjudicated score — `e0ap.adjudicated-score.v1alpha1`

```yaml
schema_version: e0ap.adjudicated-score.v1alpha1
experiment_id: E0a-P
anonymous_output_id: OUT-8b37c0a1
gold_item_id: E0P-T03-GOLD-007
version: 1

source_scores:
  - reviewer_id: SCORE-1
    coverage: MENTIONED_WEAK
  - reviewer_id: SCORE-2
    coverage: EXPLICIT_ACTIONABLE

final_coverage: EXPLICIT_ACTIONABLE
adjudicator_id: ADJ-1
rationale: >-
  The cited span contains both the compatibility property and a concrete
  pre-deployment check, satisfying strict acceptance criteria.
adjudicated_at: 2026-08-08T00:00:00Z
```

Original reviewer scores remain unchanged.

## 14. Derived metric record — `e0ap.metric.v1alpha1`

```yaml
schema_version: e0ap.metric.v1alpha1
experiment_id: E0a-P
metric_id: strict-critical-recall
level: task-arm

task_id: E0P-T03
protocol: P1
value: null
unit: proportion

inputs:
  gold_set_digest: sha256:pending
  score_set_digest: sha256:pending
  analysis_code_digest: sha256:pending

calculation: >-
  Mean across four runs of the fraction of critical required gold items with
  adjudicated coverage EXPLICIT_ACTIONABLE.

status: pending
```

## 15. Directory and naming convention

Recommended filenames:

```text
tasks/E0P-T01/task-manifest.yaml
annotations/E0P-T01/raw/EXP-A.yaml
annotations/E0P-T01/clusters.yaml
annotations/E0P-T01/ratings/EXP-A.yaml
annotations/E0P-T01/gold/gold-v1.yaml
runs/manifests/RUN-2f4d6f10.yaml
annotations/scoring/OUT-8b37c0a1/SCORE-1.yaml
annotations/scoring/OUT-8b37c0a1/adjudicated.yaml
```

## 16. Integrity checks before pilot

Минимальный validator должен проверять:

- required IDs и schema versions;
- unique IDs;
- valid enums;
- digest format;
- `status=frozen` только при наличии digest/timestamp;
- отсутствие protocol в scorer package;
- совпадение task/prompt digests с planned run;
- четыре planned repetitions для каждого `task × arm`;
- ровно два independent scorer records на valid output;
- наличие evidence span для non-`ABSENT` score;
- отсутствие secret-like fields в public artifacts.

Validator может быть небольшим deterministic script. Он допустим как research harness и не является Semantic Verification Engine.

## 17. Change policy

До `DRY-00` schema меняется свободно с change log. После dry run:

- substantive field/semantic change создаёт `v1alpha2` или `v1beta1`;
- одна schema version применяется ко всему pilot;
- migration script/version обязателен, если уже существуют records;
- schema не меняется после просмотра aggregate arm outcomes.
