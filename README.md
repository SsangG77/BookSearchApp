# BookSearchApp - SwiftUI 프로젝트

이 프로젝트는 SwiftUI를 사용하여 책 검색 애플리케이션의 핵심 UI 컴포넌트 중 하나인 `BookItemView`를 구현합니다. `BookItemView`는 책 목록에서 각 책의 정보를 시각적으로 표현하는 역할을 합니다.

## 빌드 방법

이 프로젝트는 Xcode를 사용하여 빌드 및 실행할 수 있습니다.

1.  **Xcode 설치:** macOS에 최신 버전의 Xcode가 설치되어 있는지 확인합니다.
2.  **프로젝트 열기:** `BookSearchApp.xcodeproj` 파일을 Xcode로 엽니다.
3.  **의존성 확인:** 프로젝트에 필요한 Swift Package Manager (SPM) 의존성이나 CocoaPods/Carthage 의존성이 있다면 자동으로 해결되거나, 필요한 경우 수동으로 설치합니다.
    *   현재 `AsyncImage`는 SwiftUI 15+에서 기본 제공되므로, 별도의 외부 라이브러리 의존성은 명시적으로 추가되지 않았습니다.
4.  **빌드 및 실행:** Xcode 상단의 스키마 선택기에서 대상(예: `BookSearchApp`)을 선택하고, 시뮬레이터 또는 실제 기기를 선택한 후 빌드 및 실행 버튼(▶️)을 클릭합니다.

## 사용 프레임워크

*   **SwiftUI:** 사용자 인터페이스를 선언적으로 구축하기 위한 Apple의 UI 프레임워크.
*   **Foundation:** 기본 데이터 타입, 컬렉션, 날짜 및 시간 관리, URL 처리 등 핵심 기능을 제공하는 프레임워크.
*   **AsyncImage (SwiftUI 15+):** URL에서 이미지를 비동기적으로 로드하고 표시하는 데 사용됩니다.

## 프로젝트 구조

현재 프로젝트는 `BookItemView` 컴포넌트를 중심으로 구성되어 있으며, 클린 아키텍처 원칙에 따라 프레젠테이션 계층의 분리를 지향합니다.

```
/Users/chasangjin/Documents/dev/swiftui_Project/BookSearchApp/
├───BookSearchApp/
│   ├───BookSearchAppApp.swift
│   ├───ContentView.swift
│   ├───Persistence.swift
│   ├───Presentation/
│   │   ├───FavoriteBooksView.swift
│   │   ├───TotalListView.swift
│   │   └───Components/
│   │       └───BookItemView.swift  <-- 이 파일에 대한 작업이 진행됨
│   └───Resources/
│       └───...
├───BookSearchApp.xcodeproj/
│   └───...
├───BookSearchAppTests/
│   └───...
└───BookSearchAppUITests/
    └───...
```

*   **`BookItemView.swift`:** 이 파일은 `BookItemView`와 `BookItemViewModel`을 포함합니다. `BookItemModel`은 이 파일 외부에 정의되어 있다고 가정합니다.
*   **`Presentation/Components/`:** 재사용 가능한 UI 컴포넌트들이 위치하는 디렉토리.

## 주요 구현 포인트

`BookItemView.swift` 파일은 단일 책 항목의 상세 정보를 표시하는 뷰를 정의하며, 다음과 같은 주요 구현 특징을 가집니다.

### 아키텍처 결정

`BookItemView`는 클린 아키텍처 원칙을 따르며, 특히 프레젠테이션 계층의 관심사 분리에 중점을 둡니다.

*   **`BookItemModel` (도메인 계층):** 이 파일에는 `BookItemModel`의 정의가 포함되어 있지 않습니다. `BookItemModel`은 UI에 종속되지 않는 순수한 데이터 구조로, 프로젝트의 다른 도메인 계층 파일에 정의되어 있다고 가정합니다.
*   **`BookItemViewModel` (프레젠테이션 계층):** `BookItemView.swift` 파일 내에 정의되어 있습니다. `BookItemViewModel`은 `BookItemModel`을 주입받아 뷰가 화면에 표시하기 쉬운 형태로 데이터를 가공하는 역할을 합니다. 모든 표시 로직(문자열 포맷팅, 할인율 계산 등)은 뷰 모델에서 처리됩니다.
*   **`BookItemView` (프레젠테이션 계층):** `BookItemViewModel`에서 가공된 데이터를 받아서 단순히 화면에 표시하는 역할만 합니다. 뷰는 데이터 변환이나 복잡한 로직을 포함하지 않아 간결하고 테스트하기 용이합니다.

