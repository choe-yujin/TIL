# Django_Auth

23년 1월 23일(금)



## 개요

회원가입 **Auth**orization 권한을 새롭게 준다. 

로그인 **Auth**entication 인증한다.



회원가입 : DB에 create

로그인 : 팔찌 채우기



### HTTP 메시지 개념

로그인한 상태라는 건 존재하지 않는다.

HTTP 에서는

Stateless 상태도 없고

Connectionless 연결도 없다



서버 클라이언트

요청 응답

URL HTML

이 사이클이 한번 돌고나면 기본적으로는 통신이 끊어진다.

사이클간의 기억이라는 것은 없다. 기억을 한다. == 커넥션이 있다.

ex)

문지기 가드가 서버라고 한다면 문지기는 개개인을 기억하고 있는 것이 아니다. 팔찌를 보는 것 뿐.

서버가 로그인을 인지하는 것은 팔목의 팔찌.

클라이언트가 팔찌를 차고 있다. == 쿠키

**쿠키 확인해보기**

[F12] - 애플리케이션 - 쿠키 - 로그인 하면 user_session이 생김 !



로그인을 한다. 클라이언트에게 팔찌를 채워준다.

팔찌에 뭐라고 써주는게 맞을까?

사용자가 누군지 구분해야 하는데pk 값을 그대로 넣으면 문제가 있다. 왜? 누가 바꿀 수 있으니까.

{'session_key' : 'sdjglksdjlg', 'session_data' : 'agjioweogj'} session_data를 디코딩하면 pk가 나온다. 이중 보안



### 쿠키? 세션

쿠키를 어디에 쓸 수 있을까? 

1.세션관리

2.개인화(테마 세팅)

3.트래킹(사용자 행동 기록 분석)



세션과 쿠키의 의미는 다름

쿠키로는 민감한 정보에 넣으면 안되겠다. 어떻게 숨기지? 서버 데이터베이스 어딘가에 넣어두고 여기엔 암호화된 어떤걸 주고 이 암호화된걸 받아서 테이블 보고 디코드해서 어떤 사람인지 알아내는게 세션이다.



쿠키와 세션의 목적은 사용자에게 무언가를 박아놓고 여러번 묻지 말자는거.

쿠키는 클라이언트에게 있고, (추적. 헨젤과 그레텔. 그래서 쿠키임)

세션 데이터는 서버에게 있다.



쿠키는 자동으로 모든 요청에 섞여서 날라간다.

어디에 쓰겠냐? 어떻게 빅테크 회사들이 나를 나보다 더 잘 알고 있냐? 

회원가입 안해도 클라이언트가 요청 보낼때마다 섞여 날라간 쿠키로 행동패턴 분석이 가능하다.



## 회원 accounts앱

### Model

장고에 auth_user 테이블이 이미 있다.

왜 장고가 이렇게까지 편의성을 제공할까?

장고의 슬로건 : The web framework for perfectionists with deadlines.

신문사의 웹 서비스에서부터 출발. 기자들을 위함. (국장 편집장 권한)



모델은 이미 세팅되어 있으니 url과 views와 templates만

python manage.py startapp accounts 세팅즈에서 accounts 출생신고

`cd accounts` `touch urls.py` `forms.py` `mkdir -p templates/accounts`

`cd templates/accounts/` `touch login.html signup.html`



### urls.py 

path설정

```python
# accounts/signup/
path('signup/', views.signup, name='signup'),
# accounts/login/
path('login/', views.login, name='login'),
# accounts/logout/
path('logout/', views.logout, name='logout'),
```

하나의 url로 get, post 분기되게 view함수 만들어놨으니 html form함수의 action url은 비운다.



### views.py(회원가입)

model도 미리 만들어져 있듯이 form모델도 미리 만들어져 있으니 import만 하면 됨

- **회원가입** `from django.contrib.auth.forms import UserCreationForm`

```python
@require_http_methods(['GET', 'POST'])
def signup(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()  # 팔찌 채워주려고 user로 빼놓음
            auth_login(request, user)  # 팔찌 채워 로그인
            return redirect('board:article_index')
    else:
        form = UserCreationForm()
    context = {'form': form, }
    return render(request, 'accounts/signup.html', context)
```



### views.py(로그인)

비밀번호 암호화한 값과 비교 대조하는 작업

