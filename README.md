[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/E--3axVr)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=7224462&assignment_repo_type=AssignmentRepo)
# 단타충(단타도 타율이 충분하다면)

## 1. 프로젝트 소개

<img src="https://user-images.githubusercontent.com/28581806/170416113-b9819ba5-9f11-478a-85d9-009a1b6fac97.png" width="525
" height="150">

낮은 금리와 높은 물가 상승률로 재테크가 선택이 아닌 필수가 된 현대 사회에서, 주식에 많은 시간을 할애할 수 없는 투자자들에게 단기 투자는 쉽지 않은 투자 방법이다. 주식을 전업으로 하지 않는 이상 장 중에 이슈가 되고 있는 종목을 전부 파악하고, 그 종목들에 대한 정보를 구체적으로 알아보는 것은 현실적으로 불가능하기 때문이다. 본 프로젝트 ‘단타충’은 이러한 문제에 대해 실시간으로 주식 뉴스에 대해 정보를 제공하여 투자자의 수고를 덜어 줌으로써 해결하고자 한다.

## 활용 예시

| <img src="https://user-images.githubusercontent.com/28581806/170411480-aab2800d-aac5-4b55-8cc4-9bf8501f4c0c.png" width="200" height="400"> | <img src="https://user-images.githubusercontent.com/28581806/170411503-aa8f377c-1c74-4771-b531-4dec3168b7ba.png" width="200" height="400"> | <img src="https://user-images.githubusercontent.com/28581806/170411577-52633564-62e9-44bb-9885-aa3c915d7f7c.png" width="200" height="400"> | <img src="https://user-images.githubusercontent.com/28581806/170411613-3540ffe7-080f-4290-b5e9-3bfb3bf16b2e.jpeg" width="200" height="400"> |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |

1. 주요 주가 지수 및 주요 뉴스 제공
   - 코스피, 나스닥을 포함한 세계 주요 주가 지수 제공
   - 주요 뉴스 사진 및 제목 제공
2. 실시간 기사 순위 제공
   - 일일 기사 개수 많은 종목 순위 제공
   - 15분 당 호재/악재 기사 많은 종목 순위 제공
3. 종목 기본 정보 제공
   - 종목별 시가 총액, 전일 종가를 포함한 기본 정보 제공
   - 종목별 기사 제목, 호재/악재 판별 후 제공
4. 관심종목에 큰 주가 변동 발생시 알림 제공

---

## 2. Abstract

This project aims to build a system that notifies users of of stocks that are showing a lot of good or bad news that will lead to a surge in transaction volume in real time. Existing HTSs have the disadvantage that they can only be identified after a surge in trading volume or a large change in price. Therefore, there were many cases in which users who make short-term investments missed the hottest stocks during the market and missed the investment opportunity by figuring it out only after the trading volume decreased or the market was closed. ‘단타충’ can help users not miss stocks that are good for short-term investments in these cases.

---

## 3. 소개 영상

