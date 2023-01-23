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
        let requestCellItems: Observable<Void>
    }
    
    struct Output {
        let recruitItems: Driver<[RecruitItem]>
        let cellItems: Driver<[CellItem]>
        let error: Driver<APIServiceError>
    }
    
    private let fetchRecruitItems = PublishRelay<Void>()
    private let recruitItemsRelay = PublishRelay<[RecruitItem]>()
    private let cellItemsRelay = PublishRelay<[CellItem]>()
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
        
        input.requestCellItems
            .withUnretained(self)
            .subscribe(onNext: { _ in
                Task {
                    await self.cellItems()
                }
            })
            .disposed(by: disposeBag)
        
        let recruitItems = recruitItemsRelay.asDriver(onErrorJustReturn: [])
        let cellItems = cellItemsRelay.asDriver(onErrorJustReturn: [])
        let error = errorRelay.asDriver(onErrorJustReturn: APIServiceError.unknown)
        return Output(recruitItems: recruitItems,
                      cellItems: cellItems,
                      error: error)
    }
    
    func recruitItems() async {
        do {
            let results = try await networkService.recruitItems()
            switch results {
            case .success(let items):
                recruitItemsRelay.accept(items)
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
    
    func cellItems() async {
        do {
            let results = try await networkService.cellItems()
            
            switch results {
            case .success(let data):
                let transformer = CellItemsTransformer()
                
                guard let jsonObjects = try? transformer.transformDataToArrayOfJSONObject(data).get() else {
                    errorRelay.accept(.failedDecoding)
                    return
                }
                
                guard let cellItems = try? transformer.transformArrayOfJSONObjectToArrayOfCellItem(jsonObjects) else {
                    errorRelay.accept(.failedDecoding)
                    return
                }
                
                cellItemsRelay.accept(cellItems)
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
