#!/bin/bash
# sync-from-work.sh
# 从 ~/work/ 同步模板工程相关改动到当前模板仓库
#
# 用法: ./sync-from-work.sh [--dry-run]
#   --dry-run  仅显示将要执行的操作，不实际修改文件
set -euo pipefail

WORK="${HOME}/work"
TEMPLATE="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ── 颜色 ──
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "  ${GREEN}→${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC} $1"; }
info() { echo -e "${CYAN}【$1】${NC}"; }

if $DRY_RUN; then
    RSYNC="rsync -av --dry-run"
    CP="echo [dry-run] cp"
    MKDIR="echo [dry-run] mkdir -p"
    TOUCH="echo [dry-run] touch"
else
    RSYNC="rsync -av"
    CP="cp"
    MKDIR="mkdir -p"
    TOUCH="touch"
fi

# sed 原地编辑（避免变量展开导致的备份文件问题）
sed_inplace() {
    local file="$1"
    shift
    if $DRY_RUN; then
        echo "[dry-run] sed -i '' $* ${file}"
    else
        sed -i '' "$@" "${file}"
    fi
}

echo "╔══════════════════════════════════════════╗"
echo "║  模板工程同步脚本                        ║"
echo "║  ${WORK}  →  ${TEMPLATE}  ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ═══════════════════════════════════════════
# 1. .obsidian/ — 排除本地/个人部分
# ═══════════════════════════════════════════
info "1/7  .obsidian/ (排除本地部分)"
$RSYNC --delete \
    --exclude='workspace*.json' \
    --exclude='.DS_Store' \
    --exclude='logs/' \
    --exclude='icons/' \
    --exclude='image-converter-image-alignments.json' \
    "${WORK}/.obsidian/" "${TEMPLATE}/.obsidian/"

# ═══════════════════════════════════════════
# 2. .pi/ — 排除本地依赖
# ═══════════════════════════════════════════
info "2/7  .pi/ (排除 node_modules & lock)"
$RSYNC --delete \
    --exclude='npm/node_modules/' \
    --exclude='npm/package-lock.json' \
    --exclude='npm/.gitignore' \
    "${WORK}/.pi/" "${TEMPLATE}/.pi/"

# 确保 .pi/npm/ 有 .gitignore
if ! $DRY_RUN && [ ! -f "${TEMPLATE}/.pi/npm/.gitignore" ]; then
    echo "node_modules/" > "${TEMPLATE}/.pi/npm/.gitignore"
    log ".pi/npm/.gitignore (新建)"
fi

# ═══════════════════════════════════════════
# 3. 99-system/ — 排除 cookie.md, work-with-me 脱敏
# ═══════════════════════════════════════════
info "3/7  99-system/ (排除 cookie.md, work-with-me 脱敏)"

# 先同步除了 cookie.md 和 work-with-me.md 之外的所有内容
$RSYNC --delete \
    --exclude='.DS_Store' \
    --exclude='cookie.md' \
    --exclude='work-with-me.md' \
    "${WORK}/99-system/" "${TEMPLATE}/99-system/"

# work-with-me.md: 从 work 拷贝后脱敏
log "work-with-me.md → 脱敏同步"
$CP "${WORK}/99-system/work-with-me.md" "${TEMPLATE}/99-system/work-with-me.md"
sed_inplace "${TEMPLATE}/99-system/work-with-me.md" \
    -e 's/吴杰（Johnny）/无名（No Name）/g' \
    -e 's/替 Johnny/替 No Name/g' \
    -e 's/属于 Johnny/属于 No Name/g' \
    -e 's/Johnny/No Name/g'

# 脱敏 specs 中的 author 字段
for f in "${TEMPLATE}/99-system/specs/"*.md; do
    [ -f "$f" ] || continue
    if grep -q '吴杰' "$f" 2>/dev/null; then
        sed_inplace "$f" \
            -e 's/author: "\[\[吴杰\]\]"/author: "[[No Name]]"/g' \
            -e 's/  - "\[\[吴杰\]\]"/  - "[[No Name]]"/g'
        log "脱敏: $(basename "$f")"
    fi
done

