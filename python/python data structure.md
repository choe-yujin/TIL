# 자료 구조

**22년 12월 26일 (월)**



## Array(기본)

파이썬에는 Array가 없다. Numpy는 파이썬에서 없는 Array를 가져와서 쓰니가 좋음. Pandas는 Numpy가 기초임.

- Array는 모든 칸에 들어가 있는 data type이 같다.

- 생성할 때 몇 칸 짜리인지 미리 정해줘야 한다.(**R**andom **A**ccess **M**emory라서 다른 애들이 침범해오니까 미리 선점해두는 것. 옆 칸이니까 빠르다.)



## list(업그레이드)

| 장점                                                         | 단점                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 동적인 메모리 크기                                           | 중간 삭제시 연결이 끊어지니까 삭제 전 연결 값들을 먼저 수정하고 지워야해서 비효율적이다. |
| 메모리를 더 효율적으로 쓸 수 있기 때문에 대용량 데이터 처리에 적합 | 중간 추가시 연결이 끊어지니까 추가 전 연결 값들을 먼저 수정하고 추가해야해서 비효율적이다.(맨 뒤 추가하는 append는 괜찮음. pop은 자제하자.) |

## 1. Linked list

- 첫번째 값에 두번째 값을 연결. 두번째 값에 세번째 값을 연결....
- 리스트는 첫번째 값 주소 저장. 첫번째 값은 첫번째 값 + 두번째 값의 주소 저장... 마지막 값은 마지막 값 + None
- 뒤로는 갈 수 있는데 앞으로는 못 온다. 이를 보완한 게 Double linked list



## 2. Double linked list

- 앞 뒤를 왔다갔다 하고 싶으면
- 두번째 값은 두번째 값 + 첫번째 값의 주소 + 세번째 값의 주소 저장



## 3. Circular linked list

- [-1]로 맨 뒤의 값에 접근하고 싶으면?
- 원처럼 맨 앞에 맨뒤의 주소값 맨뒤에 맨앞의 주소값 저장



---

### PyCharm 설정

- Ctrl + Alt + S : 환경설정
  - Font - JetBrain Mono
  - Python Interpreter가 파이썬 3.10으로 잡혀있는지 확인 - 클릭해서 목록에 없으면 Add local Interpreter- System Interpreter-`~/.pyenv/shims/python` 파이썬 ok
  - Terminal - Shell path : git bash
- Alt + F12 : 터미널창 



### 네이밍 규칙

- 함수 => 동사(함축적으로)
- list => numbers / chars / coordinates 
- list => 복수형으로
- 변수 => 담긴 값이 True/False일 경우는 is_xxx
- 함수 => return값이 True/False일 경우 => is_xxx()
