# github 설정

1. Settings - Repositories - main을 master로 바꿔주기

   (BLM[Black Lives Matter] 조지플로이드 흑인과잉진압 사건때문에 깃허브에서 master라는 이름이 불편해 main으로 바뀌게 되었다.)

2. New Repository 생성

   내 컴퓨터 상의 Local Repository name과 깃허브의 Repository name은 꼭 같지 않아도 됨

3. Local Repo와 깃허브 Repo 연결하기

   `git remote add origin https://github.com/choe-yujin/TIL.git`

   = git님 remote원격저장소를 add추가할게요. (origin은 깃허브 repo 주소의 별명)깃허브 repo주소값에.

​			`git remote add`는 고정되는 명령어. 뒤에 별칭과 주소는 바뀔 수 있다.

4. 동기화 

   자동 동기화는 안 됨.

   `git push origin master` 내 local Repo를 깃허브에 올린다는 명령어

   = git님 push올릴게요. origin이라고 별칭 붙인 깃허브 repo 주소값에.



