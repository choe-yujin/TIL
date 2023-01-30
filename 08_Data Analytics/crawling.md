# 크롤링 실습

- 아나콘다 가상환경 구축

- 가상환경 폴더 있는 폴더에 chromedriver 넣기 

​	https://chromedriver.chromium.org/downloads 

- 크롬 정보 버전 확인 후 같은 버전의 드라이브 다운
- win32.zip파일 다운 후 압축 풀기
- 아나콘다 프롬프트창에서
  - (가상환경 폴더 만들어 conda activate <가상환경명>)
  - conda install selenium
    \# jupyter 안 나올 시
    pip install jupyter notebook
- getting started selenium 검색 https://selenium-python.readthedocs.io/getting-started.html

>  If you have installed Selenium Python bindings, you can start using it from Python like this.

```python
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("http://www.python.org")
```

Chrome드라이버로 연 파이썬 창에서 [F12] 모바일 아이콘 왼쪽 마우스 버튼 클릭

검색창 클릭시 <input id="id-search-field" name="q">로 간다.

이 name

`elem = driver.find_element_by_name('q')`  이 q를 여기에 넣기

```python
elem = driver.find_element(By.NAME, 'q')
elem.clear()  #검색창의 내용 제거
elem.send_keys('numpy')  # 검색어
elem.send_keys(Keys.RETURN)  # 엔터
# assert "No results found." not in driver.page_source
# driver.close()
```

구글 그림 가져오기





스크롤 해서 나올때까지 크롤링하기.

```python
SCROLL_PAUSE_TIME = 0.5

# Get scroll height
last_height = driver.execute_script("return document.body.scrollHeight")

while True:
    # Scroll down to bottom
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    # Wait to load page
    time.sleep(SCROLL_PAUSE_TIME)

    # Calculate new scroll height and compare with last scroll height
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height
```

지금은 class로 가져와서 예외처리를 위해 try except 추가했다. XPath 는 고유하다.







## Reference

> 스크롤 코드 https://stackoverflow.com/questions/20986631/how-can-i-scroll-a-web-page-using-selenium-webdriver-in-python