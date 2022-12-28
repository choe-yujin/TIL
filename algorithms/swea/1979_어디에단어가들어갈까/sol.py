import sys
sys.stdin = open('input.txt')

T = int(input())

for tc in range(1, T+1):
    N, K = map(int, input().split())
    ans = 0  # 단어 자리 개수 카운트용
    puzzle = [] 
    for _ in range(N):
        puzzle.append(list(map(int, input().split())))  # 받아 오기
    
    def K_check(puzzle_set):  # 똑같은 작업 퍼즐셋 두번 할꺼라 함수화 함
        global ans  # 아래 ans +=1에서 변수 인식 못하길래 global ans라고 정의해 줌
        for r in puzzle_set:
            cnt = 0  # 단어 길이 카운트용
            for i in range(N):
                if r[i] == 1:
                    cnt += 1
                elif r[i] == 0:
                    if cnt == K:  # 0으로 끝날때도 다음 단어 길이 재러가기 전 cnt==K조건 확인
                        ans += 1  
                    cnt = 0
            if cnt == K:
                ans += 1  # 0 만나지 않았으면 cnt==K 체크 아직 못했으니 다음 루프가기전에도 조건 확인
    
    K_check(puzzle)  # 오리지날 퍼즐
    rotated_puzzle = list(zip(*puzzle))
    K_check(rotated_puzzle)  # 열을 행으로 바꾼 퍼즐

    print(f'#{tc} {ans}')
