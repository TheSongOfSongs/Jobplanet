//
//  HomeViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewModel {
    
    private let networkService = NetworkService()
    
    struct Input {
        let requestRecruitItems: Observable<Void>
    }
    
    struct Output {
        let recruitItems: Driver<[RecruitItem]>
        let error: Driver<APIServiceError>
    }
    
    private let fetchRecruitItems = PublishRelay<Void>()
    private let recruitItemsRelay = PublishRelay<[RecruitItem]>()
    private let errorRelay = PublishRelay<APIServiceError>()
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - init
    init() { }
    
    // MARK: -
    func transform(input: Input) -> Output {
        input.requestRecruitItems
            .withUnretained(self)
            .subscribe(onNext: { _ in
                Task {
                    await self.recruitItems()
                }
            })
            .disposed(by: disposeBag)
        
        let recruitItems = recruitItemsRelay.asDriver(onErrorJustReturn: [])
        let error = errorRelay.asDriver(onErrorJustReturn: APIServiceError.unknown)
        return Output(recruitItems: recruitItems,
                      error: error)
    }
    
    func recruitItems() async {
        do {
            let results = try await networkService.recruitItems()
            switch results {
            case .success(let items):
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
