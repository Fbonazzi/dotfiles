# This is the default theme for gitprompt.sh
# tweaked for Ubuntu terminal fonts

override_git_prompt_colors() {
  PathRepo="\$(basename \$(git rev-parse --show-toplevel 2>/dev/null))"
  PathSubd="\$(git rev-parse --show-prefix)"
  Branch="\$(git symbolic-ref --short HEAD 2>/dev/null)"
  GIT_PROMPT_THEME_NAME="Default Ubuntu"

  #Overrides the prompt_callback function used by bash-git-prompt
  function prompt_callback {
    local PS1="$PathRepo [$Branch] - Git"
    gp_set_window_title "$PS1"
  }

  local gp_end=" _LAST_COMMAND_INDICATOR_\n${White}${Time12a}${ResetColor}"

  GIT_PROMPT_STAGED="${Red}● "		# the number of staged files/directories
  GIT_PROMPT_CONFLICTS="${Red}x"	# the number of files in conflict
  GIT_PROMPT_CHANGED="${Blue}+"		# the number of changed files
  GIT_PROMPT_UNTRACKED="${Cyan}∉ "	# the number of untracked files/dirs
  GIT_PROMPT_COMMAND_OK="${Green}✔"    # indicator if the last command returned with an exit code of 0
  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${BoldYellow}${PathRepo}${ResetColor}${White}/${PathSubd}${ResetColor}"
  GIT_PROMPT_START_ROOT="${Red}ROOT${ResetColor} ${GIT_PROMPT_START_USER}"
  GIT_PROMPT_END_USER="${ResetColor} $ "
  GIT_PROMPT_END_ROOT="${BoldRed} # "
}

reload_git_prompt_colors "Default Ubuntu"
