# 잡플래닛
## ⚙️ 개발 환경
- Language: Swift 5
- iOS Deployment Target: iOS 15.0 +
- Xcode: 13.0 compatible
<br/>  

## 👩‍💻 기술
- MVVM 아키텍쳐
- Unit Test 사용
<br/>  

## 📚 사용 라이브러리 
### CocoaPods
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
<br/>

## ✅ 실행 방법
1. 프로젝트를 클론합니다
2. 터미널에서 프로젝트 경로로 이동합니다
3. 터미널 창에 **pod install**을 입력하여 필요한 라이브러리를 다운받습니다
4. **JobPlanet.xcworkspace** 파일을 열어 실행합니다.
<br/>


## 📱 주요 기능 및 화면
<p align="center">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214523933-3ef1049a-e335-4fc9-bb72-33b5a033b6c3.PNG">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214523932-125389c0-523d-4702-aaf9-a3d7f8b79075.PNG">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214523929-e65c0ede-8d52-4811-b097-c317b80f1fd8.PNG">
</p>  
<p align="center">
채용 버튼과 기업 버튼으로 채용 리스트와 기업 리스트를 화면에 보여줍니다  
</p>
<p align="center">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214523925-d0a8215d-4d84-47bc-86ba-81584d00a6a6.PNG">
</p>  
<p align="center">
기업, 채용 공고를 회사 이름으로 검색하여 필터링할 수 있습니다
</p>  
<p align="center">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214523922-6bfbc3f5-ae77-49c2-a752-a1b9e9a1fd05.PNG">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214525662-25c89bae-8889-4a56-b38b-7a10997b5069.PNG">
</p>  
<p align="center">
채용 정보와 기업 정보를 누르면 상세 화면으로 이동합니다
</p>  
<p align="center">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214523909-a4cffd07-5670-4ca9-92e6-c871604bcfdb.PNG">
</p>  
<p align="center">
채용 정보를 북마크하여 한 번에 확인할 수 있습니다
</p>  

<br/>

## 🛠 개발 주요 사항
<p align="center">
<img width="740" alt="image" src="https://user-images.githubusercontent.com/46002818/214515874-cc5ace8d-651d-4520-8f92-1e54ba0b904b.png">
</p>  

### 1. MVVM 패턴과 Input/Output 바인딩 구조
- View Controller는 View를 소유하고 있으며 둘은 긴밀하게 엮여있습니다
- View Controller는 ViewModel을 소유하며 둘은 Input과 Output을 통해 소통합니다  
- View Controller는 ViewModel의 input을 통해 데이터를 가져오는 액션을 요구하고 ViewModel은 output을 통해 가져온 데이터를 가공하여 전달합니다  
    #### ✅ Input, Output 도입 이유
    ViewModel의 Model은 private하게 선언되어 View Controller에서 임의로 접근하여 값을 변질시킬 수 없습니다. View Controller는 Input, Output 객체로부터 바인딩하여 얻은 값을 사용하기 때문에 데이터의 안전성이 보장됩니다. 더불어 함수 *transform(input:)* 를 통해 로직의 분리시키기 때문에, 데이터 흐름을 파악하기 쉽고 코드 파악이 용이하다는 장점이 있습니다.

```swift
final class HomeViewModel: ViewModel {
    struct Input {
        let requestRecruitItems: Observable<Void>
        let requestCellItems: Observable<Void>
        let requestRecruitItemsBySearching: Observable<SearchCondition>
    }
    
    struct Output {
        let recruitItems: Driver<[RecruitItem]>
        let cellItems: Driver<[CellItem]>
        let error: Driver<APIServiceError>
    }
    
    private let recruitItemsRelay = PublishRelay<[RecruitItem]>()
    private let cellItemsRelay = PublishRelay<[CellItem]>()
    private let errorRelay = PublishRelay<APIServiceError>()

    ...
}
```
<br/>  

