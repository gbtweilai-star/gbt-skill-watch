#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_skill_watch info
PYTHONPATH=src python -m gbt_skill_watch check --payload '{}'
PYTHONPATH=src python -m gbt_skill_watch run   --payload '{}'
