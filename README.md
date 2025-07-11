# BookSearchApp

iOS 도서 검색 및 즐겨찾기 관리 애플리케이션

## 📖 프로젝트 소개

이 프로젝트는 카카오 도서 검색 API를 활용하여 도서를 검색하고, 검색된 도서를 즐겨찾기에 추가하여 로컬에서 관리할 수 있는 iOS 애플리케이션입니다. SwiftUI를 기반으로 MVVM 아키텍처 패턴을 적용하여 개발되었습니다.

## ✨ 주요 기능

*   **도서 검색**: 카카오 도서 검색 API를 통해 다양한 도서를 검색합니다.
    *   검색어 기반 질의
    *   정확도순 / 발간일순 정렬 (API 파라미터 활용)
    *   페이징 처리 (20개 단위)
*   **즐겨찾기 관리**:
    *   검색 결과에서 도서를 즐겨찾기에 추가/삭제합니다.
    *   즐겨찾기된 도서는 로컬에 저장됩니다. (현재는 메모리 기반 `FavoriteManager`)
    *   즐겨찾기 목록 내에서 검색, 제목 오름차순/내림차순 정렬, 금액 필터링이 가능합니다.
*   **도서 상세 정보**: 도서 이미지를 포함한 상세 정보를 확인합니다.
*   **재사용 가능한 UI**: `BooksListView`를 검색 탭과 즐겨찾기 탭에서 재사용하여 효율적인 코드 관리를 지향합니다.
*   **상태 기반 UI**: 네트워크 통신 상태(로딩, 성공, 에러, 결과 없음)에 따라 적절한 UI를 사용자에게 제공합니다.

## 🛠️ 기술 스택 및 프레임워크

*   **언어**: Swift 5
*   **프레임워크**: SwiftUI
*   **아키텍처**: MVVM (Model-View-ViewModel)
*   **의존성 관리**: DI (Dependency Injection) Container 패턴
*   **비동기 처리**: RxSwift (API 통신 및 데이터 스트림 관리)
*   **네트워크**: URLSession
*   **데이터 파싱**: Codable, JSONDecoder (snake_case 및 ISO8601 날짜 처리)
*   **커스텀 폰트**: Jalnan2 (ViewModifier를 통한 적용)

## 📂 프로젝트 구조

```
BookSearchApp/
├── BookSearchApp/
│   ├── BookSearchApp.swift           # 앱 진입점 및 초기 설정
│   ├── Data/                         # 데이터 계층
│   │   ├── Network/                  # 네트워크 통신 관련
│   │   │   ├── APIService.swift      # 카카오 API 호출 및 응답 처리
│   │   │   └── NetworkError.swift    # 네트워크 에러 정의
│   │   └── Repository/               # 데이터 저장소 (Repository 패턴)
│   │       └── BookRepository.swift  # 데이터 소스 추상화 (API/Mock)
│   ├── DI/                           # 의존성 주입 컨테이너
│   │   └── DIContainer.swift         # 의존성 객체 생성 및 주입 관리
│   ├── Domain/                       # 도메인 계층 (핵심 비즈니스 로직)
│   │   ├── Entity/                   # 데이터 모델 정의
│   │   │   └── BookItemModel.swift   # 도서 아이템 모델 (Codable, Identifiable)
│   │   └── UseCase/                  # 비즈니스 로직 실행 단위
│   │       └── (APISearchUseCase, LocalFavoritesUseCase 등)
│   ├── Extension/                    # 확장 기능
│   │   ├── Color+Extension.swift     # 커스텀 색상 정의
│   │   └── Font+Extension.swift      # 커스텀 폰트 ViewModifier 정의
│   ├── Presentation/                 # UI 계층
│   │   ├── ViewModel/                # 뷰 모델
│   │   │   └── BooksListViewModel.swift # 뷰 상태 및 비즈니스 로직 처리
│   │   └── Views/                    # SwiftUI 뷰
│   │       ├── Components/           # 재사용 가능한 UI 컴포넌트
│   │       │   ├── BookItemView.swift # 도서 아이템 카드 뷰
│   │       │   └── SortOptionsSectionView.swift # 정렬 옵션 섹션 뷰
│   │       └── BooksListView.swift   # 도서 목록 표시 (검색/즐겨찾기 탭 재사용)
│   └── Resources/                    # 앱 리소스
│       └── (Assets, Fonts 등)
├── BookSearchApp.xcodeproj/          # Xcode 프로젝트 파일
├── BookSearchAppTests/               # 유닛 테스트
└── BookSearchAppUITests/             # UI 테스트
```

