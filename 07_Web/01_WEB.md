# web

2023년 1월 2일(월)

## web service?

**What?**
인터넷에 연결된 / 컴퓨터들을 통해 / 사람들이 정보를 공유할 수 있는 전 세계적인 정보 공간

고객client(n) 컴터 .요청-> <-응답. 해주는 사람 server컴터(1)
1:n

요청의 종류
1.줘라(Get)
2.받아라(Post) ok.

**Who?**
User가 request
Program이 response
우리는 서버컴터에서 요청과 응답을 처리할 프로그램을 개발한다.

**Static Web**정적이다. 한결같다.
정말 단순한 웹 서비스
클라이언트가 요청을 보내면 서버가 응답한다.

브라우저로 내 컴퓨터에 있는 파일 열 수 있듯이
아무것도 없는 컴터에 하나만 설치한다면?
/dir1/dir2/.../WantThis.file
남의 컴퓨터 주소에 있는 파일 열 수 있다.
다른컴주소/dir1/dir2/.../WantThis.file
172.217.27.78/dir1/dir2/.../WantThis.file

google.com(도메인)/~~

왜 Static? 내가 정확히 특정 경로로 가야, 언제나 그 자리에 그 정보가 있단 보장이 있다.

**Dynamic Web(Web Application Program. Web App)**

서버컴터에 달라고(get) 하는 법?

url로(Uniform Resource Locator)

네트워크상에서 자원이 어디 있는지 알려주기 위한 고유 규약.

흔히 웹 사이트 주소로 알고 있지만, URL은 웹 사이트 주소뿐 아니라 컴퓨터 네트워크상의 자원을 모두 나타낼 수 있다.

**HTML(Hyper Text Markup Language)**

초~텍스트

기존 테스트는 선형적.

하이퍼텍스트는 텍스트가 상호작용 점프가능

이게 우리가 response로 자원을 제공받는 문서 한장.

**Hyper Text를 주고받는 규칙(통신규약) = Hyper Text Transfer Protocol = HTTP(S)**

마크업? : 텍스트에 역할 표시.

Q.하이퍼텍스트는 인간이 기억하는 방식까지 바꾸고 있다?

**CSS?**

두껍고 크고 중앙정렬돼있고… 문서의 겉보기를 인간의 심미에 맞게

**Java Script?**

글씨 깜빡깜빡, 없어지고…

문서를 프로그래밍하기 위한 언어

**How?**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>form</title>
</head>
<body>
    <!--Forms. 사용자와의 커뮤니케이션을 위한 폼 태그-->
    <!--POST방식은 Request Body에 담아 보내는 방식-->
    <!--GET 방식은 전송 URL에 입력 데이터를 쿼리스트링으로 보내는 방식-->
    <!--Web1.0 : 주는 것만 받을 수 있다(신문, TV)-->
    <!--Web2.0 : 소통(Radio사연, 글쓰기, 댓글)-->
    <!--Web2.99 -> Creator-->
    <!--Web3.0 : 블록체인-->
    <h1>Form</h1>
    <!--form => block-->
    <form action="URL" method="POST">
        <!--input -> inline-->
        <div>
            <!--label은 input의 id와 맞춰야한다.-->
            <label for="myphone">전화번호: </label>
            <input id="myphone" type="text" placeholder="010-1234-1234" required autofocus>
        </div>
        <div>
            <label for="myemail">이메일: </label>
            <input id="myemail" type="email" value=" @naver.com">
        </div>
        <div>
            <label for="myname">나이: </label>
            <input id="myage" type="number">
        </div>
        <div>
            <label for="mypw">비밀번호: </label>
            <input id="mypw" type="password">
        </div>
        <div>
            <label for="myfr">좋아하는 과일: </label>
            <input id="myfr" type="checkbox" value="apple">사과
            <input id="myfr" type="checkbox" value="banana">바나나
            <input id="myfr" type="checkbox" value="grape">포도
        </div>
        <div>
            <label for="mygender">성별: </label>
            <input id="mygender" type="radio" name="gender" value="female">여자
            <input id="mygender" type="radio" name="gender" value="male">남자
        </div>
        <div>
            <textarea name="" id="" cols="30" rows="10">기존 내용</textarea>
        </div>
        <div>
            <input type="submit" value="얍">
        </div>
    </form>
</body>
</html>
```