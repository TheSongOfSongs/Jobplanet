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
    
    let disposeBag = DisposeBag()
    
    private let networkService = NetworkService()
    
    // MARK: -
    init() { }
    
    // MARK: -
    func transform(input: Input) -> Output {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let ids = self.fetchBookMarkedRecruitIds()
                let result = try await self.fetchRecruitItems()
                
                switch result {
                case .success(let items):
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
}

