//
//  WebsiteController.swift
//  App
//
//  Created by wooky83 on 26/12/2018.
//

import Foundation
import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    func boot(router: Router) throws {
        router.get(use: indexHandler)
    }
    
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        let context = IndexContext(title: "Wooky83")
        return try req.leaf().render("index", context)
    }
    
}

extension Request {
    func leaf() throws -> LeafRenderer {
        return try self.make(LeafRenderer.self)
    }
}

struct IndexContext: Encodable {
    let title: String
}
