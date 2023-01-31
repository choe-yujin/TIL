# 데이터분석 개요 및 numpy

23년 1월 25일(수)



## 공부 순서

1단계 기초통계학 & R 자료구조

2단계 EDA 및 시각화 & 회귀모델링

3단계 Basic Review & Numpy, Pandas

4단계 Concept of ML

5단계 Code 구현 & Team Project(R or Python)

---

기초통계학 -> 정형 데이터 머신러닝 알고리즘(지도학습 vs 비지도학습) -> 비정형(텍스트, 이미지)딥러닝 알고리즘

---

1. IT Skill
2. Math & Statics
3. Domain Knowledge :: 배경지식-금융,제조,유통...



## 데이터 분석 수행 단계

Data Select, Collect -> preprocessing(전처리) -> transform(변환) -> modeling -> evaluation(평가. 의사결정에 적용)

1. Data Engineer

Data Select, Collect -> preprocessing(전처리) 

:: 1TB = 10GB * 10대 (하둡 에코시스템_데이터 분산, 병렬 처리)

CPU가 데이터를 한번에 처리 못할 때 여러 컴퓨터로 분산. 데이터를 수리적으로 분산하는 것에 관심 있는 경우

2. **Data Architecture**

(데이터프레임 :: 열 내의 데이터는 같고, 열 간의 데이터는 다르다.)

데이터베이스를 연결 (DAsP, DAP)

3. 데이터 호출 (sqld, sqlp)

4. 데이터 분석가

데이터 모델을 평가 (ADsP, 빅데이터 분석 기사, ADP)

(기업에서 데이터 분석팀은 전략기획실, 시나리오팀에 속해있는 경우가 많다.)



## 세팅

- 아나콘다3 설치 - All users로 - 쥬피터 노트북 추가 

- 쥬피터노트 시작 경로 설정[jupyter notebook --generate-config](https://code-code.tistory.com/20)
  - Jupyter notebook 파일위치-속성-시작위치와 대상의 userprofile지우기

- [kaggle](https://www.kaggle.com/)가입



## 콘다 명령어

| 명령어                                                       | 설명                                       | 예시                                                         |
| ------------------------------------------------------------ | ------------------------------------------ | ------------------------------------------------------------ |
| **conda env list**                                           | 가상환경 목록 보기                         |                                                              |
| **conda create -n <가상환경이름> python=<버젼>**             | 가상환경 생성                              | conda create -n TestEnv python=3.74                          |
| **conda env remove -n <가상환경이름>**                       | 가상환경 삭제                              |                                                              |
| **conda activate <가상환경이름>**                            | 가상환경 실행                              |                                                              |
| **conda deactivate**                                         | 가상환경 종료                              |                                                              |
| **conda list**                                               | 현재 가상환경에서 설치되어있는 패키지 보기 |                                                              |
| **conda install <패키지 이름>**                              | 현재 가상환경에서 패키지 설치              | ex1) conda install numpy ex2) conda install numpy pandas ex3) conda install tensorflow-gpu==1.13.1 |
| **conda uninstall <패키지 이름>**                            | 현재 가상환경에서 패키지 삭제              |                                                              |
| **conda create --name <복사하여 생성할 가상환경명> --clone <복사할 가상환경명> ** | 복사할 가상환경을 가지고 가상환경 생성     | ex) conda create --name NewProject --clone OldProject : OldProject를 복사하여 NewProject로 생성함 |
| **python --version**                                         | 파이썬 버전 확인                           |                                                              |
| **nvidia-smi**                                               | 드라이버 정보 표시 (+ CUDA 버전 표시)      |                                                              |



## conda venv

각각 파이썬 여러 버젼으로 개발하는 경우에 대비하기 위해 가상환경 만들기

가상환경 리스트 조회`conda env list`

가상환경 생성 `conda create -n <가상환경이름> python=3.10` y

가상환경 실행 `conda activate <가상환경이름>` `conda deactivate`

가상환경 내에 쥬피터 노트북 설치`conda install jupyter notebook` y



---



## numpy실습

### numpy로 array 생성

```python
import numpy as np
list1 = [1,2,3]
list2 = [4,5,6]
# list1 + list2 = [1, 2, 3, 4, 5, 6]

array1 = np.array([1,2,3])
array2 = np.array([4,5,6])
# array1 + array2 = [5 7 9]
```



### 함수 용례 검색 방법(?와 help)

```python
# ?를 활용한 함수 검색
?numpy.array
?numpy.ndim
?numpy.shape
# help를 통한 함수 검색
help(numpy.ndim)
```



### ndarray 편리하게 생성하기

```python
# ndarray 편리하게 생성 - arange, zeros, ones
# 1)arange
a1 = np.array([1,2,3,4,5]) # array([1,2,3,4,5])
np.arange(start=1, stop=6) # array([1,2,3,4,5])
np.arange(1, 6) # array([1,2,3,4,5])
seq_array = np.arange(1, 11)
print(seq_array.dtype) # int32

# 2)zeros
zero_array = np.zeros((2,4), dtype='int32')
#[[0 0 0 0]
# [0 0 0 0]]

# 3)ones
# ones로 1로 된 행렬을 생성
one_array = np.ones((3,2), dtype='float64')
# [[1. 1.]
# [1. 1.]
# [1. 1.]]
# type은 numpy.ndarray
```

**Q.결측값이 뭐냐?** 

ragged nested sequences (different lengths or shapes)

ex)

1차원 데이터 (1 X 3)

2차원 데이터 (3 X 1)

=> (1x3) x (3x1) = 1차원(1X1).

[1,2,3]

[4,

5,

6]

(1x4) + (2x5) + (3x6) = [4 10 18] 32



### 데이터 reshape

```python
# reshape의 용례
arr_test = np.arange(start=1, stop=11)  # [ 1  2  3  4  5  6  7  8  9 10]
arr_test.reshape(2,5)  # [[ 1  2  3  4  5] [ 6  7  8  9 10]]
```



### numpy의 dtype

```python
l2 = [1,2,'test']  # int와 str
# np.array를 활용하여 ndarray로 변환
np.array(l2)  # unicode11 문자를 의미
```

**numpy는 서로 다른 종류의 데이터가 못 온다!** Numpy의 데이터 타입은 다 같은 타입으로 구성된다.

Q.numpy차원과 표의 차원이 호환 가능한가? 그렇다.



### numpy의 형변환. astype

```python
# Numpy 형변환
# dtype의 상호 변환
array_int = np.array([1,3,5])

# int to float
array_float = array_int.astype('float64')

# array_float -> array_int2
array_int2 = array_float.astype('int32')

# 자료에 따른 버림 현상
array_float2 = np.array([1.1, 2.2, 3.6])
array_int3 = array_float2.astype('int32') # 1 2 3
```





Tip! `%autosave 0` 자동저장 꺼짐 `%autosave 100` 100초마다 자동저장