- **로그인** `from django.contrib.auth.forms import AuthenticationForm`

```python
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login as auth_login
# 내가 만든 login함수와 import함수 이름 같으니 auth_login이라고 명명해줌

@require_http_methods(['GET', 'POST'])
def login(request):  
    if request.method == 'POST':
        form = AuthenticationForm(request, request.POST)
        # save()용 form이 아니다.
        if form.is_valid():  ## 응 맞아
            user = form.get_user()  # 맞는데 누구야
            auth_login(request, user)  # 팔찌 채워줌
            return redirect('board:article_index')
    else:
        form = AuthenticationForm()
    context = {'form' : form, }
    return render(request, 'accounts/login.html', context)
===============================================================
@require_http_methods(['GET', 'POST'])
def login(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, request.POST)
        # save()용 폼이 아니다
        if form.is_valid():  # 응 맞아
            user = form.get_user()  # 맞는데, 그게 누구야
            auth_login(request, user)  # 팔찌 채워줌
            # None / URL string
            next = request.GET.get('next')
            return redirect(next or 'board:article_list')
    else:
        form = AuthenticationForm()
    context = {'form' : form, }
    return render(request, 'accounts/login.html', context)
```

AuthenticationForm은 다른 form과 인자 구성이 다르다.



회원인지 아닌지에 따라 UI가 바뀌고 어떤 회원인지에 따라 접근 권한이 달라져야 함

`request.GET['next']` 은 key 없을 경우 에러남

`request.GET.get('next')` 에러 안 내고 none 리턴하는 것을 응용

`return redirect(next or 'board:article_list')`

​	next가 none이면 board:article_list가 튀어나오고

​	next가 값이 있으면 next로 튀어나온다.



​	or은 연산자니까 평가가 될거임

​	a or b는 a로 평가받는다. 0 or a 는 a 로 평가 받는다.



### views.py(로그아웃)

```py
from django.contrib.auth import logout as auth_logout

def logout(request):
    auth_logout(request)
    return redirect('board:article_index')
```





### 로그인 상황에 따라 분기

이중 방어

- **1) UI 메뉴를 분기해서 보여주기** 

`request.user` 로그인 안하면 `AnonymousUser`

`.is_authenticated` 요청 보낸 사용자가 인증 되었느냐

- **2) views.py에서 URL 진입 막기**

매 함수마다 `if request.user.is_authenticated()` 조건으로 거를 것이냐? 

No! 너무 반복된다.

```python
from django.contrib.auth.decorators import login_required
@login_required 로그인 필요한 함수에 데코레이션 해주기
```



request.GET는 url문자열이라고 보면된다.

- 로그인 원해서 로그인하러 온 사람에게는 request.GET에 next키가 없다.

- 로그인도 안 하고 url로 create하러 온 사람은 request.GET에 `?next=`  있음.

​		`@login_required`로 튕겨서 로그인 페이지로 이동하게 하자. 

`http://127.0.0.1:8000/accounts/login/?next=/articles/create/`

일단 로그인부터 하러 가 / ?next= 원래 가려고 했던 곳도 말해줄게. 



---

### Model에 USER 컬럼 만들기

우리가 만든 게시판과 댓글엔 글쓴이가 없다.

각각 모델에 글쓴이 컬럼 추가.(하고 이전에 만든 model은 삭제하고 다시 migrate)



#### board의 models.py 

- 컬럼 추가하는 안 좋은 방법

```python
from django.contrib.auth import get_user_model

User = get_user_model()
```

- 장고가 권장하는 방법

```python
from django.conf import settings # import해오는 settings는 setting파일에는 안 들어있는 변수가 더 많다.

class Article(models.Model):
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    ) # settings.AUTH_USER_MODEL의 값
```



#### 없던 칼럼이 생겼으니까 이전 DB 내용은 다 밀어버리기

```bash
rm db.sqlite3 board/migrations/0*
# board/migrations폴더 안에 0으로 시작하는 파일들 다 지워줘
python manage.py makemigrations
python manage.py migrate
```



#### board-forms.py

```python
class ArticleForm(forms.ModelForm):
    
    class Meta:
        model = Article
        #fields = '__all__'
        exclude = ('user', ) # 튜플이니까 꼭 , 찍기!
```



#### board-views.py 에 user 저장하자

