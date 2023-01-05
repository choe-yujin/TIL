# markdown 기초 문법

## 리스트

### 순서가 있는 리스트(ordered list)

1. 손 씻기(tab, shift+tab)
   1. 물을 틀고
      1. 손을 뻗어
      2. 손잡이를 들어 올린다
   2. 물을 적시고
   3. 비누를 칠한다
2. 식당에 가기
3. 밥을 먹고
4. 계산하고
5. 양치하기

### 순서가 없는 리스트(unordered list)

- 짜장면
  - 쟁반짜장
  - 간짜장
- 돈까스
* 김밥
* 라면
    1. 물 넣고
    2. 끓으면
    3. 스프
    4. 면
    5. 냠냠

---

## 인라인 강조
중요한 것은 **굵게** 표시하고, 주의할 것은 *기울이고*, `코드 혹은 명령어`는 따로 표시를 하고싶다.

- 굵게 할 때는 * 두개로 감싼다 (**bold**)
- 이탤릭체는 *(esterlisk) 한개로 감싼다 (*italic*)
- 코드 강조는 \`(backtick) 두개로 감싼다 (`code`)

---

## 블럭 강조

### 표

파이프(|)로 구분하여 테이블 헤더를 생성한다.

|명령어|설명|예시|
|-|-|-|
|`mkdir`|폴더를 생성한다|$ `mkdir` my_dir|
|`touch`|파일을 생성한다|$ `touch` a.txt|
|`rm`|파일을 삭제한다|$ `rm` a.txt|
|`rm -r`|폴더를 삭제한다|$ `rm -r` cli|
|`rm *.확장자`|해당 확장자 파일 모두 삭제|$ `*.txt`|
|`rm 0*.확장자`|0으로 시작하는 해당 확장자 파일 모두 삭제|$ `rm 0*.txt`|
|`ls`|목록을 보여준다|$ `ls`|
|`ls -a`|숨김파일까지 보여준다|$ `ls -a`|
|`cd` 또는 `cd ~`|home 폴더로 이동|$ `cd` 또는 $ `cd ~`|
|`cd ..`|상위 폴더로 이동|$ `cd ..`|
|`cd . `|지금 여기|$ `cd .`|
|`code .`|vscode로 지금 있는 폴더 열기|$ `code .`|
|`start .`|현재 위치 탐색기 열기|$ `start .`|
|`ctrl + l` 또는 `clear`|터미널 정리|$ `clear`|
|`ctrl + c`|취소. prompt($)상태로 변환|`ctrl + c`|
|`~`|Home. 내가 로그인한 계정명의 폴더|`~/cli`|
|`$`|prompt : 터미널에서 명령어를 받을 준비가 됐음을 의미|$|
|`/`|최상단(Root)폴더 상징 기호|$ `cd /`|
|`mv`|파일을 해당 폴더로 옮기겠다|$ `mv markdown-basic.md markdown`|
|enter|행 바꿈|enter enter|
|`-`|뒤로 가기|$ `cd -`|

### 코드

```
$ mkdir mydir
$ cd mydir
$ touch a.txt
$ rm a.txt
```

```python
# python
def my_func(x, y):
    return x + y
```

```javascript
// js
function my_func(x, y){
    return x + y
}
```

---

## 기타

### 인용문

> 삶의 의미는 살아있음을 경험하는 것이다. 
> -조셉 캠벨

### 수식
LaTeX(레이텍) : 문서 조판에 사용되는 프로그램

- 인라인 수식 $x + y$

- 블럭 수식  

$$
\mathbb{N} = \{ a \in \mathbb{Z} : a > 0 \}
$$

### 이미지 / 하이퍼링크
[표시 텍스트] (링크)

[구글](https://google.com)

![img](이미지 링크)
![img](https://www.creativeboom.com/uploads/articles/70/7061556f2bf274e57e387b4ab67b3b3bc7032958_1620.jpeg)
