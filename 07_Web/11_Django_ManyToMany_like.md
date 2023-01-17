# Django_Many to Many

23년1월17일(화)

## 학습목표

- Many to Many관계의 모델링과 CRUD를 이해한다. 
- 연결된 db 객체에 접근하는 방법, Reverse Manager의 개념을 숙지한다.

- 이를 바탕으로 좋아요 기능을 추가 구현해본다.

  

## 프로젝트 세팅

`mkdir MANY_TO_MANY`

`cd MANY_TO_MANY`

`python -m venv venv`

`code .` select Interpreter 터미널 켜기

`pip install django==3.2.16 ` `django_extensions`

`pip freeze > requirements.txt`

`touch .gitignore README.md`

`django-admin startproject many_to_many .`

gitignore.io에서 `venv` `python` `django`  복붙

`mkdir templates`

`touch templates/base.html`

`python manage.py startapp facebook`

`python manage.py startapp school`

`cd facebook/`

`touch urls.py forms.py`

`mkdir -p templates/facebook`

`cd templates/facebook/`

`touch question_form.html question_index.html question_detail.html`

`cd-` `cd ..`

`cd school/`

`touch urls.py forms.py`

`mkdir -p templates/school`

`cd templates/school/`

`touch login.html signup.html`

`cd-` `cd ..`

- setting.py

TEMPLATES [ BASE_DIR / 'templates', ]

INSTALLED_APPS =['django_extensions', 'facebook', 'school',]

- 마스터urls.py에 path include추가



## Model

### 1. Facebook앱

2 Model 3 Table

Join Table에 FK 외에 추가 컬럼이 필요 없는 경우

모델 클래스 따로 정의 안해도 models.ManyToManyField(모델명)가 알아서 join Table만들어 줌 

```python
from django.db import models

class Person(models.Model):
    name = models.CharField(max_length=100)
    age = models.IntegerField(default=20)
    #필드는 바깥에 놓고
    #추가적 정보는 Meta에 넣어놔야지
    #Migration이 인지함

    # shell에서 객체 호출시 원하는 정보 보여주도록 커스텀
    def __str__(self):
        return f'{self.pk}: {self.name}'

class Feed(models.Model):
    # Person(1): Feed(N)
    # p1이 작성한 글 다 가져와 p1.feed_set.all()
    #related_name='feeds'로 설정한 후엔
    # p1이 작성한 글 다 가져와 p1.feeds.all()
    author = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='feeds')
    content = models.TextField()
    # ManyToManyField는 실제로 테이블을 만든다.
    like_people = models.ManyToManyField(Person, related_name='like_feeds')
    # Person(M) : Feed(N)
    # f1에 좋아요 한 사람들 가져와 
    # f1.like_people.all()
    # p1이 좋아요 한 글 다 가져와
    # p1.feed_set.all()
    # related_name ='like_feeds' 후
    # p1.like_feeds.all()
    
    # dislike_people = models.ManyToManyField(Person, related_name='dislike_feeds')
    # f1.dislike_people f1에 싫어요 누른 사람 다 나옴
    # p1.dislike_feeds p1이 싫어요 누른 피드가 다 나옴

    

class Comment(models.Model):
    author = models.ForeignKey(Person, on_delete=models.CASCADE)
    feed = models.ForeignKey(Feed, on_delete=models.CASCADE)
    content = models.CharField(max_length=300)
```

`python manage.py makemigrations`

`python manage.py migrate facebook` 우선 facebook만 DB 생성해 보겠음

`python manage.py shell_plus`

```shell
p1 = Person.objects.create(name='yj', age='10')
p2 = Person.objects.create(name='justin', age=25) # age가 int든 str이든 알아서 db에들어감
p3 = Person.objects.create(name='alex', age=23)
f1 = Feed.objects.create(content='좋은아침', author=p1)
c1 = Comment.objects.create(content='굿모닝', feed=f1, author=p2)
```

**1:N에서 1입장에서 N들을 불러올 때 Reverse Manager가 자동으로 설정됨**

p1.feed_set 리버스 매니저

p1.feed_set.all() 모든 글

p1.feed_set.get(pk=1) 모든 글 중 pk이 1인거 하나(첫번째 글)

 

---

#### Reverse Manage와 related_name

