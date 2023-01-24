//
//  NetworkConnectionManager.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import Foundation
import Network

/// 네트워크 연결 여부를 감시하는 싱글톤 매니저
final class NetworkConnectionManager {
    
    static let shared = NetworkConnectionManager()
    
    private let queue = DispatchQueue.global()
    private let connectionMonitor: NWPathMonitor
    private var _isReachable = true
    
    var isReachable: Bool {
        return _isReachable
    }
    
    // MARK: - init
    private init () {
        connectionMonitor = NWPathMonitor()
    }
    
    // MARK: - Implements
    public func startMonitoring() {
        connectionMonitor.start(queue: queue)
        connectionMonitor.pathUpdateHandler = { [weak self] path in
            self?._isReachable = path.status == .satisfied
        }
    }
    
    public func stopMonitoring() {
        connectionMonitor.cancel()
    }
}
