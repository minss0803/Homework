# Homework

## 개발 환경
- minVersion : iOS 10
- targetVersion : iOS 13
- Swift 5
- Xcode 11
- CocoaPods

## 실행 방법
```
1. git clone https://github.com/minss0803/Homework.git
2. pod install
3. open Homework.xcworkspace
4. Run the application
```

## 구현 방법
- Swift 및 그 외 Dependency를 사용했습니다.
- MVP 패턴으로 구현하였습니다.

## 작업 목표
- [x] 메인화면 목록 API 연동
- [x] 필터 UI 구현
- [x] 필터 Floating UI/UX 적용
- [x] 상세화면 전환 Transition 구현
- [x] 이미지 pinch zoom/out 구현
- [ ] 리스트 하단에 도달하면 자동으로 같은 데이터를(Page를 변화하지 않고) 조회하여 콘텐츠를 아래로 추가
- [ ] 필터 선택 시, API 재호출

## 외부 라이브러리

### Image + Animation + UI
- Kingfisher : 이미지캐시 로딩 라이브러리
- SnapKit : `오토레이아웃`을 코드로 구현하는데 사용

### Other Swift Utilities
- Then

