#!/usr/bin/env bash

if [ -f "pyproject.toml" ]; then
  # Python project
  if command -v poetry &> /dev/null; then
    poetry run cz commit
  elif command -v conda &> /dev/null; then
    conda run -n my-project-env cz commit
  else
    echo "No Python environment manager found (poetry or conda)."
    exit 1
  fi
elif [ -f "package.json" ]; then
  # JavaScript/TypeScript project
  if command jq -r '.scripts.commit' package.json &> /dev/null; then
    if command -v pnpm &> /dev/null; then
      pnpm run commit
    elif command -v npm &> /dev/null; then
      npm run commit
    elif command -v yarn &> /dev/null; then
      yarn run commit
    else
      echo "No JavaScript package manager found (npm, pnpm or yarn)."
      exit 1
    fi
  else
    if command -v pnpm &> /dev/null; then
      pnpm exec git-cz
    elif command -v npm &> /dev/null; then
      node_modules/.bin/git-cz
    else
      echo "No JavaScript package manager found (npm, pnpm or yarn)."
      exit 1
    fi
  fi
else
  echo "No project configuration found (pyproject.toml or package.json)"

  if command -v git cz &> /dev/null; then
    echo "here!"
    echo "No project configuration found (pyproject.toml or package.json), running the default commitizen command."
    git cz commit
  fi

  exit 1
fi

