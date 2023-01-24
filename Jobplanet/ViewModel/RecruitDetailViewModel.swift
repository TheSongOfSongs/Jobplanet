//
//  RecruitDetailViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift



class RecruitDetailViewModel {
    
    private let networkService = NetworkService()
    
    struct Input {
        let requestReviewsByCompanyName: Observable<String>
    }
    
    struct Output {
        let reviews: Driver<[CellItemReview]>
        let error: Driver<APIServiceError>
    }
    
    private let requestReviewItemsByCompanyNameRelay = PublishRelay<String>()
    private let reviewsRelay = PublishRelay<[CellItemReview]>()
    private let errorRelay = PublishRelay<APIServiceError>()
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    init() { }
    
    // MARK: -
    func transform(input: Input) -> Output {
        input.requestReviewsByCompanyName
            .withUnretained(self)
            .subscribe(onNext: { (self, companyName) in
                Task {
                    await self.reviews()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(reviews: reviewsRelay.asDriver(onErrorJustReturn: []),
                      error: errorRelay.asDriver(onErrorJustReturn: .unknown))
    }
    
    func reviews() async {
        do {
            let results = try await networkService.cellItems()
            
            switch results {
            case .success(let data):
                let transformer = CellItemsTransformer()
                
                guard let jsonObjects = try? transformer.transformDataToArrayOfJSONObject(data).get(),
                      let reviews = try? transformer.transformArrayOfJSONObjectToArrayOfCellItemReview(jsonObjects) else {
                    errorRelay.accept(.failedDecoding)
                    return
                }
                
                reviewsRelay.accept(reviews)
            case .failure(let error):
                guard error != .cancelled else {
                    return
                }
                
                NSLog("❗️ 에러 - ", error.localizedDescription)
                errorRelay.accept(error)
            }
        } catch let error {
            NSLog("❗️ 에러 - ", error.localizedDescription)
            errorRelay.accept(.unknown)
        }
    }
}