## 💡 주요 구현 포인트

*   **MVVM 아키텍처**: View, ViewModel, Model의 역할을 명확히 분리하여 코드의 응집도를 높이고 유지보수를 용이하게 합니다.
*   **의존성 주입 (DI)**: `DIContainer`를 통해 객체 간의 의존성을 외부에서 주입하여 결합도를 낮추고 테스트 용이성을 확보합니다. Mock 데이터 소스와 실제 API 데이터 소스를 쉽게 전환할 수 있도록 구현되었습니다.
*   **UseCase 패턴**: 비즈니스 로직을 UseCase 단위로 캡슐화하여 ViewModel이 특정 데이터 소스에 의존하지 않도록 추상화했습니다. `APISearchUseCase`와 `LocalFavoritesUseCase`를 통해 검색 탭과 즐겨찾기 탭에서 `BooksListView`를 재사용할 수 있습니다.
*   **상태 기반 UI (`ViewState`)**: `BooksListViewModel`에서 `ViewState` 열거형을 통해 현재 뷰의 상태(로딩, 성공, 에러, 빈 결과 등)를 관리하고, `BooksListView`는 이 상태에 따라 적절한 UI를 동적으로 렌더링합니다.
*   **`Codable` 및 `JSONDecoder` 전략**: 카카오 API의 `snake_case` 키와 ISO8601 형식의 `datetime` 문자열을 Swift의 `camelCase` 프로퍼티와 `Date` 타입으로 자동으로 디코딩할 수 있도록 `JSONDecoder`의 `keyDecodingStrategy`와 `dateDecodingStrategy`를 커스터마이징했습니다.
*   **`ViewModifier`를 통한 폰트 관리**: 커스텀 폰트(`Jalnan2`)를 `ViewModifier`로 구현하여 뷰 전반에 걸쳐 일관된 폰트 스타일을 쉽게 적용하고 재사용할 수 있습니다.

## 🚀 빌드 및 실행 방법

1.  **프로젝트 압축 해제**:
    *   제출된 압축 파일(`BookSearchApp.zip` 등)을 원하는 위치에 압축 해제합니다.

2.  **카카오 REST API 키 설정**:
    *   [카카오 개발자 웹사이트](https://developers.kakao.com/)에서 애플리케이션을 생성하고 **REST API 키**를 발급받습니다.
    *   프로젝트 루트 디렉토리(`BookSearchApp/`)에 있는 `Secrets.xcconfig` 파일을 엽니다.
    *   `KAKAO_API_KEY = YOUR_KAKAO_API_KEY` 라인에서 `YOUR_KAKAO_API_KEY` 부분을 발급받은 REST API 키로 교체합니다.
        ```
        KAKAO_API_KEY = [발급받은_REST_API_키]
        ```
    *   **참고**: 이 파일은 프로젝트에 포함되어 있으므로, 별도의 Xcode 설정 없이 바로 빌드 및 실행이 가능합니다.
3.  **Xcode에서 빌드 및 실행**:
    *   압축 해제된 프로젝트 폴더 내 `BookSearchApp.xcodeproj` 파일을 Xcode로 엽니다.
    *   대상 기기(시뮬레이터 또는 실제 기기)를 선택하고 프로젝트를 빌드 및 실행합니다.

## 📝 과제 요구사항 (참고)

이 프로젝트는 다음 과제 요구사항을 기반으로 구현되었습니다.

*   **iOS 최소 버전**: 16.0
*   **Xcode 버전**: 16.2
*   **API**: Kakao Developers - 도서 검색 API
*   **화면 구성**: 하단 탭바 (전체 리스트, 즐겨찾기 리스트)
*   **검색 리스트 화면**: 도서 정보 카드, 검색, 정렬(정확도/발간일), 페이징, 즐겨찾기 토글, 상세 화면 이동
*   **즐겨찾기 리스트 화면**: 로컬 데이터 기반, 검색, 정렬/필터(제목 오름차순/내림차순, 금액 필터링), 즐겨찾기 토글, 상세 화면 이동
*   **도서 상세 화면**: 도서 이미지, 제목, 정보 표시, 즐겨찾기 토글

---