### `EnvironmentObject` 및 `Binding` 미사용 이유

`BookItemView`는 리스트의 개별 항목을 표시하는 뷰로서, 다음과 같은 이유로 `EnvironmentObject`나 `Binding`을 사용하지 않습니다:

*   **`EnvironmentObject`:** 앱 전체에 걸쳐 공유되는 전역적인 상태를 전달할 때 사용됩니다. `BookItemView`는 특정 책 항목에 대한 독립적인 정보를 표시하므로, `EnvironmentObject`를 사용하는 것은 불필요한 의존성을 만들고 재사용성을 저해할 수 있습니다.
*   **`Binding`:** 상위 뷰의 상태를 하위 뷰에서 양방향으로 수정할 때 사용됩니다. `BookItemView`는 데이터를 표시하는 역할에만 집중하며, 자신의 데이터를 직접 수정할 필요가 없습니다. 데이터 변경 로직은 뷰 모델이나 더 상위 계층에서 처리하는 것이 클린 아키텍처에 부합합니다.

이러한 아키텍처 선택은 `BookItemView`의 재사용성, 테스트 용이성 및 데이터 흐름의 명확성을 높이는 데 기여합니다.

### 구현된 기능 상세

*   **책 표지 이미지:** `AsyncImage`를 사용하여 비동기적으로 책 표지 이미지를 로드하고, 로딩 중 또는 에러 발생 시 적절한 플레이스홀더를 표시합니다. 이미지의 너비는 100pt로 고정되어 있으며, 높이는 부모 뷰에 맞춰 확장됩니다.
*   **책 내용:**
    *   "도서" 카테고리 텍스트 (회색, 작은 글씨)
    *   **책 제목:** 굵은 글씨로 강조되며, 최대 2줄까지 표시됩니다.
    *   **저자 정보:** `Label`을 사용하여 사람 아이콘(`person.fill`)과 함께 표시됩니다. 여러 명의 저자는 쉼표(`, `)로 구분되며, 최대 2줄까지 표시됩니다.
    *   **출판사 정보:** `Label`을 사용하여 건물 아이콘(`building.2.fill`)과 함께 표시되며, 최대 1줄까지 표시됩니다.
*   **가격 및 할인 정보:**
    *   **즐겨찾기 버튼:** 별 아이콘(`star.fill`)으로 표시됩니다.
    *   **가격 표시:**
        *   할인된 가격이 있는 경우: 원가는 작게 회색 취소선으로 표시되고, 할인된 가격은 빨간색으로 강조되며, 옆에 할인율(예: `(25.0%)`)이 함께 표시됩니다.
        *   할인된 가격이 없는 경우: 원가만 굵은 글씨로 표시됩니다.

## `BookItemView` 사용 방법 (예시)

`BookItemView`는 `BookItemViewModel`을 통해 초기화됩니다. `BookItemViewModel`은 `BookItemModel` 인스턴스를 필요로 합니다.

```swift
// BookItemView를 사용하는 예시 (예: 리스트 내에서)

// BookItemModel은 다른 파일에 정의되어 있다고 가정합니다.
// struct BookItemModel: Identifiable { ... }

// BookItemView를 초기화할 때 BookItemViewModel을 생성하여 전달합니다.
let sampleBook = BookItemModel(
    isbn: "8996991341 9788996991342",
    coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
    title: "미움받을 용기",
    authors: ["기시미 이치로", "고가 후미타케"],
    publisher: "인플루엔셜",
    status: "정상",
    price: 19000,
    salePrice: 12000
)

BookItemView(viewModel: BookItemViewModel(book: sampleBook))
```