### 2. NetworkService
- API 종류를 enum 형태로 갖고, NetworkService는 enum 값에 따라 URL을 생성하는 static 메서드 urlBuilder()로 URLComponents를 생성합니다
- class NetworkService는 채용 정보 API, 기업 정보 API로부터 Json형태의 데이터를 가져오는 역할을 합니다. 두 API에서 URL을 통해 Data를 가져오는 코드는 동일하므로 extension으로 따로 분리하여 private 메서드로 구현하였습니다
- 각 API가 제대로 동작하는지 확인하기 위해 Mock URLSession과 Mock Data로 테스트하는 코드를 작성했습니다. 데이터가 원하는 형태로 변환되는지 확인하는 테스트입니다
- HomeVC에서 현재 네트워킹이 이뤄지고 있는 도중에 채용/버튼 혹은 검색 기능을 눌러 새로운 요청을 할 수 있습니다. 이에 대비하여 새로운 요청이 들어오면 현재 진행 중이던 작업은 취소하고, 새로운 요청을 현재 진행 중인 작업에 할당하고 진행합니다.
<br/>   

### 3. 기업 API 객체 생성
<p align="center">
<img width="600" alt="image" src="https://user-images.githubusercontent.com/46002818/214516684-584d9452-1046-46dd-a4db-fa13ace71852.png">
</p>  
기업 정보는 Json의 key값인 type에 따라 cell_type_company, cell_type_horizontal_theme, cell_type_theme 총 3가지로 모델이 구분됩니다. API를 통해 받은 Json에서는 이 3가지가 모두 한 배열에 담겨져있으나, 각 cell의 디자인과 내용이 다르기 때문에 다른 종류의 객체로 구성하는 것이 좋습니다. 따라서 Codable을 이용해 객체를 생성할 수 없어 처음 개발 계획 시 아래와 같이 구상하였습니다.  
  
<br/>
  
  1. cell_type_company, cell_type_horizontal_theme, cell_type_theme의 프로퍼티들을 모두 포함한 Codable한 구조체를 만듭니다. 이 때 3가지 형태의 데이터가 공통으로 갖고 있는 프로퍼티는 type 밖에 없으므로 type 이외의 프로퍼티들은 옵셔널로 선언합니다.
  2. 가져온 데이터들은 type으로 구분하여 각각의 구조체를 통해 객체를 생성해줍니다.  
   
위와 같이 구현했을 때의 단점은 새로운 셀 타입(cell_type_XXX)이 추가될 때마다, 많은 프로퍼티들이 추가되어야 합니다. Json 객체를 Codable 기능을 이용해 구조체로 가져오기 위함이 이유인데 객체 관리가 어렵다는 것이 단점입니다. 그래서 아래와 같이 구조를 변경하였습니다.
  1. API를 통해 받은 데이터를 딕셔너리([String: Any]) 형태로 변환합니다
  2. 딕셔너리의 key값을 통해 기업 정보 데이터 배열을 가져옵니다 (이 때 배열 역시 동일한 딕셔너리 타입입니다)
  3. 배열을 순회하며 딕셔너리에서 key 값으로 type을 확인하고, 동일한 프로토콜을 준수하는 각 타입의 객체로 변환하여 줍니다. 동일한 프로토콜을 준수하므로 한 배열에 담을 수 있습니다

#### ✅ CellItemsTransformer
CellItemsTransformer로 각 단계별로 데이터 가공을 하여 ViewModel에서 데이터 변환 로직을 분리시켰습니다. 각 메서드별로 잘 동작하는지 확인하는 유닛테스트 코드를 작성하였습니다.  

#### ✅ protocol CellItem
CellItem을 준수하는 아이템들은 type이 다르더라도 배열에 함께 담을 수 있습니다. 배열의 원소들은 CellItem을 준수하는 Model로 다운캐스팅이 가능합니다. 따라서 추후에 cell_type_XXX 형태의 새로운 셀 타입이 추가되었을 때에 Model이 CellItem을 준수하도록 설계하면 쉽게 확장할 수 있습니다.

