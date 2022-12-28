import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N, M = (map(int,input().split()))
    numbers = list(map(int,input().split()))

    # 연속해서 더할수 있는 집합의 개수 규칙찾기(반복문 range를 위해서)
    # 10-3+1 = 8 // 10-5+1 = 6 // 20-19+1 = 2
    nums = N - M + 1
    max_sum = 0
    min_sum = sum(numbers[0:M])
    for i in range(nums):
        num_arr = numbers[i:(M+i)]
        if sum(num_arr) > max_sum:
            max_sum = sum(num_arr) # 1회차 0~3, 1~4, 2~5, 3~6, 4~7, 5~8, 6~9, 7~10 총 8번
        elif sum(num_arr) < min_sum:
            min_sum = sum(num_arr)

        ans = max_sum - min_sum

    print(f'#{tc} {ans}')