import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N = int(input())
    numbers = list(input())
    card_set = set()
    card_dict = dict()
    for n in numbers:
        if n in card_set:
            card_dict[n] += 1
        elif n not in card_set:
            card_set.add(n)
            card_dict[n] = 1
    card_dict = sorted(card_dict.items(), key=lambda x: x[1], reverse=True)  # value 큰 순으로 튜플로 정렬
    card_dict.sort(key=lambda x:(x[1], x[0]), reverse=True)  # 튜플의 두번째 원소로 우선 정렬 후 첫번째 원소로 정렬. 순서 뒤바꾸기
    print(f'#{tc} {card_dict[0][0]} {card_dict[0][1]}')  # 첫번째 튜플의 key와 카운트 수 출력
