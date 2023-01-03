# CSS

Cascading (위에서 아래로 흐르는) 스타일 시트

## 용어

### 1.셀렉터(Selector)

스타일을 적용하고자 하는 HTML 요소를 선택하기 위해 제공하는 수단

`h1{color:red; font-size:12px;}`

`셀렉터{선언블록} | 셀렉터{선언;선언} | 셀렉터{프로퍼티:값; 프로퍼티:값}`

	#### 1-1.universal selector

```html
    <style>
        * {color: red;}
    </style>
```

#### 1-2. id selector

되긴 하지만 id를 이용해 css조작은 하지 않는다.

```html
    <style>
        /* id 어트리뷰트 값이 p1인 요소 선택 */
        #p1 {color: blue;}
    </style>

<p id="p1">paragraph1</p>
```

#### 1-3. class selector

class 어트리뷰트 값이 ~인 모든 요소를 선택. 프로퍼티 어트리뷰트는 자식 요소에 상속된다.

```html
	 <style>}
        .container {
            color:green;
        }
    </style>
<div class="container">
    <p>paragraph2</p>
    <p>paragraph3</p>
</div>
```

* 주의! *셀렉터와 class셀렉터가 함께 있는 경우엔 상속받아야할 class자식요소는 *셀렉터의 css를 따른다. class 직계만 class의 css요소를 따른다.

#### 1-4. 복합셀렉터

자손, 후손, 형제

​	div

​	h2 p span

​				p

div의 자손 요소는 h2,p,span이다. span-p는 후손요소이다.

```html
<style>
    div p {color: red}; 내 유전자 모두
	div > p {color: blue}; 직계 자식만
	p + ul 형제
	p ~ ul
</style>
```

#### 1-5. 가상셀렉터

```html
<style>
    /* a요소가 hover 상태일때*/
	a:hover {color: red;}
</style>

```



### 2. Property(key)

`font-size` `color` `text-align`등

#### 단위

- **px**(요즘 안씀)

  - 대부분 브라우저는 1px = 1/96inch(0.02cm)의 절대단위로 인식한다.

- **%**

- **em**

  - 배수 단위로 상대단위다.

    `1.2em => 14px(물려받은 값) * 1.2 = 16.8px`

- **rem**

  - 최상위값의 배수(미지정시 브라우저 기본 글꼴 사이즈16px)

- **viewport**

  - 요즘 모니터 크기, 기기 제각각이라 각자 화면 비율에 맞게 변화, 브라우저 크기 변화 따라서도 동적으로 변화

    50`vw` 내가 보고 있는 화면의 가로(반)

    100`vh` 내가 보고 있는 화면의 세로(전부)

### 3. 레이아웃

#### 박스 모델

`Margin > Border > Padding > Content`

조절가능, 조절가능, 조절가능, 조절불가

ex) 옆 책상과 떨어진 정도 > 책상의 경계선 > 키보드,마우스 제외한 남은 공간 > 키보드, 마우스

`margin=auto` 박스 좌우 여백 줘서 가운데 정렬

`text-align:center` 박스 안 컨텐츠를 가운데 정렬

`background-color` 박스 내부 색 변경

#### 인라인

- 글,이미지,span만 선이다.

- 선 요소 안에 블록 요소가 올 수 없다.

- `inline-height` 으로 행간 조절한다.

#### 인라인-박스

`display: inline-block` 박스 여러개를 한 줄로 위치하게 가능 (하지만 상속되지 않기에 박스 하나하나에 적어주고 각 박스의 width 퍼센테이지도 수동으로 적용해줘야 함)

### 4. 반응형 레이아웃

CSS3의 새로운 레이아웃 방식

요소 사이즈가 불명확하거나 동적으로 변화할 때에도 유연한 레이아웃을 실현할 수 있다. 복잡한 레이아웃이라도 적은 코드로 보다 간단히 표현할 수 있다.

ex) m.naver.com(반응형)과 naver.com은 다른 페이지다.

