# 파이썬 코드 리뷰 스터디

**22년 12월 18일(일)**  **14시 ~ 18시 / 12월 20일(화) 추가 코드**

장소 : 종로 시간공방 스터디룸 F3

참여인원 : 김현수, 김주환, 문경민, 최민정, 최유진



## 1. 모음 제거

>  주어진 문장에서 모음만 제거한 새로운 문자열을 출력한다.

**나의 접근 방법** 

1. 모음 aiueo를 따로 리스트에 담아둔다. 

   `vowel = ['a','i','u','e','o']`

2. 새롭게 문자열을 담기 위한 빈 문자열 리스트를 미리 만들어 둔다.

3. 주어진 문장의 첫 문자부터 모음 리스트의 모음 하나하나와 비교한다.

4. 문자가 모음리스트에 없으면 새로운 리스트에 해당 문자를 담는다.

   문자가 모음이면 새 문자 리스트에 담지 않고 주어진 문장의 다음 글자 비교 loop로 넘어가기

5. 리스트에 담겨진 문자열을 하나의 str으로 변환시킨다. (join함수)

   

**강사님 접근 방법**

1. 모음 리스트를 따로 담아두지 않고 `if-in`을 활용. `if char in 'aiueo'` 

2. `new_str = ''`  `new_str += char` 문자열 더하기 연산을 활용

   

**※ 포인트!** 

- 문자열 자체가 배열이니까 비교를 위한 리스트가 따로 필요없다

- 파이썬은 string 더하기 연산이 가능하다. string 더하기 위한 리스트가 따로 필요없다.

  

## 2. 영어 이름 출력하기

>  영어 이름 가운데 이름은 대문자로 축약해서 나타내는 코드 작성하기

**나의 접근 방법**

1. first name과 last name은 스펠링 전부 출력이고 middle name만 첫 스펠링으로 축약하면 된다.

2. middle name이 몇 개일지 모르므로 last name의 index를 구해놓는다.

3. `new_name += names[0] + ' '` first name과 공백을 우선 붙인다

4. ```python
   name = 'Benicio Monserrate Rafael Del Toro Sanchez'
   names = name.split()
   idx_lastname = len(names) - 1  # 이름이 몇 덩어리인지 확인하기위해 마지막 덩어리의 인덱스 얻기
   new_name = ''
   i = 0
   
   new_name += names[0] + ' '  # first name을 new_name에 넣어라
   for name in names:
       if i != 0 and i != idx_lastname:  # 이름 덩어리 중 first name과 last name이 아니면, 즉 미들네임이 있으면
           new_name += name[0] + '. '  # 해당 이름의 인덱스 중 첫번째 글자에 .을 붙여 new_name에 붙여라
       i += 1  # 다음 이름 덩어리가 있나 체크하기 위함
   ```

5. `new_name += names[idx_lastname]` last name을 붙인다 



**강사님 접근 방법**

```python
# enumerate가 요소를 함께 출력한다는 것을 활용
new_name = ''
for idx, name in enumerate(names, start=1):  #idx와 요소가 같이 나오는 enumerate 활용
    if idx != 1 and idx != len(names):
        new_name += f'{name[0]}. '
    else:
        new_name += f'{name[0]. '
print(new_name)
```

- enumerate가 요소를 함께 출력한다는 것을 활용
- .을 붙일때 f-string 활용

```python
# 선생님코드 list는 mutable하다는 것을 활용
for idx in range(1, len(names)- 1):
    names[idx] = f'{names[idx][0]}. '
    
print(' '.join(names))
```

- 반복문을 전체 다 순회하지 않고 처음, 끝을 제외하고
- list는 mutable하다는 것을 활용



**민정님 접근 방법**

```python
short_name = ''

for idx in range(len(names)):
    if names[idx] in names[1: len(names)-1]:
        short_name += names[idx][0] + '. '
    else:
        short_name += names[idx] + ' '
print(short_name)
```

1. for문 range활용. loop 범위를 0~이름 끝까지로 정함
2. if문의 in 범위를 slicing 활용해 2번째~ 마지막 이전까지로 정했다.
3. else문은 리스트 index의 0번째, 마지막이 된다. 즉, fist name, last name

**※ 포인트**

