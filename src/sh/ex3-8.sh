set -e

if [ "$#" -gt 1 ]; then
    echo '사용법: sh ex3-8.sh [폴더명]' >&2
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

    subfolder="$folder/${filename%.txt}"
    if [ -L "$subfolder" ]; then
        printf '오류: 하위 폴더 경로가 심볼릭 링크입니다: %s\n' "$subfolder" >&2
        exit 1
    fi
    mkdir -p -- "$subfolder"
    linkpath="$subfolder/$filename"
    target="../$filename"

    if [ -L "$linkpath" ] && [ "$(readlink -- "$linkpath")" = "$target" ]; then
        printf '기존 링크: %s\n' "$linkpath"
    elif [ -e "$linkpath" ] || [ -L "$linkpath" ]; then
        printf '오류: 링크를 만들 위치에 다른 파일이 있습니다: %s\n' "$linkpath" >&2
        exit 1
    else
        ln -s -- "$target" "$linkpath"
    fi
    ls -l -- "$linkpath"
done