**1단계) Feed모델에 author만 있었을때**  

=> Person(1) : Feed(N)관계로 Person테이블에 연결된 N테이블 항목들이라는 의미로 xxx_set 리버스 매니저가 디폴트로 제공되었다.

그래서 `p1.feed_set`은  p1이 feed를 부를때 쓰는 리버스 매니저를 의미한다. 이 매니저의 여러 메소드를 통해 p1에서 feed에 접근 가능했다.

Feed모델에 author만 정의돼 있었을때는 ` p1.feed_set.all()`이 p1이 쓴 모든 feed을 의미했다.

**2단계) Feed모델에 like_feeds를 추가할 때 migration 오류가 나서 DB생성 안 됨.**

Why? 

People(M) : Feed(N) 관계가 하나 더 생겼다. Person과 N관계가 두개가 생긴 Feed입장에서는 xxx_set 리버스 매니저가 어디에도 자동 배정될 수 없기 때문이다. 

(feed와 person은 2개의 관계가 있다.

p1의 작성 게시글로써의 관계 f1,f2,f3,f4.... 1:N

p1이 좋아요 한 관계 f1,f2,f3... 가 있을 수 있다. M:N

ex)개체간의 관계가 특정 하나만 있는게 아님. 친구이자 직장동료

**3단계) 그래서 Feed모델의 author에 리버스매니저의 related_name을 따로 지어주었더니  like_feeds를 추가해도 migration 오류 없이 DB가 생성됐다.**

`author = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='feeds')`

like_feeds은 related_name을 따로 지정해주지 않은 경우

`like_people = models.ManyToManyField(Person)`

`p1.feed_set.all()` 리버스매니저는 이제 p1이 쓴 모든 글이 아닌, p1이 좋아요 한 글들을 의미한다.

**4단계) like_feeds의 related_name을 'like_feeds'로 바꿔줌**

`like_people = models.ManyToManyField(Person, related_name='like_feeds')`

`p1.feed_set` 은 이제 없다.

p1으로 Feed모델에 접근 가능하게 하는 리버스매니저`p1.feeds` 

p1으로 (ManyToManyField로 자동생성된)좋아요 모델에 접근 가능하게 하는 리버스 매니저  `p1.like_feeds` 만 있다.



---



**Q.다대다필드를 Feed가 아닌 Person이 들고 있어도 되나요?** 

=> class정의 순서를 바꾸거나, 안 바꿀거면 그냥 문자열로 써주면 된다.

'앱네임.필드명'  걍 '필드명'만 적어도 됨.

`like_feed = models.ManyToManyField('facebook.Feed')`



**Q.manytomanyfiled코드로 자동생성된 좋아요의 중계 테이블 facebook_feed_like_people 이름 가지고는 조회나 생성이 안되는건가요?**

=> 안 됨. 되더라도 자체 데이터 없으니까 의미 없음.





#### 연결된 모델 Read 예시

p1이 작성한 글들 중 첫번째글에 좋아요 누른 사람들 중에 나이가 제일 어린 사람이 작성한 글 전체

=>	`p1.feeds.first().like_people.order_by('age'[0]).feeds.all()`

p1이 작성한 글들 중 첫번째글에 좋아요 누른 사람들 중에 나이가 제일 어린 사람이 작성한 첫번째 글의 댓글 

=> `p1.feeds.first().like_people.order_by('age'[0]).feeds.first().comment_set.all()`



---



### 2. school앱

3 Model 3 Table

Join Table에 FK 외에 추가 컬럼이 필요한 경우

모델 정의해 Join Table만들기 

