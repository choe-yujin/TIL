# Bootstrap

## 기본 설정

1. `<head>`에 `<link href="">` 

2. `<body>`앞에`<div class="container">`  컨테이너 사이즈는 기기별 여러가지

3. `<body>`끝에`<script src="">` 

이 세군데에 부트스트랩 링크 넣어주면 

bootstrap.min.css를 불러오고 거기에 미리 선언된 스타일들을 쓸 수 있다.

```html
  <head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
  </head>
  <body>
    <div class="container">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
  </body>
```

>  `Tip!` VS Code에 lorem 탭하면 테스트용 여러 글이 나옴



- class row와 col활용한 grid시스템

```html
<!--container > row > col(쪼개짐)-->
    <div class="container text-center">
        <div class="row">
            <div class="row">
                <!--col-차지하는 칸 수-->
                <div class="col-2 p-3 bg-primary-subtle border border-primary-subtle rounded-3">1</div>
                <div class="col-4 p-3 bg-primary-subtle border border-primary-subtle rounded-3">2</div>
                <div class="col-6 p-3 bg-primary-subtle border border-primary-subtle rounded-3">3</div>
            </div>
        </div>
    </div>
```



실제 페이지 만들어보기

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <title>Document</title>
    <style>
        .sns-icon {
            width: 2rem;
        }
    </style>
</head>
<body>
    <!--Navbar-->
    <!--네비가 위 붙박으로 sticky-top, 박스가 옆으로 쌓이게 d-flex-->
    <nav class="sticky-top d-flex justify-content-between text-white bg-dark">
        <div class="fs-5 fw-bold">SAMSUNG</div>
        <div>
            <!--margin오른쪽 2칸 줘서 공간-->
            <!--
                p m 패딩 마진
                x y e s t b 좌우, 상하, 양쪽, ,탑, 바텀
                -1 2 3 4 5 6
            -->
            <a href="#" class="text-decoration-none text-white me-2">Contact</a>
            <a href="#" class="text-decoration-none text-white me-2">Cart</a>
            <a href="#" class="text-decoration-none text-white me-2">Login</a>
        </div>
    </nav>
    <header>
        <img src="./images/main.png" alt="mainimg" class="img-fluid">
    </header>
    <section class="text-center container">
        <div class="fw-bold fs-5 py-5">Our New Products</div>
        <!--
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4"> 
            article class 4개에 전부 반복하던걸 row-cols- 하나만 써서 할 수 있음
        -->
            <div class="row">
            <!--col-1 col-md-2화면 작으면 열두칸 적당하면 6칸먹을게 크면 4칸 엄청 크면 3칸-->
            <article class="card col-12 col-md-6 col-lg-4 col-xol-3">
                <img class="card-img-top" src="./images/buds.jpg" alt="buds">
                <div clas="card-body">
                    <div>Buds</div>
                    <div>123,456</div>
                </div>
            </article>
            <article class="card col-12 col-md-6 col-lg-4 col-xol-3">
                <img class="card-img-top" src="./images/buds.jpg" alt="buds">
                <div clas="card-body">
                    <div>Buds</div>
                    <div>123,456</div>
                </div>
            </article>
            <article class="card col-12 col-md-6 col-lg-4 col-xol-3">
                <img class="card-img-top" src="./images/buds.jpg" alt="buds">
                <div clas="card-body">
                    <div>Buds</div>
                    <div>123,456</div>
                </div>
            </article>
        </div>
    </section>
    <footer class="d-flex justify-content-center p-3">
        <a href="#">
            <img class="sns-icon mx-3" src="./images/instagram.png" alt="insta">
        </a>
        <a href="#">
            <img class="sns-icon mx-3" src="./images/facebook.png" alt="facebook">
        </a>
        <a href="#">
            <img class="sns-icon mx-3" src="./images/twitter.png" alt="twitter">
        </a>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
</body>
</html>
```

