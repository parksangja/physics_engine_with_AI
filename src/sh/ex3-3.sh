export LC_ALL=C

while true; do
    echo "두 과목 이상의 점수를 공백으로 구분하여 입력하세요. (0~100)"
    IFS= read -r scores || exit 0
    if printf '%s\n' "$scores" | awk '
        NF < 2 {
            print "오류: 두 과목 이상의 점수가 필요합니다."
            exit 1
        }
        {
            for (i = 1; i <= NF; i++) {
                if ($i !~ /^[0-9]+([.][0-9]+)?$/ || $i + 0 > 100) {
                    print "오류: 모든 점수는 0~100 범위의 숫자여야 합니다."
                    exit 1
                }
            }
            for (i = 1; i <= NF; i++) {
                grade = ($i + 0 >= 90) ? "A" : "B"
                printf "%d번 과목: %s점, %s등급\n", i, $i, grade
                total += $i
            }
            average = total / NF
            printf "평균 점수: %.2f점\n", average
            printf "평균 등급: %s\n", (average >= 90) ? "A" : "B"
        }
    '; then
        break
    fi
done
