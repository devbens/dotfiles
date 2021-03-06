#!/usr/bin/env zsh

zmodload zsh/datetime

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _update_zsh_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! ${DOTFILES}/cache/.dotfiles-update
}

function _upgrade_zsh() {
  env DOTFILES=$DOTFILES sh $DOTFILES/tools/upgrade.sh
  # update the zsh file
  _update_zsh_update
}

epoch_target=$UPDATE_DOTFILES_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=7
fi

# Cancel upgrade if the current user doesn't have write permissions for the
# oh-my-zsh directory.
[[ -w "$DOTFILES" ]] || return 0

# Cancel upgrade if git is unavailable on the system
whence git >/dev/null || return 0

if mkdir "$DOTFILES/log/update.lock" 2>/dev/null; then
  if [[ -f ${DOTFILES}/cache/.dotfiles-update ]]; then
    . ${DOTFILES}/cache/.dotfiles-update

    if [[ -z "$LAST_EPOCH" ]]; then
      _update_zsh_update && return 0
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [[ $epoch_diff -gt $epoch_target ]]; then
      if [[ "$DISABLE_UPDATE_PROMPT" = "true" ]]; then
        _upgrade_zsh
      else
        echo "[Devbens Dotfiles] Would you like to update? [Y/n]: \c"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [[ -z "$line" ]]; then
          _upgrade_zsh
        else
          _update_zsh_update
        fi
      fi
    fi
  else
    # create the zsh file
    _update_zsh_update
  fi

  rmdir $DOTFILES/log/update.lock
fi