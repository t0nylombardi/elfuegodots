# Advanced Aliases.
# Use with caution
#

# Use eza when installed. Both commands support these listing options.
listing_command=ls
command -v eza >/dev/null 2>&1 && listing_command=eza
alias l="$listing_command -lFh"
alias la="$listing_command -lAFh"
alias lr="$listing_command -tRFh"
alias lt="$listing_command -ltFh"
alias ll="$listing_command -la"
alias ldot="$listing_command -ld .*"
alias lS="$listing_command -1FSsh"
alias lart="$listing_command -1Fcart"
alias lrt="$listing_command -1Fcrt"
alias lsr="$listing_command -lARFh"
alias lsn="$listing_command -1"
unset listing_command

if command -v z >/dev/null 2>&1; then
  alias cd='z'
fi
alias back='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias \?='pwd'

alias c='codium'

cde() {
  if [[ -n "$1" ]]; then
    cd "$@" || return 1
  fi
  codium .
}
