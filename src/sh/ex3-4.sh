export LC_ALL=C
scores=''
count=0

show_average() {
    printf '%s' "$scores" | awk -v mode="$1" '{
        total += $1
    } END {
        average = total / NR
        printf "평균 점수: %.2f점\n", average
        if (mode == "gpa") {
            if      (average >= 95) { grade = "A+"; gpa = 4.5 }
            else if (average >= 90) { grade = "A0"; gpa = 4.0 }
            else if (average >= 85) { grade = "B+"; gpa = 3.5 }
            else if (average >= 80) { grade = "B0"; gpa = 3.0 }
            else if (average >= 75) { grade = "C+"; gpa = 2.5 }
            else if (average >= 70) { grade = "C0"; gpa = 2.0 }
            else if (average >= 65) { grade = "D+"; gpa = 1.5 }
            else if (average >= 60) { grade = "D0"; gpa = 1.0 }
            else                      { grade = "F";  gpa = 0.0 }
            printf "평균 등급: %s, GPA: %.1f / 4.5\n", grade, gpa
        }
    }'
}

while true; do
    printf '\n===================\n'
    echo "1) 과목 성적 추가"
    echo "2) 입력된 모든 점수 보기"
    echo "3) 평균 점수 확인"
    echo "4) 평균 등급 (GPA) 변환"
    echo "5) 종료"
    echo "==================="
    printf "메뉴 선택: "
    read -r choice || break

    case "$choice" in
        1)
            printf "추가할 점수 (0~100): "
            read -r score || break
            if ! printf '%s\n' "$score" | awk '
                { exit !($0 ~ /^[0-9]+([.][0-9]+)?$/ && $0 + 0 <= 100) }
            '; then
                echo "오류: 0~100 범위의 숫자를 입력하세요."
                continue
            fi
            scores="${scores}${score}
"
            count=$((count + 1))
            printf '%d번 과목에 %s점을 추가했습니다.\n' "$count" "$score"
            ;;
        2|3|4)
            if [ "$count" -eq 0 ]; then
                echo "먼저 과목 성적을 추가하세요."
                continue
            fi
            case "$choice" in
                2)
                    printf '%s' "$scores" | awk '{
                        printf "%d번 과목: %s점\n", NR, $0
                    }' 
                    ;;
                3) show_average score ;;
                4) show_average gpa ;;
            esac
            ;;
        5)
            echo "프로그램을 종료합니다."
            break
            ;;
        *) echo "오류: 1~5 중에서 선택하세요." ;;
    esac
done
