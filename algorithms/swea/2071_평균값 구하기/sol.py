import sys
sys.stdin = open('input.txt')

T = int(input())

def solve(numbers):
    avg = 0
    sum = 0
    cnt = 0
    for num in numbers:
        sum += num
        cnt += 1
        avg = sum / cnt
        
    return avg

for tc in range(1, T+1):
    numbers = list(map(int, input().split()))
    answer = solve(numbers)
    print(f'#{tc} {answer}')