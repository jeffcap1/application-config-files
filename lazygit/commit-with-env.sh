#!/usr/bin/env bash

if [ -f "pyproject.toml" ]; then
  # Python project
  if command -v poetry &> /dev/null; then
    poetry shell && cz commit
  elif command -v conda &> /dev/null; then
    # You might need to determine the environment name dynamically
    # For example, from a .env file or project configuration
    conda activate my-project-env && cz commit
  else
    echo "No Python environment manager found (poetry or conda)."
    exit 1
  fi
elif [ -f "package.json" ]; then
  # JavaScript/TypeScript project
  if command -v pnpm &> /dev/null; then
    pnpm exec cz commit
  elif command -v npm &> /dev/null; then
    node_modules/.bin/cz commit
  elif command -v yarn &> /dev/null; then
    yarn run commit
  else
    echo "No JavaScript package manager found (npm, pnpm or yarn)."
    exit 1
  fi
else
  echo "No project configuration found (pyproject.toml or package.json)"

  if command -v "git cz" &> /dev/null; then
    echo "here!"
    echo "No project configuration found (pyproject.toml or package.json), running the default commitizen command."
    git cz commit
  fi

  exit 1
fi

