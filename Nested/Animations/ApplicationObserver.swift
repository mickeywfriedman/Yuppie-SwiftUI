//
//  ApplicationObserver.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import UIKit

internal protocol ApplicationObserverDelegate: class {
    func applicationWillEnterForeground()
    func applicationDidEnterBackground()
}

internal class ApplicationObserver {
    internal weak var delegate: ApplicationObserverDelegate?
    
    public init() {
        self.addApplicationObservers()
    }
    
    deinit {
        self.removeApplicationObservers()
    }

    private func addApplicationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func removeApplicationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationWillEnterForeground() {
        self.delegate?.applicationWillEnterForeground()
    }
    
    @objc private func applicationDidEnterBackground() {
        self.delegate?.applicationDidEnterBackground()
    }
}
