import sys
sys.stdin = open('input.txt')

T = 10  # 이 문제는 테스트 케이스 수가 10개로 주어짐

for tc in range(1, T+1):
    input()  # input 첫번째는 문제 번호

    matrix = []
    for _ in range(100):  # column 100줄
        matrix.append(
            list(map(int, input().split()))  # row하나
        )

    print(f'#{tc}')