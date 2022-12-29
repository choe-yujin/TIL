import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N, K = (map(int, input().split()))  # 부분 집합 원소 개수, 원소의 합
    cnt = 0
    a_set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]  # 주어진 집합
    n = len(a_set)  # 집합의 원소 수

    for i in range(2**n):  # 4096행. 원소가 n개일 경우 생성 가능한 모든 부분 집합의 개수
        subset = []  # 부분 집합 원소 담을 리스트 준비
        for j in range(n):  # 원소.열 / 원소의 수만큼 비트를 비교. 원소 포함 여부 판단
            if i & (1 << j):  # i의 j번째 비트가 1이면
                subset.append(a_set[j])  # j번째 원소를 subset리스트에 추가
        if len(subset) == N and sum(subset) == K:  # 완성된 부분집합의 원소개수가 N이며 원소합이 K일 경우
            cnt += 1  # 카운트

    print(f'#{tc} {cnt}')  # 최종 카운트 출력
