if [ "$#" -ne 2 ]; then
    echo "사용법: sh ex3-1.sh 정수1 정수2" >&2
    exit 1
fi

to_decimal() {
    digits=$1
    sign=1
    case "$digits" in
        -*) sign=-1; digits=${digits#-} ;;
        +*) digits=${digits#+} ;;
    esac
    case "$digits" in
        ''|*[!0-9]*)
            echo "오류: 두 인자는 모두 정수여야 합니다." >&2
            return 1
            ;;
    esac

    while [ "${digits#0}" != "$digits" ]; do
        digits=${digits#0}
    done
    printf '%s\n' "$((sign * ${digits:-0}))"
}

first=$(to_decimal "$1") || exit 1
second=$(to_decimal "$2") || exit 1

printf '%s + %s = %s\n' "$first" "$second" "$((first + second))"
printf '%s - %s = %s\n' "$first" "$second" "$((first - second))"
printf '%s * %s = %s\n' "$first" "$second" "$((first * second))"
if [ "$second" -eq 0 ]; then
    echo "나눗셈: 0으로 나눌 수 없습니다."
else
    printf '%s / %s = %s\n' "$first" "$second" "$((first / second))"
fi