- for문 range를 잘 활용하면 index를 셀 전역변수를 안 써도 된다.
- `enumerate()` 를 활용하면 idx와 요소를 함께 활용할 수 있다.
- if문도 조건이 아닌 `if - in` 을 활용해서 index 범위를 줄일 수 있다. 



## 3. 개인정보 보호

> 사용자의 핸드폰번호를 입력 받고, 개인정보 보호를 위하여 뒷자리 4자리를 제외하고는 마스킹 처리하세요.
>
> - 핸드폰번호는 010으로 시작해야하고 11자리여야한다.
> - 핸드폰번호를 입력하지 않았다면 "핸드폰번호를 입력하세요"를 출력한다.

**나의 접근 방법**

```python
len_phone = ''
while not len_phone:  # 폰번호에 입력값이 있다면 True 입력값이 없다면 False / False 아닐때까지 반복해 / True 일때까지 반복해
    phone_num = input('핸드폰번호를 입력하세요 ')
    len_phone = len(phone_num)  # 폰번호 자리수
    check_010 = phone_num[0:3]  # 폰번호 앞 세자리 
    if len_phone == False:  # 만약 폰번호가 입력되지 않았다면
        continue  # 반복문 다시 돌리세요(폰번호 input 받으세요)
    elif check_010 != '010' or len_phone != 11:  # 만약 폰번호 앞자리가 010이 아니거나 11자리수가 아니라면
        print('휴대폰번호가 아닙니다. 안녕')
    else:
        print('*'*7 + phone_num[7:])  # 어느 경우도 아니라면 앞 7자리는 *로 처리하세요
```

- loop 조건을 loop 안에서 걸기 위해서 while문을 썼다.

- 11자리, 010 아닐때는 * 처리도 하지 않도록 예외처리를 했다.

- continue를 써서 사용자가 입력할 때까지 input을 받게 했다.

  

**현수님 접근 방법**

```python
while True:
  phone_num = input()
  if phone_num[0:3] != '010' and len(phone_num) != 11:
    print('핸드폰번호를 다시 입력해주세요')
  else:
    print(phone_num.replace(phone_num[0:11-4],'*'*7))
    break
```

- 문자열 슬라이싱을 활용했다.
- '*' 를 7번 곱하기. str 연산이 가능한 것을 잘 활용했다.
- 아쉬운점은 예외처리를 하지 않아서 11자리가 넘어가도 *7개를 처리하고 나머지 숫자들이 출력된다.

**민정님 접근 방법**

`print('*' * 7 + phone_num[len(phone_num)-4:len(phone_num)])`

- 현수님과 마찬가지로 '*' * 7 으로 처리
- 슬라이싱 활용

**※ 포인트**

- 문자열 슬라이싱이 한눈에 들어오지 않는다. 좀 더 공부하자.
- 문자열 * + 연산 가능한 것을 활용하자.

## 4. 정중앙

> 사용자가 입력한 문자열중 가운데 글자를 출력하세요.
>
> - 단, 문자열이 짝수라면 가운데 두글자를 출력하세요.

**나의 접근 방법**

```python
chars = input('문자열을 입력하세요')
len_chars = len(chars)

mid_idx = len_chars // 2

if len_chars % 2 != 0:
    print(chars[mid_idx])
else:
    print(chars[mid_idx - 1] + chars[mid_idx])
```

- 입력받은 문자열의 길이 // 2로 가운데 몫을 구했다.
- `len_chars % 2 != 0`  나머지가 0이 아니면, 즉, 홀수라면
  - 몫을 바로 출력한다. ex) 5 // 2 = 2 [0] [1] **[2]** [3] [4]

- else 나머지가 0이면, 즉, 짝수라면
  - `chars[mid_idx - 1] + chars[mid_idx]`
  - ex) 4 // 2 몫이 2. [ 2 - 1 ] + [ 2] |  [0] **[1]** **[2]** [3] 

**현수님 접근 방법**

```python
char_str = input()
div = len(char_str)//2

if len(char_str) % 2 == 0:
    print(char_str[div-1:div+1])
else:
    print(char_str[div])
```

- 문자열 슬라이싱을 활용 `char_str[div-1:div+1]`

**민정님 접근 방법**