```python
from django.db import models

class Lecture(models.Model):
    title = models.CharField(max_length=100)
    room = models.CharField(max_length=100)

    def __str__(self):
        return f'#{self.pk}: {self.title} - {self.room}호'

#s1.lectures.all()
#s1이 수강신청한 모든 수업
#l1.students.all()
#l1을 수강신청한 모든 학생
class Student(models.Model):
    name = models.CharField(max_length=30)
    major = models.CharField(max_length=30)
    lectures = models.ManyToManyField(
        Lecture,                 # m:n 관계의 상대 모델
        related_name='students', # 상대모델(Lecture)이 나(Student)를 부르는 이름
        through='Enrollment',     # 커스텀 중계모델 이름('str') Enrollment
        through_fields=('student','lecture')# M:N을 맺는 FK들 명시 (필수는 아님,적으려면 FK순서 중요)
    )

    def __str__(self):
        return f'#{self.pk}: {self.name} - {self.major}'

# Join Table에 FK 외에 추가 데이터가 있다면, 클래스 생성해야됨
# grade랑 semester 컬럼 추가되니까
class Enrollment(models.Model):
    lecture = models.ForeignKey(Lecture, on_delete=models.CASCADE)
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    grade = models.CharField(max_length=2)
    semester = models.CharField(max_length=20)

    def __str__(self):
        return f'{self.student} => {self.lecture}'
```



---

#### 예시

##### DB에 학생,강의 추가 - 학생객체들과 강의 객체들을 생성해보자.

```shell
>>> s1 = Student.objects.create(name='neo', major='SOC')
>>> s2 = Student.objects.create(name='justin', major='PSY')
>>> s3 = Student.objects.create(name='alex', major='CSE')
>>> s4 = Student.objects.create(name='kyle', major='MCH')
>>> l1 = Lecture.objects.create(title='파이썬기초', room='101')
>>> l2 = Lecture.objects.create(title='결준특', room='231')
>>> l3 = Lecture.objects.create(title='심리학개론', room='B101')
>>> l4 = Lecture.objects.create(title='무기화학', room='1301')
>>> 
```



 `s1.lectures.add(l1)` 하고 school_enrollment DB보면 create되어 있다. 

grade랑 semester는 비워진채로. 

grade랑 semester는 CharField, 즉, str이기 때문에 자동으로 비워져서 들어간거임.

**Q. school_enrollment DB내에 방금 생성된 id 1의 grade랑 semester는 어캐 채울까?**

이 레코드 한줄을 잡아야한다. 어떻게?

Enrollment.objects.get(pk=1) 여기 pk는 school enrollment의 DB보고 나서야 안거임.

하지만 Enrollment의 id로 잡는게 아니라 lecture_id나 student_id를 잡아서 grade주는게 논리에 맞음.

어떻게? 

```shell
e1 = Enrollment.objects.get(student=s1, lecture=l1)

e1.grade = 'B+'

e1.semester = '2023-1'

e1.save()
```



예시) 내 필드야? 남의 리버스매니저야?

| 객체 | related_name/field_name | 메소드 |
| ---- | ----------------------- | ------ |
| s1.  | lectures(필드명)        | .all() |
| l1.  | students(리버스매니저)  | .all() |

(Student모델에서 Lecture모델이랑 연결된 ManytoManyFiled내 적어준 리버스매니저명. Lecture 모델 내엔 student접근할 수 있는 필드가 명시된 게 없으니 리버스매니저명 통해서 접근해야 함.)



##### 수강신청(create)과 정정(update)을 해보자.

```shell
s1.lectures.add(l1) # 자동으로 Enrollment의 객체가 생성됨(권장X)


# 방금 생성된 Enrollment 객체 조회(pk조회가 아닌 fk조회)

e1 = Enrollment.objects.get(student=s1, lecture=l1)

e1.student == s1

e1.lecture == l1



# 자동 생성시 비어있는 항목들

e1.grade == ''

e1.semester == ''



# 수동으로 채워주기

e1.grade = 'B+'

e1.semester = '2023-1'

e1.save()
```



##### 좋아요를 담당하는 테이블 , 중개테이블조차 하나의 객체로/학생 기준, 강의 기준 아닌, 중개테이블 기준으로 수강신청 생성하기

```shell
e2 = Enrollment()

e2.student = s1

e2.lecture = l2

e2.grade = 'C+'

e2.semester = '2023-1'

e2.save()

#사람 기준, 렉쳐 기준 아닌, 중개테이블 기준으로 생성했지만,
#s1.lectures.all()해도 나온다.
```



##### s2,s3,s4학생에 Enrollment기준으로 결준특 수강신청하기

```shell
Enrollment.objects.create(student=s2, lecture=l2)

Enrollment.objects.create(student=s3, lecture=l2)

Enrollment.objects.create(student=s3, lecture=l2)
```



##### 결준특 듣는 모든 학생들 목록 조회