```python
@login_required
@require_http_methods(['GET', 'POST'])
def create_article(request):
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            article = form.save()
            return redirect('board:article_detail', article.pk)
    else:
        form = ArticleForm()
    context = {'form':form}
    return render(request, 'board/form.html', context)

=================================================
@login_required
@require_http_methods(['GET', 'POST'])
def create_article(request):
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            article = form.save(commit=False)
            article.user = request.user
            article.save()
            return redirect('board:article_detail', article.pk)
    else:
        form = ArticleForm()
    context = {'form':form}
    return render(request, 'board/form.html', context)
```

commit=False 잠시만요 아직 저장 ㄴㄴ

request.user를 article.user컬럼에 넣고 저장할게요~





### UI form 커스터마이징

**Q. {{form}}이 input태그 보여주는거 알아서 담당하고 있는데 html auto포커스 어캐 함?**

 board-forms.py에서 widget 커스터마이징 해야 함

```python
class CommentForm(forms.ModelForm):
    content = forms.CharField(
        min_length=2, max_length=200,
        widget=forms.TextInput(attrs={'autofocus':True})
    )
    class Meta:
        model = Comment
        # fields = '__all__'
        exclude = ('article', 'user',)
```



---

### 글 수정 update_article

POST방식으로 form 제출해서 오류났음-> DB전송하는게 아니라 걍 수정 페이지만 보여줘야하니까 a태그로 url연결하기(GET)

```python
@require_http_methods(['GET', 'POST'])
def update_article(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    if request.method == 'POST':
        form = ArticleForm(request.POST, instance=article)
        if form.is_valid():
            article = form.save()
            return redirect('board:article_detail', article.pk)
    else:
        form = ArticleForm(instance=article)
    context = {'form':form}
    return render(request, 'board/form.html', context)
```



### 글 삭제 delete_article

```python
@require_POST
def delete_article(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    if request.user == article.user:
        article.delete()
    return redirect('board:article_index')
```



질문

- 브라우저 창을 닫았다가 다시 켰는데 로그인 상태 지속되어있네.  브라우저창 닫으면 없어지게는 어떻게 하지? -> 브라우저마다 다름. 크롬은 지원 안 됨.

- 회원가입은 UserCreationForm이고 회원 확인은 AuthenticationForm 인데 회원삭제할때는 무슨 모델에서 지워야 돼? -> request.user.delete()로 바로 메소드로 삭제할 수 있음. 



### Auth 관련 라이브러리

| 기능        | from                             | import                     | 사용법                                                       |
| ----------- | -------------------------------- | -------------------------- | ------------------------------------------------------------ |
| 회원가입    | `django.contrib.auth.forms`      | `UserCreationForm`         | `form = UserCreationForm(request.POST)`유효성검사 후 `user = form.save()` `auth_login(request, user)` |
| 로그인      | `django.contrib.auth.forms`      | `AuthenticationForm`       | `form = AuthenticationForm(request, request.POST)`유효성검사 후 `user=form.get_user()` |
| 회원수정    | `.forms`                         | `CustomUserChangeForm`     | `form = CustomUserChangeForm(request.POST, instance=request.user)` 유효성 검사 후 `user = form.save()` |
| 비번변경    | `django.contrib.auth.forms`      | `PasswordChangeForm`       | `form = PasswordChangeForm(request.user, request.POST)` 유효성 검사 후 `user = form.save()` |
| 회원삭제    | X                                | X                          | `if request.user.is_authenticated: request.user.delete()`    |
| 로그인 필수 | `django.contrib.auth.decorators` | `login_required`           | `@login_required`                                            |
| 로그인      | `django.contrib.auth`            | `login as auth_login`      | `auth_login(request, user)`                                  |
| 로그아웃    | `django.contrib.auth`            | `logout as auth_logout`    | `auth_logout(request)`                                       |
| 프로필      | `django.contrib.auth `           | `get_user_model`           | `User = get_user_model()` `profile_user = get_object_or_404(User, username=username)` |
| 비번        | `django.contrib.auth `           | `update_session_auth_hash` | `update_session_auth_hash(request, request.user)`            |







## References

> HTTP 쿠키 네트워크 개념 https://developer.mozilla.org/ko/docs/Web/HTTP/Cookies
>
> 장고 USER 커스터마이즈 http://docs.djangoproject.com/en/4.1/topics/auth/customizing/
