# Evidence-Bound Scientific Manuscript Revision Skill Pack

本目录规划一组用于科学论文修订的 Codex/Claude 风格小 skill。它的目标不是让 AI “重写论文”，而是把论文、实验文件、图表、代码输出、日志、补充材料和参考文献组织成可审查的证据链，然后只修改有证据支撑的内容。

## 设计原则

1. **证据绑定式修改**：每个科学 claim 必须映射到实验文件、图表、代码输出、日志、补充材料、作者笔记或已核验文献。
2. **小 skill 组合**：每个 skill 只解决一个问题，由 orchestrator 串联执行，避免一个巨型 skill 同时做结构、事实、引用和语言修改。
3. **保留人工决策点**：证据不足、科学取舍、审稿策略和重大删改必须输出 TODO 或 decision item，不能由 AI 擅自补写。
4. **可审查输出**：LaTeX 使用 patch 或 `latexdiff`，DOCX 使用修订痕迹或评论；所有修改需要能被作者逐条审查。
5. **不编造事实**：禁止生成实验、数据集、baseline、数值结果、消融实验、机制解释、引用或 limitation。

## 最小可用版 skill

| Skill | 作用 | 主要产物 |
| --- | --- | --- |
| `paper-revision-orchestrator-skill` | 总控流程，协调各子 skill，执行证据状态门禁 | revision plan, final decision checklist |
| `project-file-map-skill` | 扫描 manuscript、figures、notebooks、logs、CSV、SI、references | project file inventory |
| `claim-evidence-map-skill` | 将核心 claim 映射到证据文件或已核验文献 | claim-evidence matrix |
| `section-architecture-skill` | 根据 IMRaD、学位论文或目标期刊结构重排章节 | section move plan |
| `methods-reproducibility-skill` | 从真实记录补全方法、参数、seed、版本和实验设置 | reproducibility checklist |
| `results-consistency-skill` | 检查正文数字、图表、caption、SI、代码输出是否一致 | consistency audit |
| `latex-docx-diff-skill` | 生成 LaTeX diff 或 DOCX 修订版，保留可审查修改 | diff package, human decision checklist |

后续可继续扩展 `gap-and-overclaim-audit-skill`、`storyline-and-contribution-skill`、`figure-table-caption-skill`、`literature-positioning-skill`、`citation-faithfulness-skill`、`terminology-symbol-unit-skill`、`academic-copyedit-skill`、`journal-guideline-skill` 和 `ai-use-disclosure-skill`。

## 证据状态

| 状态 | 含义 | 允许动作 |
| --- | --- | --- |
| `VERIFIED` | 实验文件、代码输出、图表、日志、作者笔记或已核验文献直接支持 | 可以写入正文，并记录 evidence id |
| `WEAKLY_SUPPORTED` | 有间接证据，但支撑力度不足 | 降低语气，放入 limitation 或请求作者确认 |
| `MISSING` | 找不到证据 | 不允许补写，只能 TODO 或评论 |
| `CONTRADICTED` | 论文说法和证据冲突 | 必须改写、删除或升级为作者决策项 |
| `NEEDS_HUMAN_DECISION` | 涉及科学判断、审稿策略或未公开材料 | 给出选项，不直接改正文 |

## 推荐执行顺序

```text
1. project-file-map-skill
2. claim-evidence-map-skill
3. results-consistency-skill
4. section-architecture-skill
5. methods-reproducibility-skill
6. latex-docx-diff-skill
7. paper-revision-orchestrator-skill final gate
```

## 产物约定

建议将修订产物放在论文项目的 `revision_outputs/` 中：

```text
revision_outputs/
  project_file_inventory.md
  claim_evidence_matrix.csv
  unsupported_claims.md
  consistency_audit.md
  section_move_plan.md
  reproducibility_checklist.md
  manuscript_revised.tex
  manuscript.diff
  response_to_reviewers.md
  ai_use_disclosure.md
  human_decision_checklist.md
```

## 参考项目与引用

本 skill pack 的结构参考了公开的 academic skills/agents 项目，但本仓库只采用工作流思想，不复制其正文、脚本或 agent 配置。

