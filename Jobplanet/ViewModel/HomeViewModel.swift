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
    
    typealias SearchCondition = (term: String, list: List)
    
    private let networkService = NetworkService()
    
    struct Input {
        let requestRecruitItems: Observable<Void>
        let requestCellItems: Observable<Void>
        /// 검색어, 채용/기업 중 선택된 버튼 타입
        let requestRecruitItemsBySearching: Observable<SearchCondition>
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
    
    private var recruitItems: [RecruitItem] = []
    private var cellItems: [CellItem] = []
    
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
        
        input.requestRecruitItemsBySearching
            .withUnretained(self)
            .subscribe(with: self, onNext: { _, result in
                let searchCodition = result.1
                self.itemsBy(searchTerm: searchCodition.term, selectedListButton: searchCodition.list)
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
                recruitItems = items
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
                
                let items = cellItems.filter({ $0.cellType != .review })
                cellItemsRelay.accept(items)
                self.cellItems = items
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
    
    func itemsBy(searchTerm: String, selectedListButton: List) {
        switch selectedListButton {
        case .recruit:
            let result = recruitItems.filter({ $0.company.name.contains(searchTerm)
                || searchTerm.contains($0.company.name)
                || $0.title.contains(searchTerm)
            })
            
            recruitItemsRelay.accept(result)
        case .cell:
            let result = cellItems.compactMap({ $0 as? CellItemCompany })
                .filter({ $0.name.contains(searchTerm)
                    || searchTerm.contains($0.name)
                })
            
            cellItemsRelay.accept(result)
        }
    }
}
