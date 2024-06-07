#!/bin/sh -e
set -x

isort src -s templates -s static
autoflake --remove-all-unused-imports --recursive --remove-unused-variables --in-place src --exclude=__init__.py
black src --exclude templates --exclude static 
flake8 --count --extend-exclude templates --extend-exclude static --extend-exclude .venv
mypy src --show-error-codes --exclude templates --exclude static --exclude .venv