# ═══════════════════════════════════════════
# 4. 根目录文件 — 排除 ABOUT-ME.md
# ═══════════════════════════════════════════
info "4/7  根目录文件 (排除 ABOUT-ME.md)"

ROOT_FILES=(
    ".gitignore"
    ".gitattributes"
    "cog.toml"
    "AGENTS.md"
    "README.md"
    "pyproject.toml"
    "uv.lock"
    ".python-version"
)

for f in "${ROOT_FILES[@]}"; do
    if [ -f "${WORK}/${f}" ]; then
        $CP "${WORK}/${f}" "${TEMPLATE}/${f}"
        log "${f}"
    else
        warn "${f} 在 work 中不存在，跳过"
    fi
done

# ═══════════════════════════════════════════
# 5. 内容目录 — 仅同步目录结构 + .gitkeep
# ═══════════════════════════════════════════
info "5/7  内容目录结构 (仅目录 + .gitkeep)"

CONTENT_DIRS=(
    "00-inbox-收件箱"
    "01-daily-日记"
    "10-todo-待办"
    "11-ideas-想法"
    "12-questions-问题"
    "20-research-调研"
    "21-learning-学习"
    "22-reading-阅读"
    "23-playing-游玩"
    "30-projects-项目"
    "80-archive-档案库"
    "81-knowledge-知识库"
    "82-categories-索引库"
    "83-data-数据库"
    "90-personal-私人数据"
    "98-ai-output"
)

