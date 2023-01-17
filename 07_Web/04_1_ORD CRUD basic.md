# CRUD

```python
from board.models import Article
## Create(생성)
# 1.
article = Article()
article.title = '첫번째 글'
article.content = '와 내가 처음이야'
article.author = '나'
article.save()

# 2.
article = Article(title='2번글', content='까비', author='너')
article.save()

# 3
Article.objects.create(title='3번글', content='까까비', author='우리')


## Read / Retrieve (조회)
# 단일 조회
article = Article.objects.get(id=1)
article = Article.objects.get(pk=1)
article.id ; article.pk
article.content
article.author

# 전체 조회
articles = Article.objects.all()
for article in articles:
    print(article.title)


## Update (수정)

article = Article.objects.get(id=3)  # 먼저 수정할 게시글을 고르고,
article.title = '수정한 글'
article.content = '바뀌어라얍'
article.save()


# Delete / Destroy (삭제)
article = Article.objects.get(id=10)
article.delete()




article = Article.objects.get(id=10)

article.delete()

article.save()
```

