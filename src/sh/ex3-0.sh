set -e

rc_file="$HOME/.bashrc"
export_line='export MYENV="Hello Shell"'
if [[ ! -f "$rc_file" ]] || ! grep -Fxq "$export_line" "$rc_file"; then
    printf '\n%s\n' "$export_line" >> "$rc_file"
fi

export MYENV="Hello Shell"
printf '현재 셸: MYENV=%s\n' "$MYENV"
bash -c 'printf "자식 셸: MYENV=%s\n" "$MYENV"'

unset MYENV
bash -c 'printf "unset 후 자식 셸: MYENV=%s\n" "${MYENV-<설정되지 않음>}"'
