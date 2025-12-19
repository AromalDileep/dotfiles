#!/usr/bin/env zsh

# Get the current pane's environment variables
eval "$(tmux show-environment -s)"

# Initialize conda if available
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
fi

# Activate the conda environment if one is set
if [ -n "$CONDA_DEFAULT_ENV" ]; then
  conda activate "$CONDA_DEFAULT_ENV"
  ENV_NAME="$CONDA_DEFAULT_ENV"
elif [ -n "$VIRTUAL_ENV" ]; then
  source "$VIRTUAL_ENV/bin/activate"
  ENV_NAME="${VIRTUAL_ENV##*/}"
else
  ENV_NAME="system"
fi

echo "Environment: $ENV_NAME"
echo "Python: $(which python3)"
echo ""
ipython
