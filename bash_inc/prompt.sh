#!/usr/bin/env bash
# If we are on a colored terminal
if tput setaf 1 &> /dev/null; then
   # Reset the shell from our `if` check
   tput sgr0 &> /dev/null

    prompt_bold="$(tput bold)"
    prompt_reset="$(tput sgr0)"

	if [[ $ENV_STATUS = 'local' ]]; then
		prompt_user_color="$prompt_bold$(tput setaf 27)" # BOLD BLUE (local 55, dev 220, prod 196)
		prompt_device_color="$prompt_bold$(tput setaf 39)" # BOLD CYAN (local 62, dev 226, prod 202)

		prompt_symbol_color="$prompt_bold" # BOLD
	elif [[ $ENV_STATUS = 'dev' ]]; then
		prompt_user_color="$prompt_bold$(tput setaf 220)" # BOLD BLUE (local 55, dev 220, prod 196)
		prompt_device_color="$prompt_bold$(tput setaf 226)" # BOLD CYAN (local 62, dev 226, prod 202)

		prompt_symbol_color="$prompt_bold" # BOLD
	elif [[ $ENV_STATUS = 'prod' ]]; then
		prompt_user_color="$prompt_bold$(tput setaf 196)" # BOLD BLUE (local 55, dev 220, prod 196)
		prompt_device_color="$prompt_bold$(tput setaf 202)" # BOLD CYAN (local 62, dev 226, prod 202)
	else
		prompt_user_color="$prompt_bold$(tput setaf 245)NOT SET-" # BOLD BLUE (local 55, dev 220, prod 196)
		prompt_device_color="$prompt_bold$(tput setaf 255)" # BOLD CYAN (local 62, dev 226, prod 202)
	fi

	prompt_preposition_color="$prompt_bold$(tput setaf 7)" # BOLD WHITE
	prompt_dir_color="$prompt_bold$(tput setaf 76)" # BOLD GREEN
	prompt_git_status_color="$prompt_bold$(tput setaf 154)" # BOLD YELLOW
	prompt_git_progress_color="$prompt_bold$(tput setaf 9)" # BOLD RED
	screen_color="$prompt_bold$(tput setaf 9)" # BOLD RED
	prompt_symbol_color="$prompt_bold" # BOLD
else
# Otherwise, use ANSI escape sequences for coloring
  # If you would like to customize your colors, use
  # DEV: 30-39 lines up 0-9 from `tput`
  # for i in $(seq 0 109); do
  #   echo -n -e "\033[1;${i}mText$(tput sgr0) "
  #   echo "\033[1;${i}m"
  # done

  prompt_reset="\033[m"
  prompt_user_color="\033[1;34m" # BLUE
  prompt_preposition_color="\033[1;37m" # WHITE
  prompt_device_color="\033[1;36m" # CYAN
  prompt_dir_color="\033[1;32m" # GREEN
  prompt_git_status_color="\033[1;33m" # YELLOW
  prompt_git_progress_color="\033[1;31m" # RED
  screen_color="\033[1;31m" # RED
  prompt_symbol_color="" # NORMAL
fi

# Apply any color overrides that have been set in the environment
if [[ -n "$PROMPT_USER_COLOR" ]]; then prompt_user_color="$PROMPT_USER_COLOR"; fi
if [[ -n "$PROMPT_PREPOSITION_COLOR" ]]; then prompt_preposition_color="$PROMPT_PREPOSITION_COLOR"; fi
if [[ -n "$PROMPT_DEVICE_COLOR" ]]; then prompt_device_color="$PROMPT_DEVICE_COLOR"; fi
if [[ -n "$PROMPT_DIR_COLOR" ]]; then prompt_dir_color="$PROMPT_DIR_COLOR"; fi
if [[ -n "$PROMPT_GIT_STATUS_COLOR" ]]; then prompt_git_status_color="$PROMPT_GIT_STATUS_COLOR"; fi
if [[ -n "$PROMPT_GIT_PROGRESS_COLOR" ]]; then prompt_git_progress_color="$PROMPT_GIT_PROGRESS_COLOR"; fi
if [[ -n "$PROMPT_SYMBOL_COLOR" ]]; then prompt_symbol_color="$PROMPT_SYMBOL_COLOR"; fi


# Define the sexy-bash-prompt
PS1="$(if [[ -z $STY ]]; then echo ""; else echo "$screen_color[$STY]$NC "; fi)\[$prompt_user_color\]\u\[$prompt_reset\]\
\[$prompt_preposition_color\]@\[$prompt_reset\]\
\[$prompt_device_color\]\h\[$prompt_reset\]\
\[$prompt_preposition_color\]:\[$prompt_reset\] \
\[$prompt_dir_color\]\w\[$prompt_reset\]\
\$( is_on_git && \
  echo -n \" \[$prompt_git_status_color\][\[$prompt_reset\]\" && \
  echo -n \"\[$prompt_git_status_color\]\$(get_git_info)\" && \
  echo -n \"\[$prompt_git_progress_color\]\$(get_git_progress)\" && \
  echo -n \"\[$prompt_git_status_color\]]\[$prompt_reset\]\" && \
  echo -n \"\[$prompt_preposition_color\]\")\n\[$prompt_reset\]\
\[$prompt_symbol_color\]$(get_prompt_symbol) \[$prompt_reset\]"
