#!/usr/bin/env bash
#
# https://github.com/adnanh/webhook
# docker install webhook
#

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

die() {
    printf 'error: %s.\n' "$1" >&2
    exit 1
}

glob() {
    case $1 in $2) return 0; esac; return 1
}

yn() {
    printf '%s [y/n]: ' "$1"
    stty -icanon
    answer=$(dd ibs=1 count=1 2>/dev/null)
    stty icanon
    printf '\n'
    glob "$answer" '[yY]'
}

cmd_str=""

add_cmd_arg() {
  # add_cmd_arg "args"
    local arg=$1
    [ -z "$arg" ] && die "缺少参数arg"
    cmd_str=$cmd_str' '$arg
    # echo $cmd_str
}

add_cmd_arg_prompt() {
  # Usage: add_cmd_arg_prompt "请输入参数" "args {{default_value}}" "input_var_name"
  # __input数组和input_var_name可以获取prompt输入的值
  local prompt=$1
  local arg=$2
  local input_var_name=$3
  local default_input=$(echo $arg | sed -nE 's/^.*\{\{(.*)\}\}.*$/\1/p')

  [ -z "$prompt" ] && die "缺少参数prompt"
  [ -z "$arg" ] && die "缺少参数arg"

  # echo $default_input
  prompt=${prompt}${default_input:+(默认：$default_input)}:
  read -p $prompt input
  cmd_str=$cmd_str' '${arg//\{\{*\}\}/${input:=$default_input}}
  __input[${#__input[*]}]=$input;
  [ ! -z "$input_var_name" ] && eval "$input_var_name=$input"
  # echo $cmd_str
}
add_cmd_arg_yn() {
  # add_cmd_arg_yn "是否添加某参数" "args"
  local prompt=$1
  local arg=$2
  [ -z "$prompt" ] && die "缺少参数prompt"
  [ -z "$arg" ] && die "缺少参数arg"
  yn $prompt && {
    cmd_str=$cmd_str' '$arg
  }
  # echo $cmd_str
}

add_cmd_arg_yn_prompt() {
  # add_cmd_arg_yn_prompt "是否添加某参数" "请输入参数" "args {{default_value}}" "input_var_name"
  local prompt=$1
  [ -z "$prompt" ] && die "缺少参数yn_prompt"
  yn $prompt && {
    shift;
    add_cmd_arg_prompt $@
  }
}

add_cmd_arg "docker run -d --restart always"
add_cmd_arg_prompt "请输入容器名称" "--name {{webhook}}"
add_cmd_arg_prompt "请输入端口" "-p {{9001}}:9000"
add_cmd_arg_prompt "请输入数据目录" "-v {{/mnt/webhook}}:/etc/webhook" 
add_cmd_arg "almir/webhook -verbose -hooks=/etc/webhook/hooks.json -hotreload"

echo $cmd_str
exec $cmd_str


cat > /mnt/webhook/hooks.github.json <<EOF
// see: https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md
[
  {
    "id": "my_id",
    "execute-command": "/etc/webhook/my_script.sh",
    "command-working-directory": "/etc/webhook",
    "include-command-output-in-response": true,
    "include-command-output-in-response-on-error": true,
    "pass-arguments-to-command":
    [
      {
        "source": "payload",
        "name": "head_commit.id"
      },
      {
        "source": "payload",
        "name": "pusher.name"
      },
      {
        "source": "payload",
        "name": "pusher.email"
      }
    ],
    "trigger-rule":
    {
      "and":
      [
        {
          "match":
          {
            "type": "payload-hash-sha1",
            "secret": "mysecret",
            "parameter":
            {
              "source": "header",
              "name": "X-Hub-Signature"
            }
          }
        },
        {
          "match":
          {
            "type": "value",
            "value": "refs/heads/master",
            "parameter":
            {
              "source": "payload",
              "name": "ref"
            }
          }
        }
      ]
    }
  }
]
EOF