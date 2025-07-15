# BookSearchApp

## 사용된 기술 및 프레임워크
- **SwiftUI**: 선언형 UI를 위한 프레임워크
- **RxSwift**: 비동기 프로그래밍을 위한 반응형 프로그래밍 라이브러리 (데이터 실시간 흐름 관리, 에러 전파 용이성)
- **CoreData**: 로컬 데이터 저장을 위한 프레임워크 (즐겨찾기 기능 구현에 사용)
- **URLSession**: 네트워크 통신을 위한 프레임워크
- **XCTest**: 단위 테스트 및 UI 테스트를 위한 프레임워크

## 아키텍처
이 프로젝트는 **클린 아키텍처**을 기반으로 **MVVM** 패턴을 적용하여 설계되었습니다. 이를 통해 UI, 비즈니스 로직, 데이터 계층을 명확하게 분리하여 코드의 유지보수성, 테스트 용이성, 확장성을 극대화했습니다.

### 클린 아키텍처 계층 구조

1.  **Data Layer**:
    -   **Repository Implementation**: 도메인 계층에서 정의한 Repository 프로토콜을 구현합니다
    -   **DataSource**: 실제 데이터 소스(네트워크 API, 로컬 데이터베이스 등)와 통신하는 로직들입니다.
    -   이 계층은 외부 데이터 소스와의 상호작용을 담당하며, 도메인 계층에 필요한 데이터를 제공합니다.

2.  **Domain Layer**:
    -   **Entity**: 앱의 핵심 객체(`BookItemModel`) 혹은 네트워크 응답 모델이 정의되어 있습니다.
    -   **UseCase**: 앱의 핵심 비즈니스 규칙을 정의하고 실행하는 로직들입니다.
    -   **Repository**: 데이터 계층과의 계약을 정의하는 프로토콜이 있습니다.

3.  **Presentation Layer**:
    -   **View**: 사용자 인터페이스를 담당하는 SwiftUI View (`BooksListView`, `BookDetailView`).
    -   **ViewModel**: View의 상태를 관리하고, View의 사용자 이벤트를 처리하며, UseCase를 호출하여 비즈니스 로직을 실행합니다.  ViewModel은 Domain 계층의 UseCase에 의존하지만, Data 계층이나 특정 View에 직접 의존하지 않습니다.

### MVVM 패턴의 역할
클린 아키텍처 내에서 MVVM은 Presentation 계층의 구조를 정의합니다. ViewModel은 View와 Domain 계층 사이의 중개자 역할을 하며, View는 ViewModel을 통해 데이터를 바인딩하고 사용자 이벤트를 전달합니다.

### 의존성 흐름
의존성은 항상 안쪽으로 향합니다. 즉, Presentation 계층은 Domain 계층에 의존하고, Data 계층은 Domain 계층에 의존하지만, 그 반대는 성립하지 않습니다. 이를 통해 핵심 비즈니스 로직(Domain)이 외부 변화(UI, 데이터베이스, 외부 API 등)로부터 독립적으로 유지됩니다.
- 데이터 플로우: View에서 사용자 이벤트 발생 -> ViewModel에 전달 -> ViewModel은 UseCase 호출 -> UseCase는 Repository 호출 -> Repository는 DataSource
         호출 -> DataSource는 API/CoreData와 통신 -> 데이터 역방향 전달 (Observable 스트림) -> ViewModel 상태 업데이트 -> View 업데이트.

### 의존성 주입 (DI)
`DIContainer`를 사용하여 각 계층 간의 의존성을 주입합니다. 이는 코드의 유연성을 높이고, 테스트 시 Mock 객체를 쉽게 주입할 수 있도록 하여 테스트 용이성을 크게 향상시킵니다.