```shell
l2.students.all()
```



##### 결준특 듣는 학생들 중 기계공학과 학생들 목록만 조회

````shell
l2.students.all().filter(major='MCH')

l2.students.filter(major='MCH')  # all 안 써도 됨
````



>  Tip!  shell_plus에서는 import된 함수들로 복잡한 조건 조회 가능하다.



##### 수강신청을 새로 생성

```shell
Enrollment.objects.create(student=s1, lecture=l2, grade='C+', semester='2023-1')
```



##### s1학생이 듣는 모든 수업

````shell
s1.lectures.all()
````



##### l2(결준특) 듣는 모든 수강생

```shell
l2.students.all()
```





---

#### Facebook앱의 좋아요 기능

```shell
f1 = Feed.objects.get(pk=1)

f1.like_people.all()

jiah = Person.objects.get(pk=1)
```

**좋아요 누른 사람들 중 jiah가 있나 없나 아는 방법?** (좋아요 이미 했으면 좋아요 시킬지 좋아요 취소시킬지 조건 분기할 수 있으니)

- 첫번째 방법 
  - `jiah in f1.like_people.all()`  # False
- 두번째 방법 
  - `f1.like_people.filter(pk=jiah.pk).exists()`  # False

두번째 방법이 베스트다! 

왜 ?

첫번째는 디비에서 데이터 다 받아서 파이썬에서 검사하는거고, 두번째는 디비에서 검사해서 파이썬으로 하나만 갖고 오는거라서

데이터 많아질수록 속도차 많이 나니까 첫번째 방법은 비효율적.







----

## OneToMany프로젝트에 좋아요 기능을 추가해보자.

코드 뜯어 고치기

### accounts앱의 models.py

```python
from django.contrib.auth.models import AbstractUser

# 장고 왈 : User모델에 아무 필드 추가 안 하더라도 이렇게 만들어 놔라
# 왜? 
# 만약 기본 제공한 AuthUser 쓰다가 컬럼 추가 커스텀하게 되는 경우, 
# 기존 모델에 있던 사용자 데이터는 다 날라가니까 고생 좀 할거다
class User(AbstractUser):
    
    # 오버라이드
    def __str__(self):
        return self.username
```



### setting.py

`AUTH_USER_MODEL = 'accounts.User'` (앱명.모델명) 추가

=> 우리 프로젝트 전체 회원은 앞으로 accounts App의 User모델이 담당한다는 의미



### 다시 모델링

```python
# 이전 DB 지우기
rm db.sqlite3 accounts/migrations/0* board/migrations/0*
```



### board앱의 models.py

**장고 왈: User만큼은 그냥 User모델명 그대로가 아니라`settings.AUTH_USER_MODEL`이라고 불러주세요!!**

#### Article모델 수정

- Article모델의 FK인 user에 related_name인자 추가

   -  user가 article들을 뭐라고 부를거냐? (1:N)

       `related_name = 'articles'`이제부터 `article_set`이 아니라 `articles`라고 부를게요~

- Article모델의 ManyToMany필드에 related_name인자 추가

  - user가 Article이랑 연결된 좋아요 join테이블은 뭐라고 부를거냐? (M:N)
    
    user객체 입장에서는 related_name인 `like_articles`라고 부를게요!!
    
    article객체 입장에서는필드명 `like_users`라고 부를게요!!
    
    `like_users = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='like_articles')`



#### Comment모델 수정

- Comment모델의 FK인 user에 related_name인자 추가

   - user가 comment들을 뭐라고 부를거냐? (1:N)

     `related_name = 'comments'`이제부터 `comment_set`이 아니라 `comments`라고 부를게요~
     
     ```python
     class Article(models.Model):
         user = models.ForeignKey(
         	setting.AUTH_USER_MODEL, # 장고가 권장
             on_delete = models.CASCADE,
             related_name = 'articles' #
         )
         like_users = models.ManyToManyField(
         	settings.AUTH_USER_MODEL,
             related_name = 'like_articles' #
         )
         title...
     ```
     
     

