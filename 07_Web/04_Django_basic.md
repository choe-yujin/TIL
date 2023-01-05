# Django basic

23년 1월 4일(수), 1월 5일(목)

**Dynamic Web(Web App)**

웹 서버 구현 목적으로 여러 기능을 보유한 라이브러리들을 한데 묶어 담은 프레임워크 활용



## 1. Django 설치 및 설정

`$pip install django==3.2.16`-> VS Code에서 django 추가-> ctrl+, emmet설정 

 `$django-admin startproject first_project`

`$django-admin startproject first_project .`(여기에 풀기. 폴더 먼저 만들고 그 폴더 안에서 여기에 풀기 권장) 

프로젝트폴더 > 마스터앱

manage.py 프로젝트의 총괄 매니저 

`python manage.py`매니저에게 시킬 수 있는 일의 명령어들이 나옴

1. `python manage.py runserver`
2. 나오는 주소(127.0.0.1:8000)를 ctrl 클릭
3. The install worked successfully! 웹 확인 가능



### Setting.py 설정

1. settings.py에서 `LANGUAGE_CODE = 'ko-kr'` 설정 가능
2. `INSTALLED_APPS`에 내가 만든 app 등록부터 하기
3. `TEMPLATES`에 django가 추가로 HTML을 찾아볼 폴더 등록(django는 기본적으로 app 안에 templates/ 폴더에서 HTML을 찾는다.)

   **주의!** : installed_apps 순으로 templates를 찾으니까 각 앱의 templates에 같은 이름의 html이 있다면 먼저 등록된 app의 html 찾으면 그걸 렌더링한다. templates 내에서 폴더 분리하기
4. `SECRET_KEY`는 보통 서버 컴퓨터 자체에 숨김파일로 저장함



### 마스터 url.py 설정

1. `마스터 url.py`파일에 from django.urls import path`, include` 넘기기용 함수 추가

2. 새 앱 폴더에 `urls.py` 파일 생성하고 `import path`, `urlpatterns=[]`코드 복붙

   1. `from . import views`

   2. `path('함수불러올url/', views.함수명)`

      2-1. `path('함수불러올url/', views.함수명, name='이름')` 

      ​	(name은 url 변수명) `<a href={ % url '변수명'% }>`

      2-2. `app_name = 앱이름`이라고 정의해줄 경우(변수명 반드시 app_name)

      ​	`<a href={ % url '앱네임:변수명'% }>`

   3. `path('새 앱/', include('새앱.urls'))`



### 앱의 views.py 설정

함수에 인자로 request객체 받아서 일하고 결과를 HTML 렌더링해서 HTTP응답

`render(1.request, 2.'HTML이름', (3.넘길 data))`

1. 앱 폴더에 templates 폴더 생성 후 그 안에 .html 파일 생성

2. views.py에 

   def 함수명(request):

​		return render(request, '렌더링할html이름')  따옴표 꼭 붙여야~

​		**주의!** 렌더링할 html이름을 '**폴더명/**~.html'로 



### 앱의 HTML 설정

1. 프로젝트 안에 마스터 템플릿 폴더 생성

2. setting.py  `TEMPLATES=[{'dirs':[BASE_DIR/'템플릿경로폴더']}]`등록

3. 마스터 템플릿 폴더 내에 base.html 생성

4. base.html에 중복될 부분에 block탭 content 

   `{% block content %}{% endblock content %}`

5. 앱 내의 html파일에 include 탭 

   `{% include 'base.html' %}`

   `{% block content %}` 내용`{% endblock content %}`

Tip. <a href="/review/hello"> ->  url에 name='url변수명'



#### 프로젝트 vs Apps

앱은 뭔가를 하는 웹 앱, 앱은 여러 프로젝트로 갈 수 있다.

프로젝트는 Apps의 총합. 여러 앱을 담을 수 있음. 

ex) 프로젝트(회사)-부서(앱),부서(앱),부서(앱),부서(앱)



**app(부서)을 하나 만들어 일을 시작하자.**

1. how? 매니저를 찾는다.

2. `python manage.py startapp 파일명 `





## 2. Django 구조

1. HTTP Request -> URL관리자(urls.py)
2. URL관리자는 요청을 views.py에 전달
3. View는 models.py통해 데이터 read/write
4. View는 HTTP Response



### 2-1.디자인 패턴 MVC vs MTV

- **MVC**
  - Model - DB
  - View - HTML
  - Controller - 관리자
    - Resopnse

- **MTV**

  - Model - DB

  - Template - HTML

  - View - 관리자

용어만 다르지 MTV는  MVC패턴이나 다름없다.



### 2-2.프로세스

1. 어떤 요청 들어오면

2. views.py에서 어떤 일을 할거야 => 함수화. 경로 지정 및 import
3. 응답해줘야지

```python
# urls.py
from hello import views

urlpatterns = [
    path('wow/', views.sayhi),
]

#views.py
def sayhi(request):
    print('hi')
```

wow url 들어오면 hello폴더의 views파일 안에 있는 sayhi함수 실행할거야.

sayhi함수에 request받은 객체는 자동으로 들어가(map함수와 같은 원리)

터미널에 hi 찍힘.  요청은 들어왔는데 응답은 안 줬기에 웹상에서는 오류.



#### **응답하기**

