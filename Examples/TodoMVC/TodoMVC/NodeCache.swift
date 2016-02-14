//
//  NodeCache.swift
//  TodoMVC
//
//  Created by Adlai Holler on 2/14/16.
//  Copyright © 2016 Adlai Holler. All rights reserved.
//

import Foundation
import AsyncDisplayKit

/// A protocol for caching ASCellNodes for reuse. ASDK is super fast, but 
/// in order to get decent performance with this functional paradigm
/// we need to reuse nodes when possible.
protocol NodeCache {
	func nodeForKey<Node: ASCellNode>(key: String, create: (String) -> Node) -> Node
	func existingNodeForKey<Node: ASCellNode>(key: String) -> Node?
}

/// A great way to make a node cache is with NSMapTable.strongToWeakObjectsMapTable
extension NSMapTable: NodeCache {
	func nodeForKey<Node : ASCellNode>(key: String, create: (String) -> Node) -> Node {
		if let existing = self.existingNodeForKey(key) as? Node {
			return existing
		}
		let new = create(key)
		setObject(new, forKey: key)
		return new
	}

	func existingNodeForKey<Node : ASCellNode>(key: String) -> Node? {
		return objectForKey(key) as! Node?
	}
}
