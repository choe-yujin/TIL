# Django_variable routing

23년 1월 5일(목)

## URL 변수 처리 : Variable Routing

`'url/<변수명>'`

```django
# urls.py
path('hello/<name>', views.hello, name='hello')

#views.py
def hello(request, name):
    name = {'name':name}
    return render(request, 'data/hello.html', name)

#hello.html
{% include 'base.html' %}
{% block content %}
{{name}}
{% endblock content%}
```



## 데이터 전송

사용자 input 데이터를 받아보는 방법

1. GET : URL에 공개
2. POST : URL에 비공개.  django의`MIDDLEWARE`가 기초 보안 처리 해줌 

```django
#user_input.html
{% include 'base.html' %}
{% block content %}
<form action="{% url 'data:user_output'%}" method="POST">
    {% csrf_token %}
    <input type="text" name="userid">
    <input type="submit">
</form>
{% endblock content%}
```

**주의! form의 POST방식으로 데이터 보내려면 csrf 토큰이 있어야 한다!** 

csrf 탭 하면 {% csrf_token %} 생김 

`<input type="hidden" name="csrfmiddlewaretoken" value="~~~"> `가 생긴다.

서버측에서 POST방식으로 데이터 보내려면 token도 같이 내놔 하는 것임. 



## 받아온 데이터를 꺼내보기

```python
def user_output(request):
	request.POST  # QueryDict: {'csrftoken':['asgsa'],'userid':['aaa'],'userpw':['bbb']}
	return render(request, 'data/user_output')
```

`request.POST` 혹은 `request.GET`

사용자 pw 개인정보를 서버가 갖고 있으면 위험부담. 그래서 요즘은 auth 카카오, 구글 로그인 많이 함.

직접 서버에 저장하는 형식이라면 요즘은 pw를 암호화해서 저장함.

**주의! input type이 int라도 request객체의 값은 str으로 저장되므로 형변환 해줘야**

http -> https