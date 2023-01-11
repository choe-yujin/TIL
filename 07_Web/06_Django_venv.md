# Django 독립개발환경 프로젝트

23년 1월 9일(월), 10일(화)



## 개요

컴터 하드디스크 저장공간에 파이썬이 폴더로 저장되어 있다.

python 3.10은 Global Python (어느 위치에 있던간에 이게 잡힌다.)

`$ pip list` 보면 설치된 패키지들이 많이 있다. 



어떤 패키지가 프로젝트에 필수인지 모르면 협업할 때, 소프트웨어를 배포할 때 문제가 생긴다.

다른 사람이 이제 막 컴퓨터 사서 깃허브 소스코드 클론해서 `runserver`하면 바로 실행되나? No

새 컴퓨터엔 설치된 것이 아무 것도 없으니.

프로젝트 실행시키는 데 있어서 어떤 패키지 필요한지 전혀 모른다.

어떻게 남에게 이 프로젝트를 구동시키는데 어떤 패키지 필요한지 말해줄 수 있는가?



![image-20230109093223025](https://github.com/choe-yujin/TIL/blob/master/07_Web/06_Django_venv.assets/image-20230109093223025.png)

장점 : 모든 프로젝트에서 필요한걸 한 곳에 몽땅 넣어두면 어떤 프로젝트에서 필요한지 모르니 각 프로젝트가 필요한 패키지는 각 프로젝트가 들고있으면 된다. 협업, 배포시 소스코드와 노란색 재료목록을 같이 보내준다

단점 : 각 프로젝트마다 따로 설치해줘야한다. 목록만 가져오는게 아니라 매번 다시 설치해야하는 단점.

가상개발환경 -> 독립개발환경 



## 독립적으로 돌아가는 프로젝트 생성 프로세스

1. `mkdir MTV` : MTV 빈폴더가 생겼다.

2. `cd MTV ` : MTV폴더에 들어간다.

​	(X)`django-admin startproject <project이름> . `은 장고가 설치되어있다는 가정에서 쓰는 명령이다.  글로벌 영역에서 dependency

3. `python -m venv <이름>` 파이썬으로 <이름>이라는 virtual environment만들거야. 보통 venv라는 이름으로 만든다.

4. `source venv/Scripts/activate` 터미널창에게 python이라고 치면 Global영역의 python을 보는게 아니라 venv를 보라는 명령어(소괄호로 묶인 venv가 나옴)

​	`deactivate` 터미널창에게 Global영역의 python을 볼거라는 명령어

5. `pip list` venv가 가진 패키지 리스트 보기

6. `pip install django==3.2.16` venv에 장고 설치
7. `django-admin startproject mtv .`venv 내에 있는 설치한 장고를 통해 현재 폴더 내에 mtv라는 패키지 만들기

8. MTV폴더 code . 열었을때 venv가 자동으로 잡히는지 확인. 안 잡히면 bash 터미널에 `source venv/Scripts/activate` 직접 입력
9. `touch .gitignore`
10. gitignore.io에서 `Python` `Django` `venv` 입력하고 ctrl+c .gitignore파일에 ctrl+v
11. `pip freeze > requirements.txt` 꼭 설치해야할 목록을 requirements.txt로 만들기 
12. `touch README.md`



## 프로젝트 시작

`python manage.py startapp blog`

![image-20230109103237574](https://github.com/choe-yujin/TIL/blob/master/07_Web/06_Django_venv.assets/image-20230109103237574.png)

### setting.py 

INSTALLED APPS에 'blog' 추가

TEMPLATES에 `[BASE_DIR / 'templates']`



### models.py

모델은 클래스를 정의하는 것

클래스 하나는 데이터베이스의 테이블 하나와 대응한다.



1.models.py에 테이블 컬럼명 적기

```python
from django.db import models

#익명게시판 id, title, content, creattime, updatetime
class Article(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    # 생성시 자동으로 채워지도록
    created_at = models.DateTimeField(auto_now_add=True)
    # 생성/수정시 자동으로 채워지도록
    updated_at = models.DateTimeField(auto_now=True)
```



2. 희망사항을 가봉한다. (migrations폴더가 만들어짐)

​	`$ python manage.py makemigrations blog`

3. 가봉한 희망사항을 데이터베이스에 반영한다.

​	`$ python manage.py migrate blog`

(VS Code에서 SQLite Viewer 패키지 설치)

db.sqlite3으로 생성된 디비를 볼 수 있음



## 화면 구성 벤치마킹

모델은 DB. CRUD

ORM을 통해 DB에 테이블 생성하고 읽고 수정하고 삭제한다.

1. 글 목록 화면(Read)

2. 글 상세 화면(Read)

3. 글 쓰기 화면(Creat)

4. 글 수정 화면(Update)
5. 글 삭제(Delete)



### 관리자 계정 만들기

장고는 관리자 페이지가 존재함 /admin/

 `$ python manage.py createsuperuser`

​	18개의 적용하지 않은 migrations가 있다는 오류 뜸

​	`$python mage.py migrate` 프로젝트 전체에 migrate진행



### 프로젝트의 admin.py

기존 모델에 있는 Article을 불러와라

```python
from django.contrib import admin
from .models import Article

admin.site.register(Article)  # admin아 site에 Article모델을 등록해줘
```

관리자페이지에서 BLOG 패키지의 Articles를 관리할 수 있게 됐다.



#### 비밀번호 암호

SHA-2는 미국 국가안보국이 설계한 암호화 해시암호

알고리즘의 한 종류로서 256비트로 구성되며 64자리 문자열을 반환한다.

input -> f(x) -> output

output->input으로 reverse enjineering이 안되는게 암호화의 핵심이다.



RESTful하다. 

 ` path('<int:article_pk>/', views.detail, name='detail')`

article_pk는 int만 받을거야 미리 설정



#### DTL(Django Template Language)

- 괄호 없음
- 쉼표 없음

`<a href="{% url 'blog:detail article.pk' %}">
 	{{article.title}}
 </a>`



### 프로젝트의 views.py

```python
from django.shortcuts import render, redirect

def create(request):
    article = Article()
    article.title = request.POST['title']
    article.content = request.POST['content']
    article.save()  # id가 확정되는 시점
    return redirect('blog:detail', article.pk) #두번째 인자로 넘기면 됨. 생성되고 바로 생성된 페이지로 감

```

**Q. return detail(request, article.id)로 보내는거랑, redirect 임포트해서 return redirect('blog:detail', article.id)하는거랑 차이가 있나요???**

-> URL을 보면 차이가 있다. 화면은 같으나 redirect 안하면 URL과 보여지는 화면이 다름! redirect를 하자!



**GET은 언제 쓰고 POST는 언제 쓰냐?**

search는 GET이 말이 됨. 검색해서 진짜 DB에서 get하는거니까.

글쓰기는 DB에 보내는거니까 POST가 맞다.

**POINT! **

**DB에 변경이 일어나면 POST, 안 일어나면 GET**



### 유효성 검사 후 데이터 받기

#### forms.py

```python
from django import forms
from .models import Article

class ArticleForm(forms.ModelForm):
    # 1.유효성검사(Validation)
    # 2.HTML 안에 <input> 태그 여러개 만들기 귀찮다
    # 3.저장시 request.POST에서 하나하나 꺼내기 귀찮다
    
    #title은 최소 2글자, 최대100글자야
    title = forms.CharField(min_length=2, max_length=100)
    
    class Meta:
        model = Article
        fields = ('title', 'content',)  # 리스트도 가능
```

Q.forms.py 에서 유효성검사 코드 추가하니 사용자 UI에서부터 이미 걸러버리니까 views.py에서 .is_valid()가 else일 경우가 없는거 아닌가? 

A. 1차 방어막이다. F12 개발자환경에서 유효성검사 없이 그냥 데이터를 넘겨버릴 수도 있으니까. views.py에서도 else 넣자.

title = 이라고 적은건 Article의 컬럼명 중 title이 있으니까.



#### views.py

```python
from .forms import ArticleForm

# 글 쓰기 화면(Create)
def new(request):
    article_form = ArticleForm()
    context = {'article_form':article_form, }
    return render(request, 'blog/form_new.html', context)

# 글 실제 저장
def create(request):
    article_form = ArticleForm(request.POST)
    #validation 메소드
    if article_form.is_valid():
        # 유효하면 저장 후 detail페이지로
        article = article_form.save()
        return redirect('blog:detail', article.pk)
    else: # 유효하지 않으면 다시 new페이지로
        context = {'article_form': article_form,}
        return render(request, 'blog/form_new.html', context)
```

else경우 에러 메세지까지 포매팅 되어 사용자UI에 출력된다.



### REST API 제대로 설계하기 

#### new와 create 함수 합치기(글쓰기화면/저장/반려)

GET -> /blog/create/ -> if GET 글쓰기화면

POST -> /blog/create/ -> elif POST 유효성검사 T저장/F반려

**METHOD(GET, POST, PUT, DELETE) / URL**

```python
def create(request):
    if request.method == 'POST':
        article_form = ArticleForm(request.POST)
        if article_form.is_valid():
            article = article_form.save()
            return redirect('blog:detail', article.pk)
        
    elif request.method == 'GET':
        article_form = ArticleForm()
        
    context = {'article_form':article_form,}
    return render(request, 'blog/form_new.html', context)
```



#### form_new.html

```django

{% include 'base.html' %}

{% block content %}
<h1>New Article</h1>
<p>ModelForm 통해서 만들어짐</p>
<form action=" {% url 'blog:create' %}" method="POST">
    {% csrf_token %}
    {% comment %} 마법같이 input태그들이 짜잔 나오면 좋겠다 {% endcomment %}
    {{article_form.as_p}}
    <button>제출</button>
</form>
{% endblock content %}
```

views.py의 new함수에 ArticleForm()객체를 넘겨줬으니까 {{article_form}} 으로 자동으로 데이터만큼 input만들어줌

여기에 `.as_p` input데이터들에 p태그 자동으로 붙여서 만들어 줌



### Status 상태코드 잘 보내주기 404error

```python
from django.shortcuts import render, redirect, get_object_or_404

# detail, edit, update, delete
def detail(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    context = {'article':article,}
    return render(request, 'blog/detail.html', context)
```

없는걸 사용자가 요청했으니 404 에러를 내줘야한다.





## References

> Meta클래스 https://docs.djangoproject.com/en/3.2/topics/forms/modelforms/#overriding-the-default-fields