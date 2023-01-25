//
//  MyViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MyViewModel: ViewModel {
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
                // 북마크된 채용 아이템 Id를 UserDefaults에서 가져오고
                // 채용 정보를 API로부터 받아온 후, 채용정보 아이템에 북마크 여부를 업데이트 시켜줌
                let ids = self.fetchBookMarkedRecruitItemIds()
                let result = try await self.fetchRecruitItems()
                
                switch result {
                case .success(let items):
                    self.recruitItems = items
                    
                    let items =  self.filter(items, with: ids)
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
    
    /// 채용 API로부터 데이터를 받아와 결과값을 전달하는 메서드
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
    
    /// UserDefaults에 저장된 채용아이템 Id를 배열 형태로 가져오는 메서드
    private func fetchBookMarkedRecruitItemIds() -> [Int] {
        let ids = UserDefaultsHelper.getData(type: [Int].self, forKey: .recruitIdsBookMarkOn) ?? []
        self.bookMarkedRecruitItemIds = ids
        return ids
    }
    
    // 채용 아이템을 id로 필터링하여 반환하는 메서드
    private func filter(_ recruitItems: [RecruitItem], with ids: [Int]) -> [RecruitItem] {
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
        
        let ids = fetchBookMarkedRecruitItemIds()
        let recruitItems = filter(recruitItems, with: ids)
        bookedRecruitItemsRelay.accept(recruitItems)
    }
}