<br/>  

### 4. 네트워크 연결 관리
<p align="center">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214519043-38f1b8c1-34e8-4df8-8bbf-e3aa81c2a3fe.jpeg"><img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214518733-1c7636ae-b836-49d4-be61-c53585458c9c.PNG">
</p>  

- 싱글톤 클래스 NetworkConnectionManager를 두어 네트워크 연결 여부를 알 수 있습니다
- 앱 시작 시, 모니터링이 시작되며 API에 요청이 들어오면 API 통신을 담당하는 NetworkService 클래스에서 확인합니다
- 홈화면에서 API 요청을 했을 때 네트워크 연결 해제 이벤트를 받으면 토스트창과 재시도버튼, 알림라벨이 왼쪽 사진과 같이 표시됩니다.
- 채용/기업 상세화면에서 API 요청을 했을 때 네트워크 연결 해제 이벤트를 받으면 토스트창과 데이터가 입력되지 않은 화면이 오른쪽 사진과 같이 표시됩니다.
<br/>  

### 5. 북마크 기능
<p align="center">
<img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214519994-c0a26ca4-e251-44b9-8a68-574c3eb00085.PNG"><img width="180" alt="image" src="https://user-images.githubusercontent.com/46002818/214519988-898f0ed4-e4e3-4f6d-a0e4-4b9568e977d2.PNG">
</p> 

- UserDefaults를 사용하여 저장된 채용 아이템의 id 값을 저장합니다
- UserDefaultsHelper라는 클래스를 두어 UserDefaults에 채용 아이템 id를 저장/삭제 할 수 있도록 구현하였습니다 
- 홈탭과 저장된채용탭에서 북마크 저장/삭제가 발생했을 때 서로 변경 여부를 통신해야 합니다. 이 때 Notificaiton을 이용하여 데이터를 주고받습니다
- protocol NotificationBookMarkedRecruitItems은 뷰모델만 채택할 수 있도록 제약을 걸었으며, 이를 채택한 뷰모델에서 북마크 리스트 업데이트 이벤트를 받습니다
<br/>  

### 6. 이미지 캐싱 처리
- Kingfisher를 이용하여 이미지 캐싱처리를 합니다
- 셀이 재사용될 때 이미지가 깜빡이는 이슈가 있어, UIImageView를 상속받은 IdentifiableImageView를 두었습니다
- IdentifiableImageView는 identifer가 있기 때문에 셀 재사용 시, identifier를 확인하여 현재 셀에서 요구하는 이미지가 맞는지 확인합니다
- 또한 셀 재사용 시, 이미지 다운로드 중이던 작업을 취소하기 위해 protocol CellImageDownloadCancelling을 만들었습니다
- CollectionViewCell에서는 CellImageDownloadCancelling을 준수하여 prepareForReuse() 때 이미지 다운 취소 메서드를 호출합니다
<br/>  
<br/>  

## ♻️ 유닛 테스트
- JobplanetFakeTests
  - Mock URLSession과 Mock Data을 만들어 데이터를 잘 받는지 확인하는 테스트입니다.
- JobplanetCellItemsTransformerTests
  - CellItemsTransformer 객체를 테스트합니다. 기업 정보 API의 데이터 가공을 하는 역할입니다.
- JobPlanetUserDefaultsHelperTest
  - UserDefaultsHelper 클래스가 UserDefaults에 원하는 값을 저장하고 불러오는지 테스트합니다.

<br/>

## 🔥 이후 추가 개발 사항
- UI 테스트를 도입하여 더욱 안정적인 동작을 할 수 있도록 합니다
- 채용 정보와 기업 정보를 눌러 이동한 화면에는 리뷰 정보가 뜹니다. '더보기' 버튼을 눌렀을 때 리뷰 리스트를 보여주는 개발을 해야 합니다
