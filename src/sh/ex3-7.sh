set -e

if [ "$#" -gt 1 ]; then
    echo '사용법: sh ex3-7.sh [폴더명]' >&2
    exit 1
fi
folder=${1-}
if [ -z "$folder" ]; then
    printf '폴더 이름: '
    IFS= read -r folder || exit 0
fi
case "$folder" in
    *[![:space:]]*) ;;
    *) echo '오류: 폴더 이름을 입력하세요.' >&2; exit 1 ;;
esac

mkdir -p -- "$folder"
folder=$(cd -- "$folder" && pwd -P)
printf '작업 폴더: %s\n' "$folder"

set --
for number in 1 2 3 4 5; do
    filename="file${number}.txt"
    filepath="$folder/$filename"
    if [ -L "$filepath" ] || { [ -e "$filepath" ] && [ ! -f "$filepath" ]; }; then
        printf '오류: 일반 파일로 사용할 수 없는 경로입니다: %s\n' "$filepath" >&2
        exit 1
    fi
    if [ ! -e "$filepath" ]; then
        (set -C; printf '실습 파일 %d\n' "$number" > "$filepath")
    fi
    set -- "$@" "$filename"
done

archive=$(mktemp "$folder/files.XXXXXX.tar.gz")
tar -czf "$archive" -C "$folder" -- "$@"
destination=$(mktemp -d "$folder/extracted.XXXXXX")
tar -xzf "$archive" -C "$destination"

printf '\n압축 파일: %s\n압축 해제 폴더: %s\n' "$archive" "$destination"
ls -l -- "$destination"
