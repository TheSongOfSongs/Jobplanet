//
//  CompanyDetailViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import Foundation
import RxCocoa
import RxSwift

final class CompanyDetailViewModel: ViewModel {
    
    private let networkService = NetworkService()
    
    struct Input {
        let requestReviewsAndRecruitsByCompanyName: Observable<String>
    }
    
    struct Output {
        let reviews: Driver<[CellReviewItem]>
        let recruits: Driver<[RecruitItem]>
        let error: Driver<APIServiceError>
    }
    
    let disposeBag = DisposeBag()
    
    private let cellReviewItemsRelay = PublishRelay<[CellReviewItem]>()
    private let recruitItemsRelay = PublishRelay<[RecruitItem]>()
    private let errorRelay = PublishRelay<APIServiceError>()
    
    // MARK: -
    func transform(input: Input) -> Output {
        input.requestReviewsAndRecruitsByCompanyName
            .withUnretained(self)
            .subscribe(onNext: { (owner, companyName) in
                Task {
                    await owner.fetchReviews(with: companyName)
                    await owner.fetchRecruitItems(with: companyName)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(reviews: cellReviewItemsRelay.asDriver(onErrorJustReturn: []),
                      recruits: recruitItemsRelay.asDriver(onErrorJustReturn: []),
                      error: errorRelay.asDriver(onErrorJustReturn: .unknown))
    }
    
    /// 기업 API에 데이터를 요청 후, 회사 이름으로 필터링하여 기업 리뷰 [CellReviewItem]을 얻는 메서드
    func fetchReviews(with companyName: String) async {
        do {
            let results = try await networkService.cellItems()
            
            switch results {
            case .success(let data):
                let transformer = CellItemsTransformer()
                
                guard let jsonObjects = try? transformer.transformDataToJSONObjects(data).get(),
                      let reviews = try? transformer.transformJSONObjectsToCellItemReviews(jsonObjects, with: companyName) else {
                    errorRelay.accept(.failedDecoding)
                    return
                }
                
                cellReviewItemsRelay.accept(reviews)
            case .failure(let error):
                NSLog("❗️ 에러 - ", error.localizedDescription)
                errorRelay.accept(error)
            }
        } catch let error {
            NSLog("❗️ 에러 - ", error.localizedDescription)
            errorRelay.accept(.unknown)
        }
    }
    
    /// 채용 API에 데이터를 요청 후, 회사 이름으로 필터링하여 기업 리뷰 [RecruitItem]을 얻는 메서드
    func fetchRecruitItems(with companyName: String) async {
        do {
            let results = try await networkService.recruitItems()
            switch results {
            case .success(let items):
                let items = items.filter({ $0.company.name == companyName })
                recruitItemsRelay.accept(items)
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
