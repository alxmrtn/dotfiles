#! /bin/zsh

# True when the shell was spawned by a coding agent rather than driven by a
# human. Each agent advertises itself with its own variable, so this is a
# list rather than a single check.
#
# usage:
#   if is_agent_shell; then return 0; fi
function is_agent_shell() {
    local -a agent_vars=(
        CURSOR_AGENT                    # Cursor
        CLAUDECODE                      # Claude Code
        CLAUDE_CODE_CHILD_SESSION       # Claude Code >= 2.1.172, subprocesses only
        CODEX_SANDBOX                   # Codex, macOS seatbelt
        CODEX_SANDBOX_NETWORK_DISABLED  # Codex, sandbox with network disabled
        CODEX_CI                        # Codex
        CODEX_THREAD_ID                 # Codex
    )

    local var
    for var in "${agent_vars[@]}"; do
        # (P) dereferences the variable named by $var
        if [[ -n "${(P)var}" ]]; then
            return 0
        fi
    done
    return 1
}
