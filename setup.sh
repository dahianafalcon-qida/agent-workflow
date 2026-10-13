#!/usr/bin/env bash

set -e

# Target parent workspace directory (default to current directory if not passed)
TARGET_DIR="${1:-ad-parent}"

# List of target child repositories/submodules within the parent workspace
CHILD_MODULES=(
  "ad-backend"
  "ad-backend-quotation"
  "ad-openai-poc"
  "qida_videocalls"
)

# Resolve absolute path of the setup script directory (where rules/ and templates/ live)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Setting up Agent Orchestration Framework in workspace: $TARGET_DIR"

# 1. Ensure target directory exists
if [ ! -d "../$TARGET_DIR" ]; then
    echo "❌ Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

cd "../$TARGET_DIR"

# 2. Setup Parent Orchestrator in Root Workspace
echo "📦 Configuring Parent Orchestrator..."
mkdir -p .claude design/templates
cp "$SCRIPT_DIR/rules/orchestrator.md" .claude/rules.md
cp "$SCRIPT_DIR/templates/implementation.md" .claude/implementation_template.md

echo "✅ Parent rules configured successfully."

# 3. Setup Child Container Rules for Each Submodule Directory
echo "🐳 Configuring Child Container Agents..."

for SUBMODULE_DIR in "${CHILD_MODULES[@]}"; do
    if [ -d "$SUBMODULE_DIR" ]; then
        echo "  ➜ Configuring child module: $SUBMODULE_DIR"

        # Create implementation mailboxes and .claude directory
        mkdir -p "$SUBMODULE_DIR/.claude/implementations"

        # Copy child rules
        cp "$SCRIPT_DIR/rules/container.md" "$SUBMODULE_DIR/.claude/rules.md"

        echo "  ✅ Done for $SUBMODULE_DIR"
    else
        echo "  ⚠️ Warning: Submodule directory '$SUBMODULE_DIR' not found in workspace. Skipping."
    fi
done

echo "🎉 Agent workflow setup completed successfully!"