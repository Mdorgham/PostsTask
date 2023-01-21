//
//  ConnectionManager.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation
import Combine
import Reachability

class ConnectionManager: NSObject {
    
    var cancellable: Set<AnyCancellable> = []

    private override init() {
        super.init()
        startListening()
        setupReachability()
    }
    deinit {
        stopListening()
    }
    @Published private (set) var isConnected: Bool = true
    private static let _shared = ConnectionManager()

    class func shared() -> ConnectionManager {
        return _shared
    }

    private let reachability = try! Reachability()

    var isNetworkAvailable: Bool {
        return reachability.connection != .unavailable
    }


    private func setupReachability() {
        self.isConnected = isNetworkAvailable
        NotificationCenter
            .default
            .publisher(for: .reachabilityChanged, object: reachability)
            .sink { _ in } receiveValue: { [weak self] note in
                let reachability = note.object as! Reachability
                switch reachability.connection{
                case .unavailable:
                    self?.isConnected = false
                default:
                    self?.isConnected = true
                }
            }
            .store(in: &cancellable)
    }

    func startListening() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    func stopListening() {
        reachability.stopNotifier()
    }
}

