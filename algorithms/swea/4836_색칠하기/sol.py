import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N = int(input())
    matrix = [[0 for _ in range(10)] for _ in range(10)]
    # 색칠 시작
    for _ in range(N):
        map(int, input().split())  # [1, 1, 3, 3, 1] = [시작r, 시작c, 끝r, 끝c, 컬러]

    print(f'#{tc}')