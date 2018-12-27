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
        router.get("key", use: keyValueHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        let context = IndexContext(title: "Wooky83")
        return try req.leaf().render("index", context)
    }
    
    func keyValueHandler(_ req: Request) throws -> Future<String> {
        let name = (try? req.query.get(String.self, at: "name")) ?? "Kwon"
        let age = (try? req.query.get(Int.self, at: "age")) ?? 20
        return req.future("name is \(name), age is \(age)")
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

struct KeyContext: Content {
    let name: String
}
