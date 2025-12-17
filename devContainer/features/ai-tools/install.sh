#!/bin/bash
set -e

ENV SANDBOX="$SANDBOX_NAME"
npm install -g @anthropic-ai/claude-code @google/gemini-cli
