# Django_one to many_User Model custom

23년 1월 16일(월)



## 프로젝트 세팅

`mkdir RECAP`

`cd RECAP/`

`python -m venv venv`

`code .` select Interpreter 터미널 켜기

`pip install django==3.2.16 ` `django_extensions`

`pip freeze > requirements.txt`

`touch .gitignore README.md`

`django-admin startproject recap .`

gitignore.io에서 `venv` `python` `django`  복붙

`mkdir templates`

`touch templates/base.html`

`python manage.py startapp polls`

`cd polls/`

`touch urls.py forms.py`

`mkdir -p templates/polls`

`cd templates/polls/`

`touch question_form.html question_index.html question_detail.html`

`cd-` `cd ..`

`python manage.py startapp accounts`

`cd accounts/`

`touch urls.py forms.py`

`mkdir -p templates/accounts`

`cd templates/accounts/`

`touch login.html signup.html`

`cd-` `cd ..`



- setting.py

TEMPLATES [ BASE_DIR / 'templates', ]

INSTALLED_APPS =['django_extensions', 'polls', 'accounts',]



- 마스터urls.py에 path include추가

```python
from django.contrib import admin
from django.urls import path, include

def to_main(request):
    from django.shortcuts import redirect
    return redirect('polls:question_index')

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('accounts.urls')),
    path('polls/', include('polls.urls')),
    path('', to_main)  # 메인은 to_main보여줄거고 to_main이 의미하는건 polls의 question_index야 자동으로 /polls로 옴
]

```

마스터url에 def함수 써서 메인창 띄우면 바로 /polls로 옮겨가도록 지정해 주었다.



## Model ERD

User

| id   | username | password | mbti |
| ---- | -------- | -------- | ---- |
| 1    | neo      | 31532    |      |
| 2    | justin   | 245      |      |
| 3    | alex     | 2345     |      |
| 4    | kyle     | 436436   |      |

Question

| id   | title      | user_id |
| ---- | ---------- | ------- |
| 1    | 점심 뭐먹? | 1       |
| 2    | 회식 뭐먹? | 2       |
| 3    | 간식 뭐먹? | 3       |

Reply

| id   | content  | question_id | user_id | vote |
| ---- | -------- | ----------- | ------- | ---- |
| 1    | 닭칼국수 | 1           | 3       | 10   |
| 2    | 장어구이 | 1           | 4       | 4    |
| 3    | 치킨     | 2           | 4       | 2    |
| 4    | 스테이크 | 3           | 2       | 8    |



## User모델 커스텀하기

```python
#User는 AbstractUser를 상속받고 
#AbstractUser에 여러 필드가 있다.
#AbstractUSer를 상속받자.
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    MBTI_CHOICES = (
            ('INTJ', 'INTJ'),
            ('INTP', 'INTP'),
            ('ISTP', 'ISTP'),
            ('ISFP', 'ISFP'),
            ('ENTJ', 'ENTJ'),
            ('ENTP', 'ENTP'),
            ('INFJ', 'INFJ'),
            ('INFP', 'INFP'),
            ('ENFJ', 'ENFJ'),
            ('ENFP', 'ENFP'),
            ('ISTJ', 'ISTJ'),
            ('ISFJ', 'ISFJ'),
            ('ESTJ', 'ESTJ'),
            ('ESTP', 'ESTP'),
            ('ESFP', 'ESFP'),
        )
    mbti = models.CharField(max_length=4, choices=MBTI_CHOICES)
```

장고는 일반적인 프로젝트에서 필요한 모델을 제공한다. 

혹시 기본 모델에서 커스텀 컬럼 추가가 필요시 인증extension and customization을 제공한다!

**Extending the existing User model**

1. Model에 `from django.contrib.auth.models import AbstractUser` 

​		`class User(AbstractUser): pass`

2. settings.py에 

​	`AUTH_USER_MODEL = '앱네임.유저모델네임'` 추가해줘야한다. (모델에서 FK 인자 setting.AUTH_USER_MODEL이 바로 이걸 의미함)

```python
from django.db import models
from django.conf import settings

class Question(models.Model):
    title = models.CharField(max_length=200)
    # 알아서 db컬럼은 user_id가 됨
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)  # CASCADE는 순장
    
class Reply(models.Model):
    content = models.CharField(max_length=200)
    vote = models.IntegerField(default=0)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
   
```

**user아닌 다른 모델에서 user를 FK로 추가하려면?**

장고 권장 방법 ->  `from django.conf import settings` 후 

class 내에 `user = models.ForeignKey(setting.AUTH_USER_MODEL, on_delete=models.CASCADE)`로 해줘야 한다. (setting.py에서 수동 추가한 AUTH_USER_MODEL을 의미)

