//
//  HomeViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewModel: ViewModel {
    
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
    private var bookMarkedRecruitItemIds: [Int] = []
    
    let disposeBag = DisposeBag()
    
    
    
    
    // MARK: - init
    init() {
        setObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    // MARK: -
    func transform(input: Input) -> Output {
        input.requestRecruitItems
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                Task {
                    await owner.recruitItems()
                }
            })
            .disposed(by: disposeBag)
        
        input.requestCellItems
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                Task {
                    await owner.cellItems()
                }
            })
            .disposed(by: disposeBag)
        
        input.requestRecruitItemsBySearching
            .withUnretained(self)
            .subscribe(with: self, onNext: { owner, result in
                let searchCodition = result.1
                owner.itemsBy(searchTerm: searchCodition.term, selectedListButton: searchCodition.list)
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
                let bookMarkedIds = fetchBookMarkedRecruitIds()
                let items = recruitItems(items: items, with: bookMarkedIds)
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
                
                guard let jsonObjects = try? transformer.transformDataToJSONObjects(data).get(),
                      let cellItems = try? transformer.transformJSONObjectsToCellItems(jsonObjects) else {
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
            let result = cellItems.compactMap({ $0 as? CellCompanyItem })
                .filter({ $0.name.contains(searchTerm)
                    || searchTerm.contains($0.name)
                })
            
            cellItemsRelay.accept(result)
        }
    }
    
    /// 채용아이템의 북마크 여부 property를 업데이트해주는 메서드
    func recruitItems(items: [RecruitItem], with bookMarekdIds: [Int]) -> [RecruitItem] {
        var result: [RecruitItem] = []
        for item in items {
            var item = item
            if bookMarekdIds.contains(item.id) {
                item.updateIsBookMarked(true)
            }
            result.append(item)
        }
        
        return result
    }
    
    /// 북마크 저장/삭제 요청 시 UserDefaults에 업데이트하고 viewModel이 갖고 있는 데이터 업데이트해주는 메서드
    func updateBookMark(recruitItem: RecruitItem, isBookMarkOn: Bool) {
        let id = recruitItem.id
        var ids = bookMarkedRecruitItemIds
        
        if isBookMarkOn {
            ids.insert(id, at: 0)
        } else {
            ids.removeAll(where: { $0 == id })
        }
        
        UserDefaultsHelper.setData(value: ids, key: .recruitIdsBookMarkOn)
        bookMarkedRecruitItemIds = ids
        
        NotificationCenter.default.post(name: .UpdatedBookMarkRecruitItmIds,
                                        object: nil,
                                        userInfo: [identifierKey: identifier])
    }
    
    /// UserDefaults에서 북마크된 채용아이템 id 배열을 가져오는 메서드
    func fetchBookMarkedRecruitIds() -> [Int] {
        let result = UserDefaultsHelper.getData(type: [Int].self, forKey: .recruitIdsBookMarkOn) ?? []
        self.bookMarkedRecruitItemIds = result
        return result
    }
}


extension HomeViewModel: NotificationUserInfoForViewModel {
    func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateBookMarkedRecruitIds),
                                               name: Notification.Name.UpdatedBookMarkRecruitItmIds,
                                               object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.UpdatedBookMarkRecruitItmIds,
                                                  object: nil)
    }
    
    @objc func updateBookMarkedRecruitIds(notification: Notification) {
        guard let identifier = notification.userInfo?[identifierKey] as? String,
              identifier != self.identifier else {
            return
        }
        
        let ids = fetchBookMarkedRecruitIds()
        let recruitItems = recruitItems(items: recruitItems, with: ids)
        recruitItemsRelay.accept(recruitItems)
    }
}
