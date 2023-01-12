# Django_1:N Model

23년 1월 12일(목)

## 새 프로젝트 시작

`mkdir ONE_TO_MANY`

`cd ONE_TO_MANY`

`touch README.md .gitignore`

`python -m venv venv`

`code .`

`Select Interpreter`

.gitignore `python` `Django` `venv` 복붙

`pip install django==3.2.16`

`pip freeze > requirements.txt`

`django-admin startproject one_to_many .`

`python manage.py startapp board`

settings.py에서 앱 추가, 템플릿 경로 지정

`mkdir templates`

`touch templates/base.html`

`cd board`

`mkdir -p templates/board`(-p 폴더 두개 한꺼번에 만드려고)

`touch urls.py forms.py`

`cd templates/board/`

`touch index.html detail.html form.html`



## models.py

created_at은 auto_now_add

updated_at은 auto_now

### FK 필드 명명법

객체로 가져오기

FK이면 DB에 알아서 변수명_id로 붙음. migrate 하면 알아서 뒤에_ id 붙음.

`article = models.ForeignKey(Article, on_delete=models.CASCADE)`

=> article_id 

`python manage.py makemigrations`

`python manage.py migrate`



### FK 가진 모델 객체 생성을 쉘으로 테스트

`python manage.py shell_plus`

```shell
article = Article()

article.title = '점심'

article.content = '메뉴 추천 받음'

article.save()



comment = Comment()

comment.content = '단식 ㄱ'

comment.article = article

comment.save()


# a 달린 커멘트를 보고싶어. 두 방법 다 결과는 같음 (주어만 다르다)
Comment.objects.filter(article=a) # 커멘트에서 article이 a인거 가져와
a.comment_set # 리버스 매니저 
a.comment_set.all() # a의 리버스매니저야 .all()메소드 통해서 커멘트 셋 다 가져와 / 객체.모델명_set.all()

# 커멘트 클래스 만들때 FK(세번째인자를  related_name='asdf')로 바꾸면 객체.asdf_set으로 매니저 부를 수 있다.
```



`python manage.py shell_plus --print -sql`

DB 건드리면 SQL문이 나오게 하는 명령어



## forms.py

```python
from django import forms
from .models import Article, Comment

class ArticleForm(forms.ModelForm):
    class Meta:
        model = Article
        fields = '__all__'
        
class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        # fields = ('content', )
        exclude = ('article', )  # 뺄 컬럼만
       
```

`{{ form }}`하면 코멘트 적는 form에 자동으로 article도 나와서 사용자가 댓글내용만 입력하도록 article은 exclude함.



## views.py

```python
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import(require_http_methods, require_POST, require_safe)
from .models import Article, Comment
from .forms import ArticleForm, CommentForm

@require_http_methods(['GET', 'POST'])
def create_article(request):
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():  # 유효성 검사-> 리턴 T/F
            article = form.save()
            return redirect('board:article_detail', article.pk)
	else:
        form = ArticleForm()
    context = {'form': form}
    return render(request, 'board/form.html', context)

@require_safe  # DB영향 없는 GET, (HEAD) 요청만 허용하겠음.
def article_index(request):
    articles = Article.objects.all()
    context = {'articles':articles,}
    return render(request, 'board/index.html', context)

@require_safe
def article_detail(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    # 글 상세 페이지에 해당글의 댓글 적는 form보내줌
    form = CommentForm()
    context = {'article':article, 'form':form, 'comments':comments, }  
    return render(request, 'board/detail.html', context)

@require_http_methods(['GET', 'POST'])
def create_comment(request):
    article = get_object_or_404(Article, pk = article_pk)
	form = CommentForm(request.POST)
    if form.is_valid():  # 유효성 검사-> 리턴 T/F
    	# 완전 저장시 NOT NULL 뜸(forms.py에서 article은 빼서 필드 추가도, 유효성검사도 안함)
        comment = form.save(commit=False)  # commit=False 아직 완전 저장은 no
        comment.article = article  # 추가 후
        comment.save()  # 완전 저장
		return redirect('board:article_detail', article.pk)
	else:
        form = CommentForm()
    context = {'form': form}
    return render(request, 'board/article_detail.html', context)

```

**Q. form.save()가 바로 안되는 이유 ?**

form객체는 <bound=False, valid=Unknown, fields=(title;content)> 

form에 데이터 bound하고 valid유효성검사 해야함



## urls.py

```python
from django.urls import path
from . import views

app_name = 'board'

urlpatterns = [
    # articles/create/
    path('create/', views.create_article, name='create_article'),
    # articles/
    path('/', views.article_index, name='article_index'),
    # articles/1
    path('<int:article_pk>/', views.create_article, name='article_detail'),
    # articles/1/comments/create/
    path('<int:article_pk>/comments/create/', views.create_comment, name='create_comment'),
    # articles/1/comments/2/delete/
    path('<int:article_pk>/comments/<int:comment_pk>/delete/', views.delete_comment, name='delete_comment'),
]
```



## form.html

```django
{% extends 'base.html' %}
{% block content %}
<form method="POST">
    {% csrf_token %}
    {{ form.as_p}}
<p>
    <button>GO</button>
</p>
</form>
{% endblock content %}
```



## detail.html

```django
{% extends 'base.html' %}

{% block content %}
<h1>{{article.title}} ({{article.comment_set.count}})</h1>
<p>{{article.content}}</p>

<div>
	<button>수정</button>
	<button>삭제</button>
</div>
{% include 'board/_commit_form.html' %}
{% include 'board/_commit_list.html' %}
{% endblock content %}
```



`extends`는 상속받는거

`include`는 부품 갖다 쓰는거(부품용은 파일명 앞에 _ 붙이면 알아보기 쉽다)

### _comment_list.html

```django
{% comment %} 댓글 목록 조회(댓글 삭제) {% endcomment %}
<ul>
    {% for comment in article.comment_set.all %}
    <li>
        {{ comment.content }}
        <form action="{% url 'board:delete_comment' article.pk comment.pk%}" method="POST" style="display: inline-block;">
            {% csrf_token %}
            <button>X</button>
        </form>
    </li>
    {% endfor %}
</ul>
```



### _comment_form.html

```django
{% comment %} 댓글 입력창 {% endcomment %}
<form action="{% url 'board:create_comment' article.pk %}" method="POST">
    {% csrf_token %}
    {{form}}
    <button>댓글얍</button>
</form>
```



DB에서 context 꺼내오는 코드 안써도

html 장고에서 `article.comment_set.all` 함수로 꺼낼 수 있음

`article.comment_set.count`로 개수 셀 수 있음

장고는 함수지만 끝에 () 안 붙여도 됨