view함수는 무조건 HttpResponse 객체로 return해야한다.

```python
#views.py
from django.http.response import HttpResponse

def sayhi(request):
    res = HttpResponse('hi')
    return res
```

**주의!**

startapp(새로운 앱 만드는 명령어) 후 setting.py에 앱 이름 등록해줘야함.

앱 삭제시에는 setting.py에서도 INSTALLED_APPS에 등록된 이름 빼줘야.



#### url패턴, 함수 구조 분리시키기

- 마스터 urls.py에 모든 앱의 함수를 전부 모두 넣지 않고 각 앱에 views.py만들어 포워딩 시킨다. 

```python
# 마스터 urls.py
# from hello import views as hello_views
from django.contrib import admin
from django.urls import path, include


urlpatterns = [
    path('admin/', admin.site.urls),
    path('hello/', include('hello.urls')),
    # path('wow/', hello_views.sayhi),
]

# hello의 urls.py
from django.urls import path
from . import views
#내 위치의 views를 불러올게

urlpatterns = [
    path('world/', views.hello_world)
]

#hello의 views.py
from django.shortcuts import render
from django.http.response import HttpResponse

def hello_world(request):
    # 응답으로 HTML을 렌더링 하겠다.
    # django => 무조건 HTML 파일은 templates/ 에서 찾는다.
    return render(request, 'hi.html')
```

1. hello url 요청 
2. 마스터 urls.py -> hello.urls로 포워딩
3. hello앱의 views.py의 함수 중 매칭되는 것 부르기
4. hello의 views.py에서 hi.html 렌더링 응답



#### HTML 프로세스 구조 변경

**주의!** HTML은 templates 폴더 안에 넣기. 렌더링하는 메소드명은 html 파일명으로 통일하는게 좋음.

Q. html파일이 여러개라면 nav바나 중복되는 부분 항상 복붙?

**장고의 템플릿 태그 활용**

-> 마스터html템플릿이 하나 있고 변경되는 부분만 마스터템플릿에 붙여 넣는게 좋다.

1. 프로젝트 루트 / master_templates폴더 생성/ 마스터 HTML인 base.html 생성 `mkdir master_templates` master_templates > base.html

2. 해당 폴더 경로를 django에게 알려줌 `setting.py의 TEMPLATES=[{'DIRS' : [BASE_DIR / 'master_templates']}]` BASE_DIR은 프로젝트 맨 상단 루트를 의미
3. base.html 안에 `{% block %}` 을 통해서 블럭 생성
4. 각각의 html에 `{% extends 'base.html' %}`로 확장

```html
<!--마스터템플릿 base.html-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width={device-width}, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    {% block content %}

    {% endblock %}
</body>
</html>

<!--hello.html-->
{% extends 'base.html' %}

{% block content %}

    <h1>Hello World</h1>
    
{% endblock %}

```

장고의 템플릿 태그 편하게 쓰려고 VS Code에서 Django 익스텐드 함.

emmet의 html 편히 쓰던게 안 먹히니까 먹히게 하려고 설정

`ctrl + ,` emmet검색 -> include languages - django-html : html 추가



#### html으로 함수에서 일한 값을 리턴 받아 오기 `{{ }}` 활용

```python
def lunch(request):
    menus = ['짜장','짬뽕','탕수육','치킨','족발']
    menu = random.choice(menus)
    context = {'menu' : menu}
    return render(request, 'lunch.html', context)
# 세번째 인자 context는 딕셔너리다

'''
{% extends 'base.html' %}

{% block content %}

    <h1>Lunch</h1>
    {{ menu }} 딕셔너리의 키값을 적어줘야. 불러올 거는 {{}}로

{% endblock %}
'''
```



#### html에서 for문 if문 써서 인자 출력하기

```django
{% extends 'base.html' %}

{% block content %}

    <h1>행운의 숫자</h1>

    {%if is_jackpot %}
    <h2>당첨!</h2>
    {% endif %}

    <ul>
    {% for number in lucky %}
        <li>{{ number }}</li>
    {% endfor %}
    </ul> 
{% endblock %}
```



#### html 하이퍼 링크

```html
<body>
    <nav>
        <ul class="d-flex justify-content-end">
            <li class="me-3">
                <a href="/hello/world/">Hello World</a>
            </li>
            <li class="me-3">
                <a href="/hello/lunch/">Lunch<a>
            </li>
            <li class="me-3">
                <a href="/hello/lotto/">Lotto<a>
            </li>
        </ul>
    </nav>
    {% block content %}

    {% endblock %}
</body>
```





**Q. 플라스크 vs 장고**

- 모든 언어의 프레임워크는 url패턴과 그에 대응하는 함수가 있다.

flask는 마이크로프레임워크라서 url패턴도 함수도 한꺼번에 **Function-based views**

장고는 url패턴과 함수 분리, 함수에서 그치지 않고 클래스의 메소드와도 대응 **Class-based views**







> ## References
>
> 깃 튜토리얼 https://www.atlassian.com/ko/git/tutorials/rewriting-history
>
> 파이썬 pip 설치 가능 목록 https://pypi.org/
>
> Django 프로젝트 튜토리얼 https://docs.djangoproject.com/en/3.2/intro/tutorial01/
>
> Django 소개 https://developer.mozilla.org/ko/docs/Learn/Server-side/Django/Introduction