[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=7224462&assignment_repo_type=AssignmentRepo)

# 단타충(단타도 타율이 충분하다면)

## 1. 프로젝트 소개

본 프로젝트는 거래량 급등으로 이어질 호재 혹은 악재가 많이 나오고 있는 종목을 실시간으로 사용자에게 알려주는 시스템을 구축하고자 한다. 기존 HTS들은 거래량이 급등하거나 가격에 큰 폭의 변화가 있고 나서야 파악을 할 수 있는 단점이 있다. 그래서 단기투자를 주로 하고 있지만 장 중에 핫한 종목들을 놓치고, 거래량이 감소하거나 장이 종료되고 나서야 이를 파악하여 투자의 기회를 놓치는 경우가 많다. 단타충은 이러한 경우에 사용자가 단기투자에 좋은 종목을 놓치지 않도록 도움을 줄 수 있다.

---

## 2. Abstract

This project aims to build a system that notifies users of of stocks that are showing a lot of good or bad news that will lead to a surge in transaction volume in real time. Existing HTSs have the disadvantage that they can only be identified after a surge in trading volume or a large change in price. Therefore, there were many cases in which users who make short-term investments missed the hottest stocks during the market and missed the investment opportunity by figuring it out only after the trading volume decreased or the market was closed. ‘단타충’ can help users not miss stocks that are good for short-term investments in these cases.

---

## 3. 소개 영상

개발 후 추가 예정

---

## 4. 팀 소개

**이범석(팀장)**

<img src="https://user-images.githubusercontent.com/28581806/157243525-8ec4b6ff-a358-4039-b176-43f854b53c8e.png" width="300" height="300">

```markdown
🐯 \*\*\*\*1664
📧 ijkoo16@kookmin.ac.kr
📌 UI/UX 디자인, 크롤링 모델 구현
```

**이건민**

<img src = "https://user-images.githubusercontent.com/28581806/157243453-d16c9a94-9a85-4807-82bf-616ab19b36a0.png" width="300px" height="300px">

```markdown
🐮 \*\*\*\*1660
📧 Email: lkm9709@kookmin.ac.kr
📌
```

**이승준**

<img src = "https://user-images.githubusercontent.com/28581806/157242024-c557b7e8-d1ab-499e-9f92-8f4e40aa4ff8.jpeg" width="300px" height="300px">

```markdown
🐯 \*\*\*\*1667
📧 Email: juns519@kookmin.ac.kr
📌
```

**이원형**

```
<img src = "https://user-images.githubusercontent.com/28581806/157245315-08383b96-17d7-4d6b-a057-2e75c6ddb1e5.jpeg" width="300px" height="300px">

```markdown
🐭 \*\*\*\*1672
📧 Email: hyeong3642@kookmin.ac.kr
📌
```

---

## 5. 사용법

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

- 최신 SDK version 설치 권장
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
앱스토어에서 xcode 설치 or

1. http://developer.apple.com/download/more (Apple ID 로그인)
2. 다운받을 Xcode 버전 검색
3. Xcode xip 압축파일 다운로드
4. 다운받은 xip 파일 실행
5. 압축이 해제된 Xcode 파일 응용프로그램 폴더로 복사
6. Xcode 실행
```

##### step 3:

cocoapod를 설치하세요:

```markdown
$ sudo gem install cocoapods
```

##### step 4:

iOS simulator 설정

```markdown
스팟라이트 단축키인 control + space 키를 이용하여 스팟라이트를 실행한다음 iOS 만 치면 최상단에 iOS Simulator 앱이 뜨게 됩니다.
원하는 시뮬레이터 설정.
```

##### step 5:

Flutter SDK를 설치하세요:

```markdown
https://flutter.dev/docs/development/tools/sdk/releases

- 최신 SDK version 설치 권장
```

##### step 6:

Flutter 환경변수설정

```markdown
https://flutter-ko.dev/docs/get-started/install/macos
본인의 운영체제 버전에 따라 환경변수 설정하는 법이 다르므로 공식문서 활용하여 설정
```

##### step 7:

설치 확인을 위하여 다음 명령을 실행

```markdown
1. terminal open
2. flutter --doctor
   (flutter —doctor 실행시 본인의 환경에서 플러터 코드 실행을 할수 있는지 확인가능)
```

##### step 7-1:

flutter doctor 실행후 나오는 아래와 같은 에러는 ios앱 빌드시에는 무시
이외에 에러 발생시에 flutter doctor가 어떤 것을 해야하는지 상세히 보여주니 따라서 진행할 것.

```markdown
Android toolchain - develop for Android devices
✗ Unable to locate Android SDK.
Install Android Studio from:
https://developer.android.com/studio/index.html
On first launch it will assist you in installing the Android SDK
components.
(or visit https://flutter.dev/docs/get-started/install/macos#android-setup
for detailed instructions).
If the Android SDK has been installed to a custom location, please use
`flutter config --android-sdk` to update to that location.
```

##### step 8:

아래 링크를 사용하여 이 저장소를 다운로드하거나 복제하세요:

```markdown
https://github.com/kookmin-sw/capstone-2022-07.git
```

##### step 9:

프로젝트 루트로 이동하고 콘솔에서 다음 명령을 실행하여 필요한 패키지를 가져오고, cd ios를 통해 ios폴더에서 필요한 라이브러리들을 추가 설치해주세요:

```markdown
flutter pub get
cd ios
pod install
```

##### step 10:

프로젝트를 실행하세요:

```markdown
flutter run
```

---

## 6. 기타

추가적인 내용은 자유롭게 작성하세요.
