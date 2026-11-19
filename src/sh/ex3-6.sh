show_files() {
    printf '함수 실행됨'
    ls "$@"
}

show_files "$@"
