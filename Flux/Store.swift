//
//  Store.swift
//  Flux
//
//  Created by Adlai Holler on 2/10/16.
//  Copyright © 2016 Adlai Holler. All rights reserved.
//

import Foundation

public typealias StoreObserverToken = NSObjectProtocol

public class Store<DispatchPayload> {

    /// FIXME: Use a stored property when compiler supports them.
    static var changeNotificationName: String {
        return "Store.changeNotificationName"
    }

    public let dispatcher: Dispatcher<DispatchPayload>
    public private(set) var dispatchToken: DispatchToken!
    private(set) var changed = false {
        willSet {
            assert(dispatcher.isDispatching, "changed must be set during a dispatch.")
        }
    }

    public init(dispatcher: Dispatcher<DispatchPayload>) {
        self.dispatcher = dispatcher
        dispatchToken = dispatcher.register { [weak self] in
            self?.invokeOnDispatch($0)
        }
    }

    public final func addListener(callback: (Store<DispatchPayload> -> Void)) -> StoreObserverToken {
        return NSNotificationCenter.defaultCenter().addObserverForName(Store.changeNotificationName, object: self, queue: nil, usingBlock: { [unowned self] _ in
            callback(self)
        })
    }

    public final func removeListener(token: StoreObserverToken) {
        NSNotificationCenter.defaultCenter().removeObserver(token)
    }

    final func invokeOnDispatch(payload: DispatchPayload) {
        changed = false
        onDispatch(payload)
        if changed {
            NSNotificationCenter.defaultCenter().postNotificationName(Store.changeNotificationName, object: self)
        }
    }

    public final func setChanged() {
        changed = true
    }

    public func onDispatch(payload: DispatchPayload) {
        assertionFailure("\(self.dynamicType) must override `onDispatch`.")
    }

}