[![Watch the video](https://user-images.githubusercontent.com/28581806/161442821-7dbd3694-b471-443b-8118-818b9d9d9c47.png)](https://user-images.githubusercontent.com/28581806/161442682-b33a7657-eee8-4b15-8b76-6c33b7724f0d.mp4)

---

## 4. 시연 영상

[![Watch the video](https://user-images.githubusercontent.com/28581806/170411671-f7ae06b6-e4c8-4f7f-8243-9fad6071339e.png)](https://drive.google.com/file/d/1O1nWlP6z-H8DGvld5NZPiHMgUYmQrKTE/view?usp=sharing)

---

## 5. 시스템 구성도

<img src="https://user-images.githubusercontent.com/28581806/170411645-85e7aa95-317f-44c1-a416-8ce99e7aa64d.png" >

---

## 6. 팀 소개

**이범석(팀장)**

<img src="https://user-images.githubusercontent.com/28581806/157243525-8ec4b6ff-a358-4039-b176-43f854b53c8e.png" width="300" height="300">

```markdown
🐯 \*\*\*\*1664
📧 ijkoo16@kookmin.ac.kr
📌 Front-end, 모델 학습, Git 관리, Firebase 데이터베이스 구축
```

**이건민**

<img src = "https://user-images.githubusercontent.com/28581806/157243453-d16c9a94-9a85-4807-82bf-616ab19b36a0.png" width="300px" height="300px">

```markdown
🐮 \*\*\*\*1660
📧 Email: lkm9709@kookmin.ac.kr
📌 Front-end, UI/UX 디자인
```

**이승준**

<img src = "https://user-images.githubusercontent.com/28581806/157242024-c557b7e8-d1ab-499e-9f92-8f4e40aa4ff8.jpeg" width="300px" height="300px">

```markdown
🐯 \*\*\*\*1667
📧 Email: juns519@kookmin.ac.kr
📌 모델 학습, 크롤링 모델 구축
```

**이원형**

<img src = "https://user-images.githubusercontent.com/28581806/157245315-08383b96-17d7-4d6b-a057-2e75c6ddb1e5.jpeg" width="300px" height="300px">

```markdown
🐭 \*\*\*\*1672
📧 Email: hyeong3642@kookmin.ac.kr
📌 모델 학습, 데이터셋 구축
```

---

## 7. 사용법

### 안드로이드 앱 실행 환경설정 가이드

##### step 1:

VScode를 설치하세요:

```markdown
https://code.visualstudio.com/
```

##### step 2:

Flutter SDK를 설치하세요:

```markdown
https://flutter-ko.dev/docs/get-started/install

- 자신에게 맞는 운영 체제를 선택 후 Guide 진행
- Web setup은 진행할 필요 없음

https://flutter-ko.dev/docs/development/tools/sdk/releases

- SDK version 2.10.3 설치 권장
```

##### step 3:

설치 확인을 위하여 다음 명령을 실행하세요:

```markdown
Flutter Sdk PATH 내 flutter_console.bat 실행

1. flutter doctor -v
2. flutter doctor --android-licenses
```

##### step 4:

아래 링크를 사용하여 이 저장소를 다운로드하거나 복제하세요:

```markdown
https://github.com/kookmin-sw/capstone-2022-07.git
```

##### step 5:

프로젝트 루트로 이동하고 콘솔에서 다음 명령을 실행하여 필요한 패키지를 가져오세요:

```markdown
flutter pub get
```

##### step 6:

프로젝트를 실행하세요:

```markdown
flutter run
```

---

### ios 앱 실행 환경설정 가이드

##### step 1:

VScode를 설치하세요:

```markdown
https://code.visualstudio.com/
```

##### step 2:

Xcode를 설치하세요:

```markdown
앱스토어에서 xcode 설치
```

##### step 3:

cocoapod를 설치하세요:

```markdown
$ sudo gem install cocoapods
```

##### step 4:

Flutter SDK를 설치하세요:

```markdown
https://flutter.dev/docs/development/tools/sdk/releases

- SDK version 2.10.3 설치 권장
```

##### step 5:

Flutter 환경변수설정

```markdown
https://flutter-ko.dev/docs/get-started/install/macos
본인의 운영체제 버전에 따라 환경변수 설정하는 법이 다르므로 공식문서 활용하여 설정
```

##### step 6:

설치 확인을 위하여 다음 명령을 실행

```markdown
1. terminal open
2. flutter --doctor
   (flutter —doctor 실행시 본인의 환경에서 플러터 코드 실행을 할수 있는지 확인가능)
```

##### step 7:

아래 링크를 사용하여 이 저장소를 다운로드하거나 복제하세요:

```markdown
https://github.com/kookmin-sw/capstone-2022-07.git
```

##### step 8:

프로젝트 루트로 이동하고 콘솔에서 다음 명령을 실행하여 필요한 패키지를 가져오고, cd ios를 통해 ios폴더에서 필요한 라이브러리들을 추가 설치해주세요:

```markdown
flutter pub get
cd ios
pod install
```

##### step 9:

프로젝트를 실행하세요:

```markdown
flutter run
```

---
