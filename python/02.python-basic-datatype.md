# 파이썬 프로그래밍의 기초 - 자료형

**22년 12월 14일 (수)**

## Jupyter Notebook 설치

pip는 파이썬에 딸려오는 다운로더

`$ pip install jupyter`

`$ which python`

` $ jupyter notebook`

크롬 설정 모양-글꼴-고정폭 글꼴-`consolas`



**Keyboard shortcuts  for Jupyter Notebook**

| 단축키                         | 의미                           |
| ------------------------------ | ------------------------------ |
| a(above)                       | 위로 새 셀 생성                |
| b(below)                       | 아래로 새 셀 생성              |
| dd                             | 지우기                         |
| z                              | 되돌리기                       |
| ctrl + Enter                   | 실행                           |
| shift + Enter                  | 실행 + 새 셀 만들기            |
| y                              | 마크다운을 코드블럭 모드로     |
| m                              | 마크다운 모드로                |
| Kernel-Restart &  Clear Output | 코드는 그대로. 실행결과 지우기 |
| 00                             | Restart Kernel                 |



---

## Python 기초

### 식별자

*이름과 값을 구분하는 것이 중요하다.*

- 아래의 예약어를 제외하고 이름을 지을 수 있다.
- 내장함수나 모듈 등의 이름으로도 만들면 안된다.

```
import keyword
print(keyword.kwlist)
```



### 주석(Comment)

```
# 이것은 주석입니다.

def my_sum(x, y):
    """이 함수는 인자 x와 y를 더합니다.
    더한 값을 리턴합니다.
    이런 주석을 docstring 이라고 부릅니다."""
    return x + y
    
my_sum.__doc__
print.__doc__
```



### 변수(variable) 및 자료형

- 변수는 `=`을 통해 할당(assignment)된다.
- 해당 자료형을 확인하기 위해서는 `type()`을 활용한다.
- 해당 값의 메모리 주소를 확인하기 위해서는 `id()`를 활용한다.



변수(박스)에 값을 담을 수 있다.

그럼 변수에 어떤 종류의 값이 들어갈 수 있나요?

1. 숫자형(Numbers)
   - `int`정수(integer)
   - `float`실수(floating point numbers)
   - `complex`복소수(complex)
2. 문자(String)
3. O/X(Boolean)
4. 비어있음



**왜 python상에서 int의 sys.maxsize는 9223372036854775807인가?**

힌트! 파이썬 설치할 때 64bit 다운 받았음.

-> 64bit - 1bit(맨 앞자리는 음수 양수 부호) 2 ^ (64-1)



**32bit 컴퓨터에서는 왜 4GB 크기까지의 램만 인식될까?**

```
bit = (2 ** (32-1)) # bit
byte = bit / 8
kb = byte / 1024
mb = kb / 1024
gb = mb / 1024

gb * 16 
```

**램 Random Access Memory ?**

왜 Random? 책상에 차례대로 물건을 두지 않듯이.



CPU는 두뇌. 두뇌가 좋으면 손놀림이 빨라 일 처리가 빠르다.

RAM는 작업대. 손놀림이 빨라도 작업대가 작으면 일 처리가 느리다.

32bit는 4GB 메모리 인식 한계를 가지고 있다.



**실생활에서 쓰이는 16진수**

0xffffff 흰색

0x는 16진수 의미

R : ff(255)

G : ff(255)

B : ff(255)



**변수와 매칭이 벗어난 값들은 안 없어지고 메모리에 계속 남아있나요?**

garbage collecting ! C, C++, go언어는 이걸 수동으로 해주었어야 하지만 그 후 언어들은 이름과 묶여져 있지 않는 값의 lock을 자동으로 푼다. 

 `del 변수명`변수 저장 목록에서 변수를 없애는거

