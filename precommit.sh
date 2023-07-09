#!/bin/zsh

# Run extra steps when in Sourcetree or Tower (since they customize the PATH env var)
if [[ $PATH == *"Sourcetree"* || $PATH == *"Tower.app"* ]]; then
  echo "We're in a Git GUI client. Since this Git client customizes the PATH env var, we need to fix the PATH."
  echo "We're gonna fix the PATH by 'sourcing' the ~/.zshrc file:"
  source ~/.zshrc
fi

SWIFTFORMAT=Pods/SwiftFormat/CommandLineTool/swiftformat

bundle exec git_stage_formatter --formatter \"$SWIFTFORMAT stdin --stdinpath '{}'\" \"*.swift\"
