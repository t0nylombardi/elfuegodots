# Advanced Aliases.
# Use with caution
#

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='eza -lFh'     #size,show type,human readable
alias la='eza -lAFh'   #long list,show almost all,show type,human readable
alias lr='eza -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='eza -ltFh'   #long list,sorted by date,show type,human readable
alias ll='eza -la'      #long list
alias ldot='eza -ld .*'
alias lS='eza -1FSsh'
alias lart='eza -1Fcart'
alias lrt='eza -1Fcrt'
alias lsr='eza -lARFh' #Recursive list of files and directories
alias lsn='eza -1'
alias ll='eza -la'

alias cd='z'
alias back='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias \?='pwd'

alias c='codium'

cde() {
  if [[ -n "$1" ]]; then
    z "$@" || return 1
  fi
  codium .
}