갑(1)과 을(N)의 관계에서는 을이 갑의 정보를 들고 있어야 한다.



- 모든 모델 추가 후

`python manage.py makemigrations`

`python manage.py migrate`

- 만약 모델 지우려면

```shell
rm db.sqlite3 accounts/migrations/0* polls/migrations/0*
```



## forms.py도 커스텀하기

auth의 forms.py의 class Meta의 모델은 User라고 되어있다.

이 User는 default User를 가리키고 있다.

우리는 이 User를 쓰지 않고 직접 AbstractUser상속받아 내가 만든 User를 쓰니까 forms.py에도 오버라이드 해줘야한다.

```python
from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model

User = get_user_model()

#오버라이드
class CustomUserCreationForm(UserCreationForm):
    
    class Meta:
        model = User (내가 커스텀한 유저 모델명)
        fileds = ('커스텀한 컬럼명', '받을거',)
```

주의! User는 클래스에 직접 접근해 import 하지말고 get_user_model함수로 꺼내 써야 한다.

- models.py에서 ForeignKey가 User일때만, setting.AUTH_USER_MODEL

- 나머지 경우에 User클래스가 필요하면, get_user_model



```python
from django import forms
from .models import Question, Reply

class QuestionForm(forms.ModelForm):
    title = forms.CharField(min_length=3, max_length=200)
    
    class Meta:
        model = Question
        # 모든 필드(title, user)들 중에 아래 필드만 HTML에 보여주고 + 검증함
        fields = ('title',)

class ReplyForm(forms.ModelForm):
    content = forms.CharField(min_length=3, max_length=200)
    
    class Meta:
        model = Reply
        fields = ('content',)
```



mbti는 사용자에게 직접 입력 받지 말고 ChoiceFiled로 커스텀하기.

-> forms.py에 miti컬럼 커스텀 안 넣어주면 models.py에 정의해둔 초이스로 자동 지정해줌.

```python
# auth의 forms.py의 class Meta의 모델은 User라고 되어있다.
# 이 User는 default User를 가리키고 있다.
# 우리는 내가 만든 User를 쓰니까.
from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model

User = get_user_model()
#오버라이드 해줘야함
class CustomUserCreationForm(UserCreationForm):
    first_name = forms.CharField(required=False)
    last_name = forms.CharField(required=False)
    # mbti = forms.CharField(min_length=4, max_length=4)
    # 엇 여기 없네! models.py 가서 보고올게요~ Choices폼이네
    # mbti = models.CharField(max_length=4, choices=MBTI_CHOICES)
    
    class Meta:
        model = User
        fields = ('username', 'mbti', 'first_name', 'last_name', )
```





## 일하자 Views.py

### account앱용

`from django.http import HttpResponseForbidden`  # 너의 권한으로는 할 수 없다! 

`from django.http import HttpResponseBadRequest` # 너 나쁜 요청했어. 에러 이유 알려줄게.

```python
from django.shortcuts import render, redirect
from django.http import HttpResponseBadRequest
from django.views.decorators.http import require_http_methods
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login as auth_login, logout as auth_logout
from .forms import CustomUserCreationForm

#create
@require_http_methods(['GET','POST'])
def signup(request):
    # 로그인 한 사람이 또 로그인 하는 거 막기
    if request.user.is_authenticated:
      return HttpResponseBadRequest('이미 로그인 하였습니다.')
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # 회원가입 끝나고도 바로 로그인 해주기 
            auth_login(request, user)
            return redirect('polls:question_index')
    else:
        form = CustomUserCreationForm()

    context = {'form':form,}
    return render(request, 'accounts/signup.html', context)

# 인증 form에 sessionID값 하나 적어주는거
@require_http_methods(['GET', 'POST'])
def login(request):
    # 로그인한 사람이 또 로그인하는거 막기
    if request.user.is_authenticated:
        return HttpResponseBadRequest('이미 로그인 하였습니다.')
    if request.method == 'POST':
        form = AuthenticationForm(request, request.POST)
        #사용자가 입력한 username/pw가 맞다면,
        if form.is_valid():
            #로그인시키기
            # AthenticationForm은 User create가 아니라 인증용 다른 method를 제공한다.
            user = form.get_user()
            # 로그인 시키기(쿠키 세팅)
            auth_login(request, user)
            return redirect('polls:question_index')
    else:
        form = AuthenticationForm()

    context ={'form':form,}
    return render(request, 'accounts/login.html', context)

def logout(request):
    auth_logout(request)
    return redirect('polls:question_index')
```

### polls앱용