| 项目 | 可借鉴点 | 本仓库采用方式 |
| --- | --- | --- |
| [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) | research -> write -> review -> revise -> finalize 的阶段化 academic pipeline，以及 integrity gate 思想 | 借鉴阶段门禁和 integrity check 概念，改造成 evidence-bound revision gate |
| [andrehuang/academic-writing-agents](https://github.com/andrehuang/academic-writing-agents) | 多 specialist agents 并行审阅，覆盖结构、语言、数学、图表、引用等维度 | 借鉴小角色并行审阅思想，保留本仓库的证据状态和人工决策要求 |
| [lishix520/academic-paper-skills](https://github.com/lishix520/academic-paper-skills) | strategist/composer 分离、质量检查点和系统化论文规划 | 借鉴规划与写作分离，不让结构调整自动变成事实补写 |
| [SNL-UCSB/paper-writing-skill](https://github.com/SNL-UCSB/paper-writing-skill) | 论文写作 pipeline、project context、section checklist 和可定制作者风格 | 借鉴 section checklist 和 project context 概念，加入实验/结果证据绑定要求 |

引用这些项目时应同时查看其许可证和使用边界。对于未知或非标准许可证的项目，只做概念性参考，不复制文件内容。

## 可选外部参考

下面项目可作为使用者扩展工作流时的补充参考。本仓库不依赖这些工具，也不声明具备其自动研究、在线审稿或外部检索能力。

| 项目 | 可参考点 | 使用边界 |
| --- | --- | --- |
| [ngtiendong/Academic-Research-Agent-Skill](https://github.com/ngtiendong/Academic-Research-Agent-Skill) | 文献 grounding、novelty gate、实验计划、reviewer simulation、claim verification | 可参考人机协作研究流程；不要把本模板描述成自动研究 agent |
| [Zhangyanbo/vibe-paper-writing](https://github.com/Zhangyanbo/vibe-paper-writing) | LaTeX 编辑、导师反馈和笔记整合、引用和数学符号维护 | 只整合作者确认的信息；博士论文仍由作者负责真实性和学术判断 |
| [PaperDebugger/paperdebugger](https://github.com/PaperDebugger/paperdebugger) | Overleaf/LaTeX 只读审稿式 critique、citation verification、revision pass | 它是 AGPL-3.0 浏览器插件/后端系统，不作为本模板依赖 |
| [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | literature review、peer review、scientific writing、citation management 的模块化组织 | 覆盖面较宽；本仓库只保留论文修订所需的轻量模块 |
| [K-Dense-AI/claude-scientific-writer](https://github.com/K-Dense-AI/claude-scientific-writer) | verified citations、research lookup、peer review、BibTeX/reference handling | 依赖外部工具和 API；不要暗示本模板自带实时检索能力 |
| [Zsun79/LitReviewSkill](https://github.com/Zsun79/LitReviewSkill) | 带检索日志、筛选边界和引用扩展的文献综述流程 | 适合综述章节流程参考，不解决 PKU 学位论文格式 |
| [NousResearch/hermes-agent research paper writing skill](https://github.com/NousResearch/hermes-agent/blob/main/skills/research/research-paper-writing/SKILL.md) | “实验支撑 claims”“引用必须可验证”“paper is a story”等原则 | 偏 ML/AI 顶会投稿与实验流水线，不复制其自动实验或提交流程 |
| [kgraph57/paper-writer-skill](https://github.com/kgraph57/paper-writer-skill) | manuscript lifecycle、quality gates、IMRaD、reference checks、submission checklist | 主要作为阶段门控思想参考；许可证和适用领域需单独核查 |

## 禁止事项

```text
Do not invent experiments, datasets, baselines, numerical results, ablations,
mechanisms, citations, or limitations.

Only add content if it is supported by the manuscript, experiment folder,
verified references, or explicit author notes.

For uncertain edits, leave a TODO/comment instead of rewriting.

For DOCX, use tracked changes or comments.
For LaTeX, output patch/diff and preserve labels, citations, equations,
and figure/table references.
```
