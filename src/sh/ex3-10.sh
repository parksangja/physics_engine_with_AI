set -e

script_dir=$(cd -- "$(dirname -- "$0")" && pwd -P)
db_file="$script_dir/DB.txt"

if [ "$#" -gt 1 ]; then
    echo '사용법: sh ex3-10.sh [검색할 이름]' >&2
    exit 1
fi
if [ ! -f "$db_file" ]; then
    echo 'DB.txt가 없습니다. 먼저 ex3-9.sh로 팀원 정보를 기록하세요.' >&2
    exit 1
fi

name=${1-}
if [ -z "$name" ]; then
    printf '검색할 이름 또는 이름의 일부: '
    read -r name || exit 0
fi
case "$name" in
    *[![:space:]]*) ;;
    *) echo '오류: 검색할 이름을 입력하세요.' >&2; exit 1 ;;
esac

SEARCH_NAME="$name" awk -F '\t' '
    index($1, ENVIRON["SEARCH_NAME"]) > 0 {
        printf "이름: %s / 정보: %s\n", $1, $2
        count++
    }
    END {
        if (count == 0) print "검색 결과가 없습니다."
        else printf "총 %d명 검색되었습니다.\n", count
    }
' "$db_file"
