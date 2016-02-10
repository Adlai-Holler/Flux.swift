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

}