```python
strings = input('문자열을 입력하세요. : ')

strings_len = len(strings) // 2  # 입력한 문자열의 길이를 절반으로 나눈 몫을 저장하고

if len(strings) % 2:  # 만약 문자열 길이가 홀수라면,
    print(strings[strings_len])  # 가운데 문자에 해당되는 index로 출력한다.
else:  # 만약 짝수라면,
    print(strings[strings_len - 1 : strings_len + 1])  # 가운데 2개의 문자에 해당되는 index로 출력한다.
```

- 문자열 슬라이싱을 활용 `strings[strings_len - 1 : strings_len + 1]`

**※ 포인트**

- 현수님과 민정님 모두 문자열 슬라이싱을 활용해 가운데를 출력했다.

## 5. 소수 판별

```python
numbers = [26, 39, 51, 53, 57, 79, 85, 121, 38239853]

for num in numbers:
    for d_num in range(2, (num // 2)):  # 2부터 확인할 수를 반으로 나눈 값의 -1 까지의 범위
        if num % d_num == 0:  # 26 / 2
            print(f'{num} 는 소수가 아닙니다. {d_num} 는 {num} 의 인수입니다.')
            break
    else:
        print(f'{num} 는 소수입니다.')
```

**나의 접근 방법**

1. 두 수를 곱한 수가 해당 숫자가 나오는 식으로 소수를 판별한다.

   ex) 26 | 1x26, 2x13 | 1, 2, 13, 26

2. loop범위 설정 - 1은 모든 수가 가지는 인수니까 제외하고 2부터 시작한다.

   해당 수 / 2 = 0 나머지가 없다면 => 소수

3. 처음엔 `range(2, num)` 까지 했다가 해당 수의 반 이상은 해당수로 나눠봤자 실수가 나오므로 loop는 `range(2, num // 2)` 2로 나눈 몫 즉, 반으로 제한했다.

   

**강사님 접근 방법**

```python
numbers = [26, 39, 51, 53, 57, 79, 85, 121, 38239853, 104831, 909091]

for num in numbers:
    for d_num in range(2, int(num**0.5)):
        if num % d_num == 0:
            print(f'{num} 는 소수가 아닙니다. {d_num} 는 {num} 의 인수입니다.')
            break  # 하나만 나와도 소수가 아니니까 break
    else:
        print(f'{num} 는 소수입니다.')
```

- 체크할 범위를 제곱근으로 정했다.



**현수님, 민정님 접근 방법**

```python
numbers = [26, 39, 51, 53, 57, 79, 85]

primes = [2, 3, 5, 7]  # 소수인지 판별할 숫자 리스트 생성

for number in numbers:
      for prime in primes:
            prime_tf = bool(number % prime)  # 나머지가 있으면 True, 없으면 False로 변환해서 boolean 형태로 저장
            if prime_tf == False:  # 만약 소수가 아니라면,
                  print(f'{number} 는 소수가 아닙니다. {prime} 는 {number} 의 인수입니다.')  # 소수가 아니라고 출력
                  break
      if prime_tf == True:  # 만약 소수라면,
            print(f'{number} 는 소수입니다.')  # 소수라고 출력
```

- 소수를 판별한 숫자 리스트를 따로 만들어서 비교해나갔다.
- 이 경우 121은 소수로 판별한다고 나왔다. 인수가 11인데 primes 리스트에 담아두지 않았기 때문이다.
- `bool(number % prime)` 나머지가 없으면 0이므로 False, 나머지가 있으면 숫자가 들어가 있으므로 True 인것을 활용 bool로 형변환을 한 것이 신선했다.

**※ 포인트**

- 두 수가 묶이니 loop 범위를 제곱근으로 정했다.
- bool도 형변환해서 활용해볼 수 있다.
- 이 문제는 인수가 하나라도 나오면 거기서 loop를 끝내고 소수가 아니라고 판별한다. 모든 인수를 구하는 로직을 짜보고 싶다는 생각을 했다. 

```python
# 소수 판별 및 인수 리스트 구하기 / 22년 12월 20일 추가
numbers = [26, 39, 51, 53, 57, 79, 85,21353]

for num in numbers:
    insu_list = [num]
    for d_num in range(2, num // 2 + 2): #2때문에 +2 함. if d_num < min(insu_list): for문에 if넣을 수 있나?
        x, y = divmod(num, d_num)  # 몫, 나머지
        if d_num > min(insu_list): # 나눌 인수가 이미 넣어둔 인수보다 커지면
             insu_list.append(1)
             break
        if y == 0:
            insu_list.append(x)
    if len(insu_list) == 1:
        print(f'{num}은 소수입니다')
    else:
        insu_list.sort()
        print(f'{num}의 인수리스트는 {insu_list}입니다') # .sort()를 그대로 프린트 하면 왜 result가 None?
```



