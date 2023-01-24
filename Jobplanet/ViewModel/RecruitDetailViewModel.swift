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
        let reviews: Driver<[CellReviewItem]>
        let error: Driver<APIServiceError>
    }
    
    private let requestReviewItemsByCompanyNameRelay = PublishRelay<String>()
    private let reviewsRelay = PublishRelay<[CellReviewItem]>()
    private let errorRelay = PublishRelay<APIServiceError>()
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    init() { }
    
    // MARK: -
    func transform(input: Input) -> Output {
        input.requestReviewsByCompanyName
            .withUnretained(self)
            .subscribe(onNext: { (owner, companyName) in
                Task {
                    await owner.reviews(with: companyName)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(reviews: reviewsRelay.asDriver(onErrorJustReturn: []),
                      error: errorRelay.asDriver(onErrorJustReturn: .unknown))
    }
    
    func reviews(with companyName: String) async {
        do {
            let results = try await networkService.cellItems()
            
            switch results {
            case .success(let data):
                let transformer = CellItemsTransformer()
                
                guard let jsonObjects = try? transformer.transformDataToArrayOfJSONObject(data).get(),
                      let reviews = try? transformer.transformArrayOfJSONObjectToArrayOfCellItemReview(jsonObjects, with: companyName) else {
                    errorRelay.accept(.failedDecoding)
                    return
                }
                
                reviewsRelay.accept(reviews)
            case .failure(let error):
                NSLog("❗️ 에러 - ", error.localizedDescription)
                errorRelay.accept(error)
            }
        } catch let error {
            NSLog("❗️ 에러 - ", error.localizedDescription)
            errorRelay.accept(.unknown)
        }
    }
}
