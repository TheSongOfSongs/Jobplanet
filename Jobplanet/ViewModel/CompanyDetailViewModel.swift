//
//  CompanyDetailViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import Foundation
import RxCocoa
import RxSwift

class CompanyDetailViewModel {
    
    private let networkService = NetworkService()
    
    struct Input {
        let requestReviewsRecruitsByCompanyName: Observable<String>
    }
    
    struct Output {
        let reviews: Driver<[CellItemReview]>
        let recruits: Driver<[RecruitItem]>
        let error: Driver<APIServiceError>
    }
    
    let disposeBag = DisposeBag()
    
    private let requestReviewsRecruitsByCompanyNameRelay = PublishRelay<String>()
    private let reviewsRelay = PublishRelay<[CellItemReview]>()
    private let recruitsRelay = PublishRelay<[RecruitItem]>()
    private let errorRelay = PublishRelay<APIServiceError>()
    
    // MARK: -
    func transform(input: Input) -> Output {
        input.requestReviewsRecruitsByCompanyName
            .withUnretained(self)
            .subscribe(onNext: { (self, companyName) in
                Task {
                    await self.reviews(with: companyName)
                    await self.recruitItems(with: companyName)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(reviews: reviewsRelay.asDriver(onErrorJustReturn: []),
                      recruits: recruitsRelay.asDriver(onErrorJustReturn: []),
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
    
    func recruitItems(with companyName: String) async {
        do {
            let results = try await networkService.recruitItems()
            switch results {
            case .success(let items):
                let items = items.filter({ $0.company.name == companyName })
                recruitsRelay.accept(items)
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