- Comment모델의 FK인 article에 related_name인자 추가 

  - article이 comments들을 뭐라고 부를거냐? (1:N) 

    `related_name = 'comments'`이제부터 `comment_set`이 아니라 `comments`라고 부를게요~
    
    ```python
    class Comment(models.Model):
        user = models.ForeignKey(
        	settings.AUTH_USER_MODEL,  # 장고가 권장
            on_delete = models.CASCADE,
            related_name = 'comments', #
        )
        article = models.ForeignKey(
        	Article,
            on_delete = models.CASCADE,
            related_name = 'comments' #
        )
        content...
    ```
    
    

모델 바꼈으니 migrations와 migrate도 다시 하기



#### runserver 회원가입 POST요청시 AttributeError

`AttributeError` at /accounts/signup/에 

**Manager isn't available; 'auth.User' has been swapped for 'accounts.User'** 에러남. 

왜?

=> account앱의 views.py에 `UserCreationForm`쓰고 있었는데

`UserCreationForm`은 기본auth.User를 가리키니까 이런 오류 남.



AbstractUser

└	auth.User 기본 제공 됐던거

└	User 우리가 아까 만든거



### accounts앱의 forms.py

```python
# User가 accounts.User로 바꼈으니 추가해야할 것
from django.contrib.auth.forms import UserCreationForm

User = get_user_model()
class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = User
        fields=('username', )
```

**Q. class CustomUserCreationForm의 Meta안의 model = User의 의미가 accounts.User라고 명시해 준건가요?**

`User = get_user_model()`이 하는일은 상수값을 보고 알아서 setting.py에서 적어준 User, 즉, `accounts.User`를 가져와줌.





### accounts앱의 views.py

이제 `UserCreationForm` 임포트 필요없음. 지우자.

`from .forms import CustomUserCreationForm `추가해주자.

```py
from .forms import CustomUserCreationForm, CustomUserChangeForm

User = get_user_model()
```



### board앱의 forms.py

- 또 runserver. url/articles/create/의 폼 생긴게 이상해~

글 쓸때 폼에서 User를 셀렉하게 하니까 못하게 board앱의 forms.py 필드에서 user빼주자.

```python
class ArticleForm(form.ModelForm):
    class MetaL
    	model = Article
        fields = ('title', 'content',)
        # exclude = ('user', )
```



### board앱의 _comment_list.html

이제 `article.comment_set.all`이 아니라 `article.comments.all`이다.



### board앱의 views.py

좋아요 `p1.like_articles.add(a1)` 이거 어디다가 넣어야됨?

```python
@login_required
@require_POST  # DB create니까
def like_article(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    # 게시글 하나/사용자 하나
    # u1.like_articles.add(a1)
    # a1.like_users.add(u1)
    # 사용자 하나 u1와 게시글 하나 a1을 어떻게 잡을거냐?
    # user가 특정 게시글을 좋아요 한다!
    request.user.like_articles.add(article)
    # request.user는 유저객체다.
    # models가서보면 User입장에서는 Article을 like_articles라고 부르기로했다.
    return redirect('board:article_detail', article.pk)
    
```

기존에 좋아요를 했으면 좋아요 테이블에서 삭제

아니라면 좋아요 테이블에 추가하도록 함수 수정하기

```python
#if user in article.like_users.all() 비추. db에서 싹 다 가져오지마. 효율 안좋아.
# 게시글에 좋아요 한 사람들 중에, pk가 user랑 pk같은 사람 존재하나요?
user = request.user
is_like = article.like_users.filter(pk=user.pk).exists()  # T/F

#기존에 좋아요 했으면
if is_like:
    # 좋아요 테이블에서 삭제
    user.like_articles.remove(article)
#아니라면
else:
    user.like_articles.add(article)
```



### board앱의 urls.py

`path('<int:article_pk>/like/', views.like_article, name='like_article'),`



### detail.html

좋아요 UI

```django
{% if request.user.is_autenticated %}
<form action="{% url 'board:like_article' article.pk %}" method="POST">
    {% csrf_token%}
    <button>좋아요 +1</button>
</form>
{% endif %}
```

좋아요 안좋아요 UI

```django
{% if request.user.is_autenticated %}
<form action="{% url 'board:like_article' article.pk %}" method="POST">
    {% csrf_token%}
   
    {%% if is_like}
    <button>좋아요 취소</button>
    {% else %}
    <button>좋아요 +1</button>
    {% endif %}
</form>
{% endif %}
```

