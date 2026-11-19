set -e

script_dir=$(cd -- "$(dirname -- "$0")" && pwd -P)
db_file="$script_dir/DB.txt"

tab=$(printf '\t')
valid_field() {
    case "$1" in
        *"$tab"*) return 1 ;;
        *[![:space:]]*) return 0 ;;
        *) return 1 ;;
    esac
}

while true; do
    printf '\n==============================\n'
    echo '1) 팀원 정보 추가'
    echo '2) DB를 처음부터 다시 작성'
    echo '3) 종료'
    echo '=============================='
    printf '메뉴 선택: '
    read -r choice || break

    case "$choice" in
        1|2)
            if [ "$choice" = 2 ]; then
                echo '새 정보를 저장하면 기존 기록이 모두 교체됩니다.'
            fi
            printf '팀원 이름: '
            read -r name || break
            printf '생일 또는 전화번호: '
            read -r info || break
            if ! valid_field "$name" || ! valid_field "$info"; then
                echo '오류: 이름과 정보를 입력하세요. 탭 문자는 사용할 수 없습니다.'
                continue
            fi

            if [ "$choice" = 1 ]; then
                printf '%s\t%s\n' "$name" "$info" >> "$db_file"
            else
                temp_file=$(mktemp "$script_dir/.DB.XXXXXX")
                trap 'rm -f -- "$temp_file"' 0
                printf '%s\t%s\n' "$name" "$info" > "$temp_file"
                mv -f -- "$temp_file" "$db_file"
                trap - 0
            fi
            printf '저장 완료: %s / %s\nDB 파일: %s\n' "$name" "$info" "$db_file"
            ;;
        3)
            echo '프로그램을 종료합니다.'
            break
            ;;
        *) echo '오류: 1~3 중에서 선택하세요.' ;;
    esac
done
