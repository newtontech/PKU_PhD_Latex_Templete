
# 北京大学工学院博士学位论文LaTeX模板

这是一个用于撰写北京大学博士学位论文的 LaTeX 模板项目。此模板基于北京大学工程学院的博士毕业论文模板：https://www.coe.pku.edu.cn/service/biyedb/11187.html 。

<img width="498" height="710" alt="image" src="https://github.com/user-attachments/assets/b641da6b-f763-4be2-8d58-40614741a400" />


## 项目结构

本项目包含两个主要的 Git 分支，以适应不同的需求：

*   **`main` 分支**:
    此分支包含完整的博士学位论文模板，适用于论文的常规撰写和排版，包括所有作者相关信息、致谢、附录中的补充材料（如个人发表列表、简介）等。

*   **`double-blind` 分支**:
    此分支是为双盲评审目的而设计的精简版本。它移除了所有可能暴露作者身份的信息，如致谢、个人发表列表以及其他身份识别内容，并可能替换了封面文件。在需要提交论文进行匿名评审时，应切换到此分支。

## 如何使用

1.  **克隆仓库**:
    首先，将本 Git 仓库克隆到您的本地机器。
    ```bash
    git clone <repository_url> # 替换为您的仓库URL
    cd <repository_directory>
    ```

2.  **切换分支**:
    根据您的需求切换到相应的分支。
    *   **常规撰写**:
        ```bash
        git checkout main
        ```
    *   **双盲评审**:
        ```bash
        git checkout double-blind
        ```

## Git 忽略文件 (`.gitignore`)

项目根目录下的 `.gitignore` 文件配置了忽略以下类型的文件，这些文件通常是 LaTeX 编译过程中生成的中间文件或操作系统特有的文件，不应被版本控制：

*   macOS 系统文件 (例如 `.DS_Store`)
*   LaTeX 编译生成的辅助文件 (例如 `.aux`, `.log`, `.out`, `.toc`, `.blg`, `.bbl`, `.synctex.gz` 等)

## 文件列表

主要文件和目录包括：

*   `COEmain.tex`: 论文主文件。
*   `preface/`: 包含封面、摘要等前言部分。
*   `body/`: 包含论文正文的章节文件和参考文献。
*   `appendix/`: 包含附录内容。
*   `figures/`: 存放论文中使用的图片。
*   `setup/`: 包含 LaTeX 格式和宏包设置。
*   `.gitignore`: Git 忽略文件配置。

## 论文修订 Skill Pack

本仓库新增了一个面向科学论文修订的 skill pack 设计文档：

*   [`skills/evidence-bound-scientific-manuscript-revision/README.md`](skills/evidence-bound-scientific-manuscript-revision/README.md)

该 skill pack 采用 evidence-bound revision 原则：先把论文 claim 映射到实验文件、图表、代码输出、日志、补充材料和已核验文献，再做结构、方法、结果一致性和可审查 diff。它参考了多个公开 GitHub academic skills/agents 项目的模块化思想，包括 [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills)、[andrehuang/academic-writing-agents](https://github.com/andrehuang/academic-writing-agents)、[lishix520/academic-paper-skills](https://github.com/lishix520/academic-paper-skills)、[SNL-UCSB/paper-writing-skill](https://github.com/SNL-UCSB/paper-writing-skill)、[PaperDebugger/paperdebugger](https://github.com/PaperDebugger/paperdebugger) 和 [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills)。本仓库只借鉴其工作流思想，不复制上游正文、脚本或 agent 配置；论文事实、实验结果和学术判断仍由作者负责。

---

祝您论文撰写顺利！
