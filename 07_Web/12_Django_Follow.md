# Django 좋아요 팔로우

23년1월18일(수)

## 오늘의 학습

- RECAP 프로젝트 뜯어고치기.

- reply앱의 vote를 좋아요 기능과 팔로우 기능으로 수정해보자.



## 1)좋아요 기능

### polls/models.py

```python
# 변경할 코드
class Reply(models.Model):
    # reply.____.all => 이reply와 M:N 관계 갖고있는 User들이 나와야 된다. 
    #vote = models.IntegerField(default=0)
    vote_users = models.ManyToManyField(
        settings.AUTH_USER_MODEL, 
        # user.____.all() => 이 User와 M:M Reply가 나와야 한다.
        related_name = 'vote_replies'
        )
```

이전 DB지우고 다시 생성하기

`rm db.sqlite3 accounts/migrations/0* polls/migrations/0*`

`python manage.py makemigrations`

`python manage.py migrate`



### polls/views.py

reply_upvote함수를 vote_reply함수로 수정

```python
@login_required
@require_POST
def reply_upvote(request, question_pk, reply_pk):
    question = get_object_or_404(Question, pk=question_pk)
    reply = get_object_or_404(Reply, pk=reply_pk)
    # +1 누른 사람(요청 보낸 사람)이 reply 작성자가 아닐때만
    if request.user != reply.user:
        reply.vote += 1
        reply.save()
    return redirect('polls:question_detail', question.pk)
    
# ==========================================
# 수정 코드
@login_required
@require_POST
def vote_reply(request, question_pk, reply_pk):  #/polls/1/replies/2/vote/
    # FIXME: urls.py에서 url pattern,함수명 바꿔주기
    question = get_object_or_404(Question, pk=question_pk)
    reply = get_object_or_404(Reply, pk=reply_pk)
    user = request.user

    if request.user != reply.user:
        #reply, request.user #답변, 사용자
        #현재 답변과, 현재 사용자를 DB에 레코드 추가
        is_voted = reply.vote_users.filter(pk=user.pk).exists()  # polls_reply_vote_users 레코드 확인
        if is_voted:  # 기존에 투표 했으면 (레코드가 존재하면)
            reply.vote_users.remove(user)  # (레코드 삭제)
        else:  # 기존에 투표 안했으면 (레코드가 없으면)
            reply.vote_users.add(user)  #(레코드 추가)request.user.vote_reply.add(reply) 주어를 누구로 보느냐

    return redirect('polls:question_detail', question.pk)
#========================================
    # 답변 작성자는 투표 못함 => 자기추천금지 추가
    if request.user == reply.user:
        return HttpResponseForbidden('자기추천금지')
    is_voted = reply.vote_users.filter(pk=user.pk).exists()
    if is_voted:  
        reply.vote_users.remove(user) 
    else:  
        reply.vote_users.add(user)  

    return redirect('polls:question_detail', question.pk)
#=========================================
#reply.is_vote(user) => True/False 나오면 좋겠다. 모델에 is_vote함수정의해줌
is_voted = reply.is_voted(user) 
```

> 주석용 예약 Todo Tree 설치
>
> TODO: 나중에 해야할 일
>
> FIXME: 지금 당장 해야할 일
>
> NOTE: 노트



### question_detail.html

url의 `polls:reply_upvote`는 `polls:vote_reply`로 수정

- 댓글목록 페이지
- 로그인한 리퀘스트 사용자가 특정 댓글에 vote했으면 vote취소 vote안했으면 vote 하는 기능 추가

N개의 reply들 각각에 request.user가 vote 했는지 여부를 알아야 함

reply_vote여부 : [True, False, True, True, False, True]...

여러 댓글들에 댓글 작성자 pk를 어캐 뺄껀데?

```
if request.user in reply.vote_users.all 메모리 효율은 안좋지만...일단...이렇게 하기로
```



### 모델에 함수를 정의

views에서 자주 쓰는 코드는 모델에서 미리 정의하고 간단한 코드로 쓰기

**reply.is_vote(user) => True/False 나오면 좋겠다.** 