장고는 ()못씀. 

`{% if article.like_users.filter(pk=user.pk).exists() %}` 못쓴다. 

그럼 어떻게 해?

=> views.py에서 detail페이지 응답시 is_like를 context에 넣어서 보내자.

```python
# 좋아여 여부 확인. 좋아요 버튼 UI결정 flag를 위해 추가할 것
def article_detail(request, article_pk):
    # article 상세 페이지
    article = get_object_or_404(Article, pk=article_pk)
    # 댓글 입력 창 => _comment_form.html
    form = CommentForm()
    # 좋아요 버튼 UI 결정 Flag
    is_like=article.like_users.filter(pk=request.user.pk).exists()
    
    context={
        'article': article,
        'form': form,
        'is_like':is_like,
    }
    return render(request, 'board/detail.html', context)
```



### detail.html

```django
<h1>{{ article.title}} ({{ article.comments.count }})</h1> 
<p>by - {{ article.user.username }}</p>

<p>{{ article.content }}
```



![image-20230117152318971](C:\Users\a\TIL\07_Web\11_Django_Many.assets\image-20230117152318971.png)

```django
{{article.comments.count}} 아티클이 댓글 부를때 comments라 부르기로 했으니. 그 댓글들 수.
{{article.like_users.count}} 아티클을 좋아하는 사용자 수(Article의 필드명 like_users)
```

![image-20230117152327308](C:\Users\a\TIL\07_Web\11_Django_Many.assets\image-20230117152327308.png)



### index.html

comments와 like_users로 이름 바꿔주기.

```django
{% for article in articles %}
<li>
	<a href="{% url 'board:article_detail' article.pk %}">
        {{ article.title }}
    </a>({{article.comments.count}}) | +{{ article.like_users.count }}
</li>
```



---



**Q.좋아요 순으로 게시글을 정렬하려면 어떻게 할까?**

Article에 가상의 like_cnt컬럼(좋아요 테이블에서 cnt) 기준으로 내림차순,오름차순해야한다.

![image-20230117153709708](C:\Users\a\TIL\07_Web\11_Django_Many.assets\image-20230117153709708.png)

annotate는 주석을 의미함.

Article엔 없는 컬럼이지만 가상의 컬럼like_count를 만들거야!

Article입장에서는 like_users를 기준으로 카운트할거야.

정렬 기준은 like_count의 내림차순이야.

```python
# 좋아요순으로 정렬하기 위해 추가/수정해야 할 코드
from django.db.models import Count  # 밑에서 쓸 Count함수 꺼내기 위함
def article_index(request):
    articles = Article.objects.annotate(like_count=Count('like_users')).order_by('-like_count')
```

![image-20230117154527171](C:\Users\a\TIL\07_Web\11_Django_Many.assets\image-20230117154527171.png)

```python
# 실험
# 가상이지만 프린트 됨
for a in Article.objects.annotate(like_count=Count('like_users')):
    print(a.like_count)
```

SQL로 보면 이런 쿼리임.

![image-20230117154246081](C:\Users\a\TIL\07_Web\11_Django_Many.assets\image-20230117154246081.png)



**Q. 게시글 목록 좋아요순으로 보기, 최신순으로 보기, 댓글순으로 보기는 어캐 구현?**

요청이 바뀌는거임

```python
# 예시
'http://127.0.0.1:8000/articles/?order=like'
'http://127.0.0.1:8000/articles/?order=new'
'http://127.0.0.1:8000/articles/?order=comment'
```



view에서는 if분기가 바뀌는거임

```python
# 예시
if request.GET.get('order') == 'like':
    좋아요 많은순
elif request.GET.get('order') == 'new':
    Article.objects.order_by('-created_at')
```





## References

> 장고 Many to Many 모델 https://docs.djangoproject.com/en/4.1/topics/db/examples/many_to_many/
>
> 장고 M:N 심화 https://docs.djangoproject.com/en/4.1/ref/models/fields/#django.db.models.ManyToManyField
>
> 장고 쿼리 https://docs.djangoproject.com/en/4.1/ref/models/querysets/
>
> 장고 annotate(가상 컬럼 추가)실습 http://raccoonyy.github.io/django-annotate-and-aggregate-like-as-excel/