```css
/*정렬하고 싶은 박스가 4개라면 그 박스를 하나로 상위에 묶는 박스를 만들고 그 박스에 정렬 선언*/
.flex-container{
    display: flex;
    justify-content: space-around;
}
```

#### `justify-content:  `Main Axis(주 축)을 기준으로 정렬

- `flex-start`: 요소들을 컨테이너의 왼쪽으로 정렬
- `flex-end`: 요소들을 컨테이너의 오른쪽으로 정렬
- `center`: 요소들을 컨테이너의 가운데로 정렬
- `space-between`: 요소들 사이에 동일한 간격을 둔다. ㅁ-ㅁ
- `space-around`: 요소들 주위에 동일한 간격을 둔다.  -ㅁㅁ-
- `space-evenly`: 요소들 주위와 사이에 동일한 간격을 둔다. -ㅁ-ㅁ-



#### `align-items:` Cross Axis(교차 축)을 기준으로 정렬 

- `flex-start`: 요소들을 컨테이너의 꼭대기로 정렬
- `flex-end`: 요소들을 컨테이너의 바닥으로 정렬
- `center`: 요소들을 컨테이너의 세로선 상의 가운데로 정렬
- `baseline`: 요소들을 컨테이너의 시작 위치에 정렬
- `stretch`: 요소들을 컨테이너에 맞도록 늘린다.



#### `align-self:`개별 요소를 정렬시



#### `flex-direction`

- `row`: 요소들을 텍스트의 방향과 동일하게 정렬
- `row-reverse`: 요소들을 텍스트의 반대 방향으로 정렬(가로축의 시작방향이 반대로)
- `column`: 요소들을 위에서 아래로 정렬 (축을 세로로 바꾼다.)
- `column-reverse`: 요소들을 아래에서 위로 정렬(축을 세로로, 시작은 반대로)



#### `order: 숫자 `각 요소에 적용해 순서 바꾸기(양수 음수)



#### `flex-wrap:`

- `nowrap`: 모든 요소들을 한 줄에 정렬
- `wrap`: 요소들을 여러 줄에 걸쳐 정렬
- `wrap-reverse`: 요소들을 여러 줄에 걸쳐 반대로 정렬



#### `flex-flow:` flex-direction과 flex-wrap을 같이 쓸때

ex) flex-flow: column wrap;



#### `align-content:`

- `flex-start`: 여러 줄들을 컨테이너의 꼭대기에 정렬합니다.
- `flex-end`: 여러 줄들을 컨테이너의 바닥에 정렬합니다.
- `center`: 여러 줄들을 세로선 상의 가운데에 정렬합니다.
- `space-between`: 여러 줄들 사이에 동일한 간격을 둡니다.
- `space-around`: 여러 줄들 주위에 동일한 간격을 둡니다.
- `stretch`: 여러 줄들을 컨테이너에 맞도록 늘립니다.



---

## CSS 적용 3가지 방법

1. **Inline CSS**

   단점 : HTML문서에 직접 디자인 입히지 않는다. 문서 컨셉을 여러 버전으로 바꿀 때 불편하다.

   ```html
   <p style="font-size: 32px; color:red;">This is Big Red</p>
   ```

2. **< head > Style Tag**

   ```html
   <head>
       <style>
           <!-- 모든 p태그에 아래 스타일 적용-->
           p {
               font-size: 24px;
               color: #0000ff;
           }
       </style>
   </head>
   
       <style>
           <!-- blue-medium클래스 가진 p에 아래 스타일 적용-->
           p.blue-medium {
               font-size: 24px;
               color: #0000ff;
           }
       </style>
   
   ```

3. **File.css(Link Style)**★

   ```css
   /* css파일
   green-small 클래스 가진 모든 요소*/
   .green-small {
       font-size: 12px;
       color: green;
   }
   ```

   ```html
   <head>
       <link rel="stylesheet" href="./00_intro.css">
   </head>
   
   <p class="green-small">This is Small Green</p>
   ```

   

> ## References
>
> CSS 개념 https://poiemaweb.com/
>
> CSS 반응형 웹 코드 실습 게임 https://flexboxfroggy.com/