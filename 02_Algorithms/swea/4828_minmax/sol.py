import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N = int(input())
    numbers = list(map(int, input().split())) #['477162, 65880, 751280 927930 297191']

    #max_value = max(numbers)
    #min_value = min(numbers)
    #max_value = 0
    #min_value = numbers[0]
    max_value = min_value = numbers[0]

    for n in numbers:
        if n > max_value:
            max_value = n
        elif n < min_value:
            min_value = n

    ans = max_value - min_value
    print(f'#{tc} {ans}')