```python
class Reply(models.Model):
    #
    #
	def is_voted(self, user): # reply.is_voted(user)
    	    return self.vote_users.filter(pk=user.pk).exists()
```



### html에서 함수 쓰기

html에서 textarea 엔터로 입력 했어도 출력은 옆으로 이어짐

`{{ article.content | linebreaksbr }} `

`linebreaksbr`빌트인함수 | 왼편에 인자를 넣으면 엔터되어 출력 된다.

(하지만 is_voted(인자) 필요하니 괄호 못 쓰는 html에서는 쓸 수 없겠다.)

비효율적이긴 하지만 그냥 reply.vote_users.all 다 가져오자.

`if request.user in reply.vote_users.all`



### html에서 인자 있는 함수 쓰기

polls/templatetags 폴더 만들기

`__init__.py`와 `polls_extra.py`만들기

```python
# polls/
#    templatetags/
#        __init__.py
#        polls_extra.py

from django import template

register = template.Library()

@register.simple_tag # 간단한 태그 만들테니 템플릿에 등록해주세요
def check_user_vote(reply, user):
    return reply.is_voted(user)
```

question_detail.html에

`{% load polls_extra %}`

`{% check_user_voted reply request.user %}` 드디어 인자가 넘어왔다!

`{% if check_user_voted reply request.user %}` 오류남. if문에서는 값 하나로 인지 못함.

어캐?

`{% check_user_voted reply request.user as flag %}` 값을 flag변수에 담기

`{%if flag%} ` flag 변수값으로 if문 분기할 수 있다~

좋아요 버튼 보여줘

`{% else %}`

좋아요취소 버튼 보여줘

`{% end if %}`





## 2)Follow 기능

| id   | user_id(star_id) | user_id(fan_id) |
| ---- | ---------------- | --------------- |
|      | 1                | 2               |
|      | 2                | 1               |
|      | 1                | 3               |
|      | 1                | 4               |

### accounts/models.py

```python
class User(AbstractUser):
    fans = models.ManyToManyField('self', symmetrical=False, related_name='stars')
#필드명을 stars로 쓰고 related_name을 fans로 써도 됨. 데이터 쓸 때 내가 일관성 있게 쓰기만 하면 
# join테이블에는 from_user_id, to_user_id로 자동생성됨

# symmetrical대칭
# 'self', symmetrical=True면 1,2 만드는 순간 2,1이 자동으로 만들어짐

# 쿼리
# u1.stars.add(u2)  # u1 => u2
# u2.stars.add(u1)  # u2 => u1
# u1.fans.remove(u2)  # u2=x> ul 

# u2.fans.count()  # 팬들 수
# u1.stars.count()  # 팔로잉 수
# u2.fans.filter(username='admin')  # 팬들 중 이름이 admin인 팬
# u2.fans.filter(mbti__contains='EN') # 팬들 중 mbti가 EN이 포함되는 팬
```



### account/views.py

1. 어디서 팔로우 관리를 할까? 버튼을 어느 페이지에 줄지. => Profile Page가 있어야 됨

2. 실제 팔로우 기능

/accounts/1/ 이 주소 별로임. 비밀계정 운영하고 싶은 사람 있으니까

/accounts/yujin 유저네임으로 요청보내자

```python
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_safe, require_post
from django.contrib.auth import get_user_model

User = get_user_model()

# 팔로우관리 Profile
@require_safe
def profile(request, username):
    me = request.user
    profile_user = get_object_or_404(User, username=username)  # 모델 필드명=변수
    is_following = me.stars.filter(pk=profile_user.pk).exists()  # 내가 이 사람 팔로잉 하고 있나?
    context={'profile_user':profile_user, 'is_following':is_following, }
    return render(request, 'accounts/profile.html',context)

# 실제 팔로우 기능
@require_POST
def follow(request, username):
    me = request.user  # 요청 보낸 사용자
    you = get_object_or_404(User, username=username)  # 팔로우 대상 사용자
    if me == you:
        return HttpResponseBadRequest('나르시즘')
    
    is_following = me.stars.filter(pk=you.pk).exists()

    if is_following:
        me.stars.remove(you)
    else:
        me.stars.add(you)
    return redirect('accounts:profile', you.username)
```

로그아웃한 사람이 남의 프로필 볼때 attribute에러 남

왜? me=request.user가 없으니 me.stars 함수 못 쓴다

```python
@require_safe
def profile(request, username):
    me = request.user
    profile_user = get_object_or_404(User, username=username)  # 모델 필드명=변수
    
    if me.is_authenticated : # 요청 보낸 사용자가 로그인 했다면,
        is_following = me.stars.filter(pk=profile_user.pk).exists()  # 내가 이사람 팔로잉 하고 있나?
    else:
        is_following = None  # 밑의 context때문에 None 넣어줌

    context={'profile_user':profile_user, 'is_following':is_following, }
    return render(request, 'accounts/profile.html',context)
```



### accounts/profile.html만들기

실은 request.user랑 user랑 의미가 같다.

context에서 user로 담아 보내주면 request.user였던 user가 context에서 받은 user가 되지만

좀더 직관적으로 user가 아닌 profile_user로 네이밍해서 보내주겠음

```django
{% extends 'base.html' %}
{% block content %}
<h1>{{profile_user.username}}'s Profile Page</h1>
<div>
    팔로워 수:{{profile_user.fans.count}}
    팔로잉 수:{{profile_user.stars.count}}
    <button>팔로우</button> 팔로워 수:
    <button>언팔</button>
</div>
<h2>작성한 Question목록</h2>
<ul>
    {% for question in profile_user.question_set.all %}
    <li>
        <a href="{% url 'polls:question_detail' question.pk %}">{{ question.title }}</a>
    </li>
    {% endfor %}
</ul>
<h2>작성한 Reply 목록</h2>
<ul>
    {% for reply in profile_user.reply_set.all %}
    <li>
        {% comment %} 그 댓글을 쓴 원글로 보내야 {% endcomment %}
        <a href="{% url 'polls:question_detail' reply.question.pk %}">
            {{ reply.content }}
        </a>
    </li>
    {% endfor %}
</ul>

{% endblock content %}
```



### accounts/urls.py

```python
# accounts/yujin/
path('<username>/', views.profile, name='profile'),
# accounts/yujin/follow/
path('<username>/follow/', views.follow, name='follow'),
```



### question_detail.html

로그인 안했으면 댓글 입력창 안 뜨게 조건 추가해 댓글 폼 선택적으로 보여주기

```django
{% if request.user.is_authenticated %}
댓글폼
{% end if %}
```



### base.html

```django
<li>
    <a href="{% url 'accounts:profile' request.user.username %}">   
        {{user}}님의 my page
    </a>
</li>
```

여기서 `request.user.username`과 `user.username`과 `user`는 모두 같은 출력



**TODO**

1.게시글 작성자 클릭 => 프로필 페이지로 이동하도록 하기

2.댓글 작성자 클릭 => 프로필 페이지로 이동하도록 하기

+프로필페이지에서 좀 더 많은 정보 보여주기(팔로워의 MBTI카운트 분포도 등, 우리가 힘써서 학습해야 하는 부분은 사실 이 부가기능이다. DB에서 잘 Read해 가져와서 잘 보여주기.)



### question_detail.html

```django
<!--작성자-->
by-
<a hrf="{ url 'accounts:profile' question.user.username}">
{{question.user.username}}
</a>

<!--reply의 컨텐트-->
<a hrf="{ url 'accounts:profile' reply.user.username}">
{{reply.user.username}}
</a>
```



## 번외

**서버리스란?**

네가 서버 만들 필요 없어. 우리가 API뚫어줄테니 너는 DB신경쓰지말고 코드에 집중해. 대신 우리가 서버는 대신 관리 해줄게.

**10만명 접속 허용 시스템은 어떻게 구현되나?**

(우리나라가 자바 선호하는 이유? 시장에 자바 개발자가 많아서. 정부 프레임워크 때문에.)

- 1명_1사용자:1기계 AWS EC2인스턴스의 클라우드에 배포

- 10명_ 데이터베이스 계층 분리. 장고와 서버 분리. API,Client(Website)----Amazon RDS(DB만)

- 100명_ 클라이언트를 분리. Website,MobileApp - API - DB

![image-20230118155702485](https://github.com/choe-yujin/TIL/blob/master/07_Web/12_Django_Follow.assets/image-20230118155702485.png)

(우리는 장고 안에서 전부 해결했으나, 나중엔 템플릿(프론트엔드)을 따로 떼어내고, 장고의 View,Model(백엔드)에서 Model을 떼어내고)

ex) TMDB의API TMDB는 영화 데이터 다 갖고 있는데 json딕셔너리 데이터만 뱉어줬다.

API한번 프로그래밍해서 Website랑 MobileApp에 보여줌

![image-20230118160427516](https://github.com/choe-yujin/TIL/blob/master/07_Web/12_Django_Follow.assets/image-20230118160427516.png)



- 1000명_로드 밸런서 추가. 외로운 API인스턴스 장고가  views.py가 딱 하나인데 모든 트래픽 요청을 혼자 견딜 수 없다. 장고가 *n이 되어야 한다. 수평적 확장. 동일한 코드를 실행하는 서버를 더 추가하여 처리할 수 있는 요청량 증가. 로드밸런서는 트래픽이 가장 적은 인스턴스로 요청을 라우팅한다.(Heroku)

![image-20230118155936118](https://github.com/choe-yujin/TIL/blob/master/07_Web/12_Django_Follow.assets/image-20230118155936118.png)



- 1만명_CDN(클라우드 스토리지 서비스) API는 이미지 및 이미지 업로드같은 작업을 처리하지 않게 한다. 주요데이터센터-한국. 이미지 요청오면 한국 데이터센터에 사본 저장. 한국요청자한테는 다음에 이 사본 보내줌.
- 10만명_ 데이터 계층 확장. 최종적으로는 DB도 쪼개질거다. 관계형 데이터베이스 시스템(PostgreSQL, MySQL등) 시스템에 캐시 계층 도입. 서비스가 동일한 정보에 대해 DB를 반복적으로 많이 호출할 때 캐시가 유용하다. DB를 다시 만질 필요 없어지면서 DB에 부하가 걸리지 않는다. select문 읽기전용 복제본.

![image-20230118155959790](https://github.com/choe-yujin/TIL/blob/master/07_Web/12_Django_Follow.assets/image-20230118155959790.png)





### 이미지

img 태그에 ./tree.jpg로 경로 지정하면

question_index.html의 url은 /polls/이니까

주소/polls/tree.jpg가 없습니다. 오류가 뜬다. 다이나믹웹이라.

그럼 어떻게?

polls안에 static폴더 만든다.

static폴더 안에 jpg를 넣는다.

url과 실제 static위치는 상관없음.

주소/static/tree.jpg 오류남

```django
{% load static %}

<img src="{% static 'tree.jpg' %}" alt="tree">
```



setting.py에

STATIC_URL = '/static/'으로 지정되어 있어서 자동으로 주소 뒤에 /static/ 붙은거임



base.html

css도 정적파일. static폴더 안에 css파일 하나 만들어서 html에서 연결해 쓰기

```django
{% load static %}

<link rel="stylesheet" href="{% static 'test.css' %}">
```

근데 static은 전역적으로 쓰는데 왜 polls 폴더 안에 있음?

바깥에도 static 폴더 만들어서 base.css 넣어도 됨.

근데 안 보여 왜?

setting.py에

`STATIC_URL = '/static/'`

`STATICFILES_DIRS = [BASE_DIR / 'static']`

BASE_DIR 추가해주면 static폴더 이름 붙은건 다 뒤짐.

![image-20230118174324209](https://github.com/choe-yujin/TIL/blob/master/07_Web/12_Django_Follow.assets/image-20230118174324209.png)

```django
<link rel="stylesheet" href="{% static 'css/base.css' %}">
```



## References

> 장고 빌트인 함수
>
> - https://docs.djangoproject.com/en/4.1/ref/templates/builtins/#linebreaksbr
>
> 10만명 접속 허용 서비스는 어떻게 구현되나?
>
> - https://brunch.co.kr/@jowlee/102
>
> - http://highscalability.com/blog/2016/1/11/a-beginners-guide-to-scaling-to-11-million-users-on-amazons.html

