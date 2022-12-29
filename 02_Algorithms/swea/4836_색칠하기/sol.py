import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N = int(input())
    matrix = [[0 for _ in range(10)] for _ in range(10)]
    cnt_purple = 0
    # 색칠 시작
    for _ in range(N):

        #r1, c1, r2, c2, color = map(int, input().split())
        info = list(map(int, input().split()))  # [2, 2, 4, 4, 1] = [시작r, 시작c, 끝r, 끝c, 컬러]
        start_row = info[0]
        start_col = info[1]
        end_row = info[2]
        end_col = info[3]
        color = info[4]

        for r in range(start_row, end_row+1):
            for c in range(start_col, end_col+1):
                matrix[r][c] += color
                if matrix[r][c] == 3:
                    cnt_purple += 1

    print(f'#{tc} {cnt_purple}')
