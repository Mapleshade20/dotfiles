# best fzf aliases ever
# Prerequisites: fd, ripgrep, fzf
_fuzzy_change_directory() {
    if ! command -v fd &>/dev/null; then
        echo "Error: 'fd' is not installed. Please install it to use this function." >&2
        echo "macOS: brew install fd" >&2
        echo "Debian/Ubuntu: sudo apt install fd-find" >&2
        return 1
    fi

    local initial_query="$1"
    local selected_dir
    local fzf_options=('--preview=ls -ap --color=always {}' '--preview-window=right:50%:wrap')
    fzf_options+=(--height "80%" --layout=reverse --cycle)
    local max_depth=8 # 可以适当增加深度，因为 fd 很快

    if [[ -n "$initial_query" ]]; then
        fzf_options+=("--query=$initial_query")
    fi

    # --type d: 只查找目录
    # --hidden: 包含隐藏目录 (例如 .config)
    # --no-ignore: 如果你想搜索被 .gitignore 忽略的目录，可以取消此行注释
    selected_dir=$(fd --type d --hidden --max-depth $max_depth --hidden . | fzf "${fzf_options[@]}")

    if [[ -n "$selected_dir" && -d "$selected_dir" ]]; then
        cd "$selected_dir" || return 1
    else
        return 1
    fi
}

_fuzzy_edit_search_file_content() {
    if ! command -v rg &>/dev/null; then
        echo "Error: 'ripgrep' (rg) is not installed. Please install it to use this function." >&2
        echo "macOS: brew install ripgrep" >&2
        echo "Debian/Ubuntu: sudo apt install ripgrep" >&2
        return 1
    fi

    local query="${1:-}"
    local selected_output
    local selected_file
    
    # 默认遵守 .gitignore
    # --colors 'match:fg:black,match:bg:yellow': 设置 fzf 列表中的高亮颜色
    # --no-heading: 不显示头部信息
    # --line-number: 显示行号
    # --smart-case: 智能大小写匹配
    # 输出格式: "file:line:content"
    RG_CMD="rg --color=always --line-number --no-heading --smart-case '$query'"
    
    # fzf 预览命令
    # {1} 是文件名, {2} 是行号
    local preview_cmd
    if command -v "bat" &>/dev/null; then
        preview_cmd="bat --color=always --style=plain --highlight-line {2} {1}"
    else
        # cat 没有高亮功能，但依然可用
        preview_cmd="cat {1}"
    fi

    local fzf_options=(
        --ansi
        --delimiter ':'
        --height "80%"
        --layout=reverse
        --cycle
        --preview-window "right:50%:wrap"
        --preview "$preview_cmd"
        --bind "enter:become(echo {1})"
    )

    # selected_output=$(eval "$RG_CMD" | fzf "${fzf_options[@]}")
    # 使用此方式可以更好地处理 query 中的特殊字符
    selected_output=$(
      FZF_DEFAULT_COMMAND="$RG_CMD" \
      fzf "${fzf_options[@]}"
    )


    if [[ -n "$selected_output" ]]; then
        # 从 "file:line:content" 中提取文件名
        selected_file=$(echo "$selected_output" | cut -d: -f1)
        if [[ -n "$selected_file" && -f "$selected_file" ]]; then
            if command -v "$EDITOR" &>/dev/null; then
                "$EDITOR" "$selected_file"
            else
                echo "EDITOR is not specified. using vim. (you can export EDITOR in ~/.zshrc)"
                vim "$selected_file"
            fi
        fi
    else
        echo "No file selected or search returned no results."
    fi
}

_fuzzy_edit_search_file() {
    if ! command -v fd &>/dev/null; then
        echo "Error: 'fd' is not installed. Please install it to use this function." >&2
        return 1
    fi

    local initial_query="$1"
    local selected_file
    local preview_cmd
    if command -v "bat" &>/dev/null; then
        preview_cmd=('bat --color always --style=plain --paging=never {}')
    else
        preview_cmd=('cat {}')
    fi
    local fzf_options=(--height "80%" --layout=reverse --cycle --preview-window right:50% --preview "${preview_cmd[*]}")
    local max_depth=7 # 可以适当增加深度

    if [[ -n "$initial_query" ]]; then
        fzf_options+=("--query=$initial_query")
    fi

    # -type f: 只查找文件
    # fd 默认排除 .git, node_modules 等目录
    selected_file=$(fd --type f --hidden --max-depth $max_depth . | fzf "${fzf_options[@]}")

    if [[ -n "$selected_file" && -f "$selected_file" ]]; then
        if command -v "$EDITOR" &>/dev/null; then
            "$EDITOR" "$selected_file"
        else
            echo "EDITOR is not specified. using vim. (you can export EDITOR in ~/.zshrc)"
            vim "$selected_file"
        fi
    else
        return 1
    fi
}

_fuzzy_search_cmd_history() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases noglob nobash_rematch 2> /dev/null

  local fzf_query=""
  if [[ -n "$1" ]]; then
    fzf_query="--query=${(qqq)1}"
  else
    fzf_query="--query=${(qqq)LBUFFER}"
  fi

  if zmodload -F zsh/parameter p:{commands,history} 2>/dev/null && (( ${+commands[perl]} )); then
    selected="$(printf '%s\t%s\000' "${(kv)history[@]}" |
      perl -0 -ne 'if (!$seen{(/^\s*[0-9]+\**\t(.*)/s, $1)}++) { s/\n/\n\t/g; print; }' |
      FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '\t↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} $fzf_query +m --read0") \
      FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd))"
  else
    selected="$(fc -rl 1 | __fzf_exec_awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
      FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '\t↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} $fzf_query +m") \
      FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd))"
  fi
  local ret=$?
  if [ -n "$selected" ]; then
    if [[ $(__fzf_exec_awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
      zle vi-fetch-history -n $MATCH
    else
      LBUFFER="$selected"
    fi
  fi
  return $ret
}

alias ffec='_fuzzy_edit_search_file_content' \
    ffcd='_fuzzy_change_directory' \
    ffe='_fuzzy_edit_search_file' \
    ffch='_fuzzy_search_cmd_history'
