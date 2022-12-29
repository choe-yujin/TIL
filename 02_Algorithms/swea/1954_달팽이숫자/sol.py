import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N = int(input())
    di = []
    dj = []

    for n in range(N, 0, -1):
        for _ in range(n):
            di.append(0)
            dj.append(1 - 2 * ((N - n) % 2))
        for _ in range(n-1):
            di.append(1 - 2 * ((N - n) % 2))
            dj.append(0)

    snail = [[0] * N for _ in range(N)]
    i = j = 0
    for n in range(1, N * N + 1):
        if n == 1:
            snail[i][j] = 1
        else:
            i += di[n - 1]
            j += dj[n - 1]
            snail[i][j] = n

    print(f'#{tc} {snail}')
