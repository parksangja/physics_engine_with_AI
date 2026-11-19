export LC_ALL=C

while true; do
    echo "x 값을 두 개 이상 입력하세요. (예: 2 -3 1.5)"
    IFS= read -r values || exit 0
    if printf '%s\n' "$values" | awk '
        NF < 2 {
            print "오류: 값을 두 개 이상 입력해야 합니다."
            exit 1
        }
        {
            for (i = 1; i <= NF; i++) {
                if ($i !~ /^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$/) {
                    print "오류: 정수 또는 소수만 입력하세요."
                    exit 1
                }
            }
            for (i = 1; i <= NF; i++) {
                printf "x = %s, y = %.10g\n", $i, 0.5 * $i * $i
            }
        }
    '; then
        break
    fi
done
