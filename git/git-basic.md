# git 기초

## git의 개념과 학습 이유

### VCS?
  **Version Control System**

수정한 파일을 매번 저장한다면 메모리에 차지하는 용량이 점점 커진다. 

- 변경사항만 저장할 수 있다면 좋을텐데? 

  *-> 버전 관리를 하자 !*

>git 가이드북
>https://git-scm.com/book/ko/v2


- 기술 생산자와 기술 활용자가 같지 않은 시대.
  오픈소스 활용시 모든 것을 바닥부터 만들지 않아도 된다.

    *-> Open Source를 누리자!*


## git 설정 방법
```
$ cd ~
$ mkdir git-basic
$ cd git-basic

$ git init
$ git commit # => 안내문 나옴
$ git config --global user.email "개발에쓸@이메일"
$ git config --global user.name "내이름"
```

## git 버전 관리 시작하기

1. 폴더/dir
   
2. `$ git init` -> 버전 관리 시작-> .git/ 

     해당 폴더가 Repository로 진화됨

3. `$ rm -r .git/` -> 버전 전부 삭제 -> .git/삭제

    해당 Repository가 폴더로 됨

## git의 흐름 이해

>git의 흐름을 광고촬영장으로 비유하여 시각화 해보자

### 1.Working Directory
(분장실)

a.txt

b.txt


* `$ git add c.txt` Stage에 올림

* `$ git add .` 현재 디렉토리 기준 변경사항 있는 것만 한번에 스테이징 
  

### 2.Stage
(무대)
* `$ git restore --staged c.txt` Stage에서 내림
  
* `$ git commit -m '찰칵'` Stage에 있는 것을 Commit. 사진 찰칵

스테이징된 변경 사항 : add한 것

변경 사항 : add 이후에 또 변경한 것

### 3.Commits
(사진첩)

* `$ git restore c.txt` 사진첩에 올라간 사진 기준으로 복구

* `$ git status` 현재 상태 브리핑

* `$ git log` 커밋들(사진첩) 상태 보기

* `$ git log --oneline` git 히스토리 짧게 보기

* `q` : $(prompt)로 돌아가기


```
$ touch a.txt
$ git add a.txt
$ rm a.txt
$ git restore a.txt
$ git add a.txt => git commit -m 'add msg'
```
