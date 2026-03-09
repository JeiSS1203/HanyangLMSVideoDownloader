# HanyangLMSVideoDownloader (Chrome Extension)
한양대학교 LMS의 강의 영상을 다운로드할 수 있는 확장프로그램입니다.
<p align="left">
<img src="https://github.com/user-attachments/assets/2a3ad795-b889-42a9-9c08-d83904c4c055">
</p>
+ _본 크롬 확장 프로그램은 개인정보를 수집하지 않습니다._
+ _다운로드 기능을 제공하기 위해 LMS API에 사용되는 쿠키 정보 등을 사용합니다._

## 소개
[한양대학교 LMS](https://learning.hanyang.ac.kr/)의 영상들을 다운 받아주는 크롬 확장 프로그램입니다.


## 사용 방법
### Installation


1. 초록색 **<  > Code** 버튼 클릭

   <img src="https://github.com/user-attachments/assets/3d22c14c-e0ae-468e-8391-269215683470" wigth="30" height="30"/>


2. **Download ZIP** 클릭 
   
   <img src="https://github.com/user-attachments/assets/dfd5ad7a-7df2-465c-9490-ab8beefae4a1" wigth="20" height="20"/> 

3. 다운로드 폴더에 저장된 압축파일을 압축 해제한다.
4. 크롬 주소창에 chrome://extensions 로 들어간다.
5. 오른쪽 상단 **개발자 모드**를 그림과 같이 켜준다.

   <img src="https://github.com/user-attachments/assets/107fba6d-2de7-4804-94eb-69ab9bfe84e1" wigth="17" height="17"/>

6. 왼쪽 상단의 **압축해제된 확장 프로그램 로드**를 누르고, 다운로드 폴더의 HanyangLMSVideoDownloader\**chrome-extension** 폴더를 선택해준다. 
   
   <img src="https://github.com/user-attachments/assets/74aa972a-6b58-48f8-8589-eedba7076a48" wigth="300" height="300"/>
7. 왼쪽 아래의 **확장 프로그램 로드됨**과 함께 확장 프로그램이 다음과 같이 보인다면 확장 프로그램 설치 성공입니다.
   이후 **확장 프로그램의 ID**를 복사해주세요.
   
   <img src="https://github.com/user-attachments/assets/b24c63a8-c53e-452f-aee0-77ebd2127a5c" wigth="200" height="200"/>
8. 압축 해제한 폴더 내부 native_app 폴더의 install_and_register.bat을 관리자 권한으로 실행한 후, **복사한 ID**를 붙여넣기합니다. (대체로 아래 경로에 있습니다. 경로를 그대로 복사해서 쓰셔도 가능합니다.)
~~~
%UserProfile%\Downloads\HanyangLMSVideoDownloader\native_app\install_and_register.bat
~~~
9. LMS에 접속해서 다운받고자 하는 영상을 **실행**시켜주기만 하면 다운로드 폴더에 **_screen.mp4_** 라는 이름으로 영상이 저장됩니다.

## 주의사항
+ 영상은 **_screen.mp4_** 라는 이름으로 계속 **덮어씌우기 때문에** 여러 영상을 내려받고자 하신다면, 반드시 하나의 영상을 내려받은 뒤에 **이름을 바꿔주시기 바랍니다**. 
+ 영상 다운로드가 되지 않는 것 같다면 **새로고침** 해주시면 대체로 해결됩니다.
+ 영상이 다운로드되는데 시간이 걸립니다. 다운로그 완료 알림이 나오지는 않으나, 영상의 용량이 변함을 보고 다운로드가 완료되었음을 알 수 있습니다. 
+ 다운로드된 영상을 눌렀을 때, 재생되지 않는다면 다운로드가 완료되지 않았을 가능성이 높으니, 약 1분 정도의 시간을 기다려주시면 다운로드가 완료됩니다. (영상의 길이에 따라 다운로드 시간은 다를 수 있습니다.)
