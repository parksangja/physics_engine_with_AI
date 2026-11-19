export LC_ALL=C

while true; do
    printf '\n==============================\n'
    echo "1) 사용자 정보"
    echo "2) CPU 사용률 확인"
    echo "3) 메모리 사용량 확인"
    echo "4) 디스크 사용량 확인"
    echo "5) 종료"
    echo "=============================="
    read -r -p "메뉴 선택: " choice || break

    case "$choice" in
        1)
            echo "[현재 사용자]"
            whoami
            echo "[사용자 ID 및 소속 그룹]"
            id
            echo "[로그인한 사용자 목록]"
            who
            ;;
        2)
            echo "[CPU 사용률 및 프로세스 정보]"
            if command -v top >/dev/null 2>&1; then
                top -b -n 1 | head -n 12
            else
                echo "top 명령을 찾을 수 없습니다. procps가 설치된 Linux에서 실행하세요."
            fi
            ;;
        3)
            echo "[메모리 및 스왑 사용량]"
            if command -v free >/dev/null 2>&1; then
                free -h
            else
                echo "free 명령을 찾을 수 없습니다. procps가 설치된 Linux에서 실행하세요."
            fi
            ;;
        4)
            echo "[파일 시스템별 디스크 사용량]"
            df -h
            ;;
        5)
            echo "프로그램을 종료합니다."
            break
            ;;
        *) echo "오류: 1~5 중에서 선택하세요." ;;
    esac
done