```python
from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponseForbidden  # 너의 권한으로는 할 수 없다!
from django.views.decorators.http import require_http_methods, require_safe, require_POST
from django.contrib.auth.decorators import login_required  # 로긴 필요한 창이면 알아서 로긴하게 보낸다
from .models import Question, Reply
from .forms import QuestionForm, ReplyForm

@login_required
@require_http_methods(['GET', 'POST'])
def create_question(request):
    if request.method == 'POST':
        form = QuestionForm(request.POST)
        if form.is_valid():
            question = form.save(commit=False)
            question.user = request.user
            question.save()
            return redirect('polls:question_detail', question.pk)
    else:
        form = QuestionForm()

    context = {'form':form, }
    return render(request, 'polls/question_form.html', context)

@require_safe  # get만 허용
def question_index(request):
    questions = Question.objects.all()
    context = {'questions':questions}
    return render(request, 'polls/question_index.html', context)


@require_safe
def question_detail(request, question_pk):
    question = get_object_or_404(Question, pk=question_pk)
    form = ReplyForm() # 상세페이지에 댓글목록도 보여주자
    context = {'question':question, 'form':form,}
    return render(request, 'polls/question_detail.html', context)

@login_required
@require_http_methods(['GET', 'POST'])
def update_question(request, question_pk):
    question = get_object_or_404(Question, pk=question_pk)
    # 로그인한 사용자가 글쓴이가 아니라면
    if request.user != question.user:
        return HttpResponseForbidden('권한이 없습니다.')
    if request.method == 'POST':
        form = QuestionForm(request.POST, instance=question)
        if form.is_valid():
            question = form.save()
            return redirect('polls:question_detail', question.pk)
    else:
        form = QuestionForm(instance=question)
    context= {'form':form,}
    return render(request, 'polls/question_form.html', context)


@login_required
@require_POST
def delete_question(request, question_pk):
    question = get_object_or_404(Question, pk=question_pk)
    if request.user != question.user:
        return HttpResponseForbidden('권한이 없습니다.')
    question.delete()
    return redirect('polls:question_index')


@login_required
@require_POST
def create_reply(request, question_pk):  # 댓글 저장 담당
    question = get_object_or_404(Question, pk=question_pk)
    form = ReplyForm(request.POST)
    if form.is_valid():
        reply = form.save(commit=False)
        reply.question = question
        reply.user = request.user
        reply.save()
    return redirect('polls:question_detail', question.pk)

@login_required
@require_POST
def reply_upvote(request, question_pk, reply_pk):
    print('upvote입장')
    question = get_object_or_404(Question, pk=question_pk)
    reply = get_object_or_404(Reply, pk=reply_pk)
    # +1 누른 사람(요청 보낸 사람)이 reply 작성자가 아닐때만
    if request.user != reply.user:
        reply.vote += 1
        reply.save()
    return redirect('polls:question_detail', question.pk)

@login_required
@require_POST
def delete_reply(request, question_pk, reply_pk):
    print('del입장')
    question = get_object_or_404(Question, pk=question_pk)
    reply = get_object_or_404(Reply, pk=reply_pk)
    if reply.user != request.user:
        return HttpResponseForbidden('권한이 없습니다.')

    reply.delete()
    return redirect('polls:question_detail', question.pk)
```



## 응답 보여주자 html

로그인 상태에 따른 메뉴 분기

```django
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <ul>
        <li>
            <a href="{% url 'polls:question_index' %}">Home</a>
        </li>
        {% if not request.user.is_authenticated %}
        
        <li>
            <a href="{% url 'accounts:login' %}">Login</a>
        </li>
        <li>
            <a href="{% url 'accounts:signup' %}">Signup</a>
        </li>
        {% else %}
        <li>
            <a href="{% url 'polls:create_question' %}">New Question</a>
        </li>
        <li>
            <a href="{% url 'accounts:logout' %}">Logout</a>
        </li>
        {% endif %}
    </ul>
    {% block content %}{% endblock content %}
</body>
</html>
```



**질문**

Q. vote 이미 한 사람은 또 못하게 만드려면 user가 해당 컬럼 갖고 있어야 되나요?

A. 

M:N은 중간에 저장할 테이블 가지고 있어야한다.

좋아요, 싫어요, 북마크, 차단 등 전부 중간에 중계 테이블을 가지고 있어야 함.

ex) 게시글 테이블 | vote 테이블 | 사용자 테이블

댓글에 대댓글을 다는 경우는 댓글 테이블에 자기id참조 하는 컬럼 추가해도 되고 중간에 새로운 테이블 만들어도 됨.



## References

Using the Django authentication system : 장고공식문서에서 auth_user_model검색, ChoiceFiled검색

https://docs.djangoproject.com/en/4.1/topics/auth/customizing/