## 프로젝트 구조
```
BookSearchApp/
├───BookSearchApp.swift           # 앱 진입점
├───Data/                         # 데이터 관련 계층
│   ├───CoreData/                 # CoreData 관리
│   │   └───CoreDataManager.swift
│   ├───DataSource/               # 데이터 소스 정의 (API, Mock 등)
│   │   ├───BookDataSource.swift
│   │   └───KakaoBookDataSource.swift
│   ├───Network/                  # 네트워크 통신 관련
│   │   ├───APIService.swift
│   │   └───NetworkError.swift
│   ├───RepositoryImpl/           # 데이터 저장소 추상화 및 구현
│       ├───APIBookRepository.swift
│       ├───FavoriteRepositoryImpl.swift
│       ├───LocalBookRepository.swift
├───DI/                           # 의존성 주입 컨테이너
│   ├───DIContainer.swift
├───Domain/                       # 도메인 계층 (비즈니스 로직, 유스케이스)
│   ├───Entity/
│   │   ├───BookItemModel.swift
│   │   ├───BookSearchResponse.swift
│   │   └───Meta.swift
│   ├───Enum/
│   │   └───SortOption.swift
|   ├───Repository/
|   |   ├───BookFetchRepository.swift
|   |   └───FavoriteRepository.swift
│   └───UseCase/                  # 유스케이스 정의
│       ├───APISearchUseCase.swift
│       ├───BooksListUseCase.swift
│       └───LocalFavoritesUseCase.swift
├───Extension/                    # 확장 기능
│   ├───Color+Ext.swift
│   ├───View+Ext.swift
├───Presentation/                 # UI 및 ViewModel 계층
│   ├───ViewState.swift
│   ├───ViewType.swift
│   ├───ViewModel/
│   │   ├───BookItemViewModel.swift
│   │   └───BooksListViewModel.swift
│   ├───Views/                    # SwiftUI View
│       ├───BookDetailView.swift
│       ├───BooksListView.swift
│       ├───BookItemView.swift
│       ├───Components/           # 재사용 가능한 UI 컴포넌트
│           ├───BookItemLoadingSkeleton.swift
│           ├───CustomLabelView.swift
│           ├───CustomSearchBarView.swift
│           ├───FavoriteButton.swift
|           ├---PriceView.swift
|           ├---SafariView.swift
│           ├───SortOptionsSectionView.swift
├───Resources/                    # 리소스 파일 (여기어때 잘난체 폰트)
    ├───Assets.xcassets/
    ├───Fonts/
```

## 주요 구현 포인트
- **의존성 주입 (DI)**: `DIContainer`를 사용하여 의존성을 관리하고, 테스트 용이성과 모듈성을 높였습니다.
- **네트워크 통신**: `APIService`를 통해 카카오 책 검색 API와 통신하며, `URLSession`을 활용하여 비동기적으로 데이터를 가져옵니다.
- **로컬 데이터 저장**: `CoreData`를 사용하여 즐겨찾기 책 정보를 로컬에 영구적으로 저장하고 관리합니다.
- **뷰 재사용 및 모디파이어**: `CustomSearchBarView`와 같은 컴포넌트와 `BooksListView`를 정의하여 재사용성을 높였습니다. 
    또한, 서체를 폰트에 적용하는 `jalnanFont()`와 같은 커스텀 뷰 모디파이어를 제작하였습니다. 
- **반응형 프로그래밍**: `RxSwift`를 활용하여 비동기 데이터 흐름을 처리하고, UI 업데이트를 효율적으로 관리합니다.
- **테스트 코드 작성**: API 데이터 응답, 도서 아이템 즐겨찾기, CoreData 저장 등을 테스트하였습니다.
- **UX 개선**: 로딩 스켈레톤, 햅틱 피드백, stretch Header 등으로 사용자의 경험을 개선하였습니다.

## 빌드 및 실행 방법
1.  **프로젝트 압축 해제**:
    제공된 압축 파일을 원하는 위치에 해제합니다.
2.  **의존성 설치**: 이 프로젝트는 Swift Package Manager(SPM)를 통해 의존성을 관리합니다. 별도의 수동 설치 과정은 필요 없습니다.
3.  **API 키 설정**:
    - 카카오 REST API 키는 프로젝트 루트의 `Secrets.xcconfig` 파일에 이미 설정되어 있습니다.
    - 만약 키를 변경하거나 새로 설정해야 한다면, `Secrets.xcconfig` 파일을 열어 `KAKAO_API_KEY` 값을 수정하십시오:
      ```
      KAKAO_API_KEY = YOUR_KAKAO_API_KEY
      ```
      
4.  **Xcode에서 열기**: 압축 해제된 폴더 내의 `BookSearchApp.xcodeproj` 파일을 16.2 버전의 Xcode로 열어서 iOS 16.0 이상 시뮬레이터 또는 실제 기기를 선택한 후 앱을 빌드 및 실행합니다.

