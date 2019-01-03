//
//  AuthController.swift
//  App
//
//  Created by baw0803 on 03/01/2019.
//

import Foundation
import Vapor
import Authentication

struct AuthController: RouteCollection {
    
    func boot(router: Router) throws {
        let usersRoutes = router.grouped("auth", "users")
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.get("basic", use: basicHandler)
    }
    
    func basicHandler(_ req: Request) throws -> Future<String> {
        let user = try req.requireAuthenticated(User.self)
        return req.future("hello, \(user.name)")
    }
    
}
