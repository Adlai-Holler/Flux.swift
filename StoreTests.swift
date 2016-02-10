//
//  StoreTests.swift
//  StoreTests
//
//  Created by Adlai Holler on 2/10/16.
//  Copyright © 2016 Adlai Holler. All rights reserved.
//

import XCTest
@testable import Flux

final class TestStore: Store<Int> {
	override init(dispatcher: Dispatcher<Int>) {
		super.init(dispatcher: dispatcher)
	}

	var _onDispatch: ((Int) -> Void)?
	override func onDispatch(payload: Int) {
		_onDispatch?(payload)
	}
}

final class TestStoreObserver {
	var onEvent: (Store<Int> -> Void)?

	init(store: Store<Int>) {
		store.addListener { store in
			self.onEvent?(store)
		}
	}
}

final class StoreTests: XCTestCase {

	func testThatItSendsChangeEventIfChanged() {
		let dispatcher = Dispatcher<Int>()
		let store = TestStore(dispatcher: dispatcher)
		let observer = TestStoreObserver(store: store)
		var gotEvent = false
		store._onDispatch = { value in
			store.setChanged()
		}
		observer.onEvent = { _ in
			gotEvent = true
		}
		dispatcher.dispatch(5)
		dispatch_sync(dispatcher.queue, {})
		XCTAssertTrue(gotEvent)
	}

	func testThatItDoesntSendChangeEventIfNotChanged() {
		let dispatcher = Dispatcher<Int>()
		let store = TestStore(dispatcher: dispatcher)
		let observer = TestStoreObserver(store: store)
		var gotEvent = false
		store._onDispatch = { value in
			// nop, store didn't change.
		}
		observer.onEvent = { _ in
			gotEvent = true
		}
		dispatcher.dispatch(5)
		dispatch_sync(dispatcher.queue, {})
		XCTAssertFalse(gotEvent)
	}


}
