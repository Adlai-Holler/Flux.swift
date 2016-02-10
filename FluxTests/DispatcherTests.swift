//
//  FluxTests.swift
//  FluxTests
//
//  Created by Adlai Holler on 2/10/16.
//  Copyright © 2016 Adlai Holler. All rights reserved.
//

import XCTest
@testable import Flux

final class DispatcherTests: XCTestCase {

	func testThatItDispatchesTheGivenPayload() {
		let dispatcher = Dispatcher<Int>()
		var received1: Int?
		dispatcher.register { value in
			received1 = value
		}
		var received2: Int?
		dispatcher.register { value in
			received2 = value
		}
		let sent = 5
		dispatcher.dispatch(sent)
		dispatch_sync(dispatcher.queue, {})
		XCTAssertEqual(received1, sent)
		XCTAssertEqual(received2, sent)
	}

	func testThatWaitForWorks() {
		let dispatcher = Dispatcher<Int>()
		let sent = 5
		var received1: Int?
		let token1 = dispatcher.register { value in
			received1 = value
		}
		dispatcher.register { value in
			XCTAssertEqual(received1, nil)
			dispatcher.waitFor([token1])
			XCTAssertEqual(received1, sent)
		}
		dispatcher.dispatch(sent)
		dispatch_sync(dispatcher.queue, {})
	}

	func testThatItDetectsCircularDependenciesInWaitFor() {
		let dispatcher = Dispatcher<Int>()
		var gotAssertionFailure = false
		dispatcher.testAssertionHandler = {
			gotAssertionFailure = true
		}
		let sent = 5
		var token2: DispatchToken?
		let token1 = dispatcher.register { value in
			dispatcher.waitFor([token2!])
		}
		token2 = dispatcher.register { value in
			dispatcher.waitFor([token1])
		}
		dispatcher.dispatch(sent)
		dispatch_sync(dispatcher.queue, {})
		XCTAssertTrue(gotAssertionFailure)
	}

	func testThatUnregisteringANonexistantObserverThrows() {
		let dispatcher = Dispatcher<Int>()
		var gotAssertionFailure = false
		dispatcher.testAssertionHandler = {
			gotAssertionFailure = true
		}
		dispatcher.unregister(0)
		dispatch_sync(dispatcher.queue, {})
		XCTAssertTrue(gotAssertionFailure)
	}

}
