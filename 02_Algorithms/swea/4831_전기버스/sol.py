import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    K, N, M = (map(int, input().split()))
    numbers = list(map(int, input().split()))
    numbers.append(N)  # 충전소 위치에 마지막 N번 정류장도 추가
    battery = K - numbers[0]  # 완충상태 - 첫 충전소까지 이동거리
    ans = 0
    for idx in range(M):
        len_next_gas_stn = numbers[idx+1] - numbers[idx]
        if battery - len_next_gas_stn >= 0:
            battery -= len_next_gas_stn
        elif len_next_gas_stn > K:  # 다음 충전소까지의 거리가 최대 이동 가능 거리보다 크면
            ans = 0
            break
        elif battery - len_next_gas_stn < 0:
            battery = K  # 배터리 K만큼 완충. 초과 ㄴㄴ
            battery -= len_next_gas_stn
            ans += 1

    print(f'#{tc} {ans}')