## 6.로또

**나의 접근 방법**

```python
# 첫번째 풀이
my_numbers = [2, 15, 26, 29, 34, 45]
jackpot_numbers = [26, 15, 29, 43, 2, 34]
bonus_number = 45

cnt = 0
for my_num in my_numbers: 
    if my_num in jackpot_numbers:  
        cnt += 1
        continue
        
if cnt == 6:
    print('1등입니다')
elif cnt == 5:
    if bonus_number in my_numbers:
        print('2등입니다')
    else:
        print('3등입니다')
elif cnt == 4:
    print('4등입니다')
elif cnt == 3:
    print('5등입니다')
else:
    print('꽝')
```

```python
# 경민님에게 set 인사이트 얻고 set으로 풀어본 경우
my_numbers = set([26, 15, 29, 43, 2, 45])
jackpot_numbers = set([26, 15, 29, 43, 2, 34])
bonus_number = 45

chk = len(my_numbers.intersection(jackpot_numbers))

if chk == 6:
    print('1등입니다')
elif chk == 5:
    if bonus_number in my_numbers:
        print('2등입니다')
    else:
        print('3등입니다')
elif chk == 4:
    print('4등입니다')
elif chk == 3:
    print('5등입니다')
else:
    print('꽝')
```

- intersection함수를 활용해서 교집합 리스트의 길이를 구해서 몇개나 겹치는지 chk변수에 담았다.
- for문 안 if문을 두고 겹칠때마다 cnt를 세던 코드를 set을 활용하니 뺄 수 있었다.

**민정님 접근 방법**

```python
my_numbers = [1, 2, 4, 5, 6, 8]
jackpot_numbers = [1, 2, 4, 5, 6, 7]
bonus_number = 8

intersects = list(set(my_numbers) & set(jackpot_numbers))
set_diff = list(set(my_numbers) - set(intersects))

print(intersects)
print(set_diff)
if intersects == jackpot_numbers:
    print('1등')
elif len(intersects) == 5:
    if set_diff[0] == bonus_number:
        print('2등')
    else:
        print('3등')
elif len(intersects) == 4:
    print('4등')
elif len(intersects) == 3:
    print('5등')
else:
    pass
```

- 차집합, 교집합을 먼저 생각해서 set 자료형 활용할 생각을 하셨다고 한다.
- `set & set`으로 교집합 list를 만들어두고
- `set - set`으로 차집합 list(보너스번호 확인용)을 만들었다
- `if set_diff == bonus_number:`으로 하니 보너스 번호랑 같아도 일치하지 않는다고 나온다. `if set_diff[0] == bonus_number:` 로 바꿨더니 잘 비교된다.

- `else: pass로 처리함`

**※ 포인트**

- set이 중복값을 담을 수 없다는 것을 활용. 차집합, 교집합 리스트를 따로 만든게 신선했다.
- set자료형을 활용하니 for문을 따로 만들 필요가 없었다.
- if문조차도 줄일 수 없을까 이야기하다가 dictionary의 key, value를 활용해보는 것은 어떨까 아이디어가 나왔는데 5개가 겹칠 경우 2등과 3등이 존재하므로 막혔다. dictionary를 잘 활용하면 불필요하게 긴 if문이나 switch문을 안 써도 될 것 같다.

```python
# dict 활용해서 짜봄/ 22년 12월 20일 추가
my_numbers = [1, 2, 3, 4, 5, 45]
jackpot_numbers = [1, 2, 3, 4, 5, 6]
bonus_number = 45
chk_dic = {0:'1등', 1:'3등', 2:'4등', 3:'5등', 4:'꽝', 5:'꽝', 6:'꽝'}

no_nums = list(set(my_numbers) - set(jackpot_numbers))  # set은 순서가 없기에 idx로 값 접근이 안 되는거 같다. idx로 값 접근 위해 list로 형변환 함
cnt = len(no_nums)

if cnt == 1 and no_nums[0] == bonus_number:
    print('2등')
else:
    print(chk_dic[cnt])
```