for dir in "${CONTENT_DIRS[@]}"; do
    WORK_DIR="${WORK}/${dir}"
    TMPL_DIR="${TEMPLATE}/${dir}"

    # 确保顶层目录存在
    $MKDIR "${TMPL_DIR}"

    # 如果是 80-archive，需要同步子目录结构
    if [ "$dir" == "80-archive-档案库" ]; then
        for subdir in "${WORK_DIR}"/*/; do
            [ -d "$subdir" ] || continue
            subname=$(basename "$subdir")
            TMPL_SUB="${TMPL_DIR}/${subname}"
            $MKDIR "${TMPL_SUB}"
            # 确保有 .gitkeep（不覆盖已有文件）
            if ! $DRY_RUN && [ -z "$(ls -A "${TMPL_SUB}" 2>/dev/null)" ]; then
                $TOUCH "${TMPL_SUB}/.gitkeep"
            fi
        done
    fi

    # 确保顶层目录有 .gitkeep（不覆盖已有文件）
    if ! $DRY_RUN && [ -z "$(ls -A "${TMPL_DIR}" 2>/dev/null)" ]; then
        $TOUCH "${TMPL_DIR}/.gitkeep"
    fi
done

log "内容目录结构已同步"

# ═══════════════════════════════════════════
# 6. 清理模板中 work 不存在但 template 有的残留
# ═══════════════════════════════════════════
info "6/7  清理残留"

# 清理模板中的 .agents/ 目录（原项目已移除）
if ! $DRY_RUN && [ -d "${TEMPLATE}/.agents" ]; then
    rm -rf "${TEMPLATE}/.agents"
    log "已移除 .agents/ (原项目已迁移至 .pi/skills/)"
elif $DRY_RUN && [ -d "${TEMPLATE}/.agents" ]; then
    echo "[dry-run] rm -rf ${TEMPLATE}/.agents"
fi

# 清理 99-system/templates 中的 .gitkeep（work 没有）
if ! $DRY_RUN && [ -f "${TEMPLATE}/99-system/templates/.gitkeep" ]; then
    rm -f "${TEMPLATE}/99-system/templates/.gitkeep"
    log "已移除 99-system/templates/.gitkeep"
fi

# 清理 99-system/bases 中的 .gitkeep
if ! $DRY_RUN && [ -f "${TEMPLATE}/99-system/bases/.gitkeep" ]; then
    rm -f "${TEMPLATE}/99-system/bases/.gitkeep"
    log "已移除 99-system/bases/.gitkeep"
fi

echo ""
echo "═══════════════════════════════════════════"
echo -e "  ${GREEN}✓ 同步完成${NC}"
echo ""

# ═══════════════════════════════════════════
# 7/7  敏感字段扫描 (仅告警，不阻断)
# ═══════════════════════════════════════════
info "7/7  敏感字段扫描 (仅告警，不阻断)"
echo "  扫描 .obsidian/ 、99-system/ 与根配置文件；命中只提示，不阻断同步"

if ! command -v python3 >/dev/null 2>&1; then
    warn "python3 不可用，跳过敏感字段扫描"
else
    # 退出码始终为 0：发现敏感字段只提示，不打断同步流程
    python3 - "${TEMPLATE}" <<'PY' || true
import os
import re
import subprocess
import sys

root = sys.argv[1]
SCAN_DIRS = [".obsidian", "99-system"]
ROOT_FILES = [
    ".gitignore", ".gitattributes", "cog.toml",
    "AGENTS.md", "README.md", "pyproject.toml", ".python-version",
]
SCAN_EXT = (".json", ".toml", ".yaml", ".yml", ".md", ".txt", ".sh")

PATTERNS = [
    ("字段", re.compile(
        r'"(app_?secret|api_?key|secret_?key|client_?secret|access_?token|'
        r'refresh_?token|password|passwd|private_?key|token)"\s*:\s*"([^"]{8,})"',
        re.I)),
    ("凭证前缀", re.compile(
        r'\b(gh[pous]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}|'
        r'AKIA[0-9A-Z]{12,}|xox[baprs]-[A-Za-z0-9-]{10,})')),
    ("私钥", re.compile(r'-----BEGIN [A-Z ]*PRIVATE KEY-----')),
    ("Bearer", re.compile(r'(?i)\bbearer\s+([A-Za-z0-9._:\-]{20,})')),
]
PLACEHOLDER = re.compile(
    r'^(?:your[_-].*|<.*>|\$\{.*\}|xxx+|todo|tbd|changeme|placeholder|'
    r'example|none|null|redacted|false|true)$', re.I)


def mask(value):
    value = value.strip()
    if len(value) <= 10:
        return value[:2] + "***"
    return value[:4] + "***" + value[-4:]


def is_ignored(path):
    try:
        result = subprocess.run(
            ["git", "-C", root, "check-ignore", "-q", path],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return result.returncode == 0
    except OSError:
        return False


files = []
for rel_dir in SCAN_DIRS:
    base = os.path.join(root, rel_dir)
    if not os.path.isdir(base):
        continue
    for dirpath, dirnames, filenames in os.walk(base):
        dirnames[:] = [
            d for d in dirnames
            if d not in (".git", "node_modules", ".venv", "__pycache__")
        ]
        for name in filenames:
            if name.endswith(SCAN_EXT):
                files.append(os.path.join(dirpath, name))
for rel_file in ROOT_FILES:
    path = os.path.join(root, rel_file)
    if os.path.isfile(path):
        files.append(path)

hits = []
for path in files:
    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as handle:
            for lineno, line in enumerate(handle, 1):
                for label, pattern in PATTERNS:
                    match = pattern.search(line)
                    if not match:
                        continue
                    if label == "字段":
                        field, raw = match.group(1), match.group(2)
                    else:
                        field, raw = label, match.group(0)
                    if PLACEHOLDER.match(raw.strip()):
                        continue
                    hits.append((
                        os.path.relpath(path, root),
                        lineno,
                        field,
                        mask(raw),
                        is_ignored(path),
                    ))
    except OSError:
        continue

if not hits:
    print("  ✓ 未发现疑似敏感字段")
else:
    print("  ⚠ 发现 %d 处疑似敏感字段，请人工确认后再提交：" % len(hits))
    for rel_path, lineno, field, masked, ignored in hits:
        tag = " [已被 .gitignore 忽略]" if ignored else " [将被提交!]"
        print("    %s:%d  %s = %s%s" % (rel_path, lineno, field, masked, tag))
    print("    → 若为真实凭据：改用占位符，或把该文件加入 .gitignore")
PY
fi

echo ""
echo "  建议下一步:"
echo "    1. git diff --stat  查看改动概览"
echo "    2. git diff          审查具体改动"
echo "    3. 若上方有敏感字段告警，先处理再提交"
echo "    4. 确认无误后提交"
echo "═══════════════════════════════════════════"
