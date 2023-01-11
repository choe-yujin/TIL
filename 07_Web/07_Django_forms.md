# Django_forms활용

23년 1월 11일 (수)

## 개요

**명령형 프로그래밍 VS 선언형 프로그래밍**

- 명령형 방식(HOW) : 200m 앞에서 좌회전하고 직진 후 우회전...~.(ex_동사, views.py코드 def)

- 선언형(WHAT) : 강남역이요 (ex_명사, meta클래스, Class based view)



## 새 프로젝트 만들기

`mkdir FORM`

`code .`

`ctrl + shift + p` `Select Interpreter` venv선택 후 터미널 재시작

`pip install django==3.2.16 django_extensions`

`pip list`

`pip freeze > requirements.txt`

`django-admin startproject form .`

(git commit -m 'init project')

`python manage.py startapp classroom`

**settings.py** 

- TEMPLATES [ BASE_DIR / 'templates', ]
- INSTALLED_APPS = [ 'django_extensions', 'classroom']

`mkdir templates`

`touch templates/base.html`

`cd classroom`

`touch urls.py forms.py`

`mkdir -p templates/classroom`

`cd templates/classroom/`

`touch detail.html index.html new.html`



## ERD (entity relationship diagrams)

관계형 데이터베이스 모델링

- 1:N(One to Many)

- 1:1(One to One)

- N:N(Many to Many)

```python
# models.py
from django.db import models

class Student(models.Model):
    name = models.CharField(max_length=10)
    age = models.IntegerField()
    gpa = models.FloatField()
    major = models.CharField(max_length=20)
```



models.py 수정을 했다 -> makemigration -> migrate

`python manage.py makemigrations`

`python manage.py migrate`



### forms(validation)

```python
#forms.py
from django import forms
from .models import Student

class StudentForm(forms.ModelForm):
    name = forms.charField(min_length=2, max_length=10)
    major = forms.charField(min_length=2, max_length=20)
    gpa = forms.FloatField(min_value=0.0, max_value=4.5)
    age = forms.IntegerField(min_value=10, max_value=100)

    class Meta:  # 이 클래스의 메타 데이터 저장용
        model = Student
        fields = '__all__'  # 모든 필드를 다 등록하겠다. 
```



### RESTful API

- HTTP요청 메서드 `GET` `POST` `PUT` `DELETE` 등

```python
from django.shortcuts import render, redirect, get_object_or_404

from .models import Student
from .forms import StudentForm

def create(request):
    if request.method == 'POST':
        # 데이터 받아서 저장
        form = StudentForm(request.POST)
        if form.is_valid():
            student = form.save()
            return redirect()

    elif request.method == 'GET':
        # HTML 던져주기
        form = StudentForm()
    
    context = {'form':form,}
    return render(request, 'classroom/new.html',context)

```

**POST와 GET이 아닌 다른 메소드로 요청이 들어올 경우를 막기**

`from django.views.decorators.http import require_http_methods, require_safe, require_post`



**함수 위에 데코레이팅 @**

- DB에 영향이 있다(CUD) => not safe

`@require_http_methods(['GET', 'POST'])`

​	데코레이팅 안하면 서버 잘못이라고 500 이라고 나오는데 이젠 클라이언트 잘못이라고 405라고 나옴

`@require_POST`

post만 받겠다.

- DB에 영향이 없다(R) => safe

`@require_safe`



![image-20230111143114013](https://github.com/choe-yujin/TIL/blob/master/07_Web/07_Django_forms.assets/image-20230111143114013.png)





### form.html(new/edit)

![image-20230111144516182](https://github.com/choe-yujin/TIL/blob/master/07_Web/07_Django_forms.assets/image-20230111144516182.png)

form action="" 비워두면 현재의 url이 기본세팅됨

new.html과 edit.html은 form action주소가 어차피 자기 자신의 주소니까 form action 비워두고 똑같은 코드의 form.html 하나로 통일하면 됨

```django
{% extends 'base.html' %}
{% load bootstrap5 %}
{% block content %}
<form method="POST">
    {% csrf_token %}
    {% bootstrap_form form %}
    <button class="btn btn-primary">제출</button>
</form>
{% endblock content %}
```

`pip install django-bootstrap-v5`

`INSTALLED_APPS =['bootstrap5',]`





## References

> 장고 부트스트랩 https://django-bootstrap-v5.readthedocs.io/en/latest/installation.html