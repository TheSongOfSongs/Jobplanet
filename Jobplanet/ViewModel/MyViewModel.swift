//
//  MyViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class MyViewModel: ViewModel {
    struct Input { }
    
    struct Output {
        let recruitItems: Driver<[RecruitItem]>
        let error: Driver<APIServiceError>
    }
    
    private let bookedRecruitItemsRelay = PublishRelay<[RecruitItem]>()
    private let errorRelay = PublishRelay<APIServiceError>()
    private var bookMarkedRecruitItemIds: [Int] = []
    
    let disposeBag = DisposeBag()
    
    private let networkService = NetworkService()
    
    var recruitItems: [RecruitItem] = []
    
    // MARK: -
    init() {
        setObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    // MARK: -
    func transform(input: Input) -> Output {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let ids = self.fetchBookMarkedRecruitIds()
                let result = try await self.fetchRecruitItems()
                
                switch result {
                case .success(let items):
                    self.recruitItems = items
                    
                    let items =  self.filterRequestItems(items, with: ids)
                    self.bookedRecruitItemsRelay.accept(items)
                case .failure(let error):
                    self.errorRelay.accept(error)
                }
                
            } catch let error {
                self.errorRelay.accept(error as? APIServiceError ?? .unknown)
            }
        }
        
        let recruitItems = bookedRecruitItemsRelay.asDriver(onErrorJustReturn: [])
        let error = errorRelay.asDriver(onErrorJustReturn: APIServiceError.unknown)
        return Output(recruitItems: recruitItems,
                      error: error)
    }
    
    private func fetchBookMarkedRecruitIds() -> [Int] {
        let ids = UserDefaultsHelper.getData(type: [Int].self, forKey: .recruitIdsBookMarkOn) ?? []
        self.bookMarkedRecruitItemIds = ids
        return ids
    }
    
    private func fetchRecruitItems() async throws -> Result<[RecruitItem], APIServiceError> {
        do {
            let results = try await networkService.recruitItems()
            switch results {
            case .success(let items):
                return .success(items)
            case .failure(let error):
                NSLog("❗️ 에러 - ", error.localizedDescription)
                return .failure(.unknown)
            }
        } catch let error {
            NSLog("❗️ 에러 - ", error.localizedDescription)
            return .failure(.unknown)
        }
    }
    
    private func filterRequestItems(_ recruitItems: [RecruitItem], with ids: [Int]) -> [RecruitItem] {
        let result = recruitItems
            .filter({ ids.contains($0.id) })
            .map { item in
                var item = item
                item.updateIsBookMarked(true)
                return item
            }
        
        return result
    }
    
    /// 북마크 삭제 요청 시 UserDefaults에 업데이트하고 viewModel이 갖고 있는 데이터 업데이트해주는 메서드
    func deleteBookMark(recruitItem: RecruitItem) {
        let id = recruitItem.id
        let ids = bookMarkedRecruitItemIds.filter({ $0 != id })
        UserDefaultsHelper.setData(value: ids, key: .recruitIdsBookMarkOn)
        bookMarkedRecruitItemIds = ids
        
        NotificationCenter.default.post(name: .UpdatedBookMarkRecruitItmIds,
                                        object: nil,
                                        userInfo: [identifierKey: identifier])
    }
}

extension MyViewModel: NotificationBookMarkedRecruitItems {
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
        let recruitItems = filterRequestItems(recruitItems, with: ids)
        bookedRecruitItemsRelay.accept(recruitItems)
    }
}
