#  주석이 있는 답
import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    K, N, M = (map(int, input().split()))
    numbers = list(map(int, input().split()))
    numbers.append(N)  # 충전소 위치에 마지막 N번 정류장도 추가
    battery = K - numbers[0]  # 완충상태 - 첫 충전소까지 이동거리
    ans = 0
    cnt = 1
    for idx in range(M):
        len_next_gas_stn = numbers[idx+1] - numbers[idx]  # 3-1, 5-3, 7-5, 9-7, 10-9// 3-1, 7-3, 8-7, 9-7, 10-9
        print(f'현재 충전소 위치{numbers[idx]}, 다음충전소 위치{numbers[idx+1]}')
        print(f'{cnt}번째 루프 | 충전횟수:{ans}, 갈수있는거리:{battery}, 다음 충전소까지 남은거리:{len_next_gas_stn}')
        if battery - len_next_gas_stn >= 0:  # 3 - 3-1
            print(f'갈 수 있는 거리{battery} - 다음 충전소까지 남은거리{len_next_gas_stn}')
            battery = battery - len_next_gas_stn
            print(f'= 갈 수 있는 거리:{battery}, 다음 충전소까지 남은거리:{len_next_gas_stn}')
            print('========================')
        elif len_next_gas_stn > K:  # 다음 충전소까지의 거리가 최대 이동 가능 거리보다 크면
            ans = 0
            break
        elif battery - len_next_gas_stn < 0:
            battery = K  # battery += K로 배터리 용량보다 크게 충전하는 실수했음. 배터리 완충 초과 못하니 battery = K로
            print(f'충전 후 갈 수 있는 거리{battery} - 다음 충전소까지 남은거리{len_next_gas_stn}')
            battery = battery - len_next_gas_stn
            ans += 1
            print(f'= 갈 수 있는 거리:{battery}, 다음 충전소까지 남은거리:{len_next_gas_stn}, 충전횟수:{ans}')
            print('========================')
        cnt += 1

    print(f'#{tc} {ans}')
