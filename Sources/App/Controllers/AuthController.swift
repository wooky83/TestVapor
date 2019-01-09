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
        //API Stateless
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let usersRoutes = router.grouped("auth", "users")
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.get("basic", use: basicHandler)
        basicAuthGroup.get("test", use: testHandler)
        //Web Sessions
        let authSessionsRoutes = router.grouped(User.authSessionsMiddleware())
        authSessionsRoutes.get("login", use: loginHandler)
        authSessionsRoutes.post("login", use: loginPostHandler)
        let protectedRoutes = authSessionsRoutes.grouped(RedirectMiddleware<User>(path: "/login"))
        protectedRoutes.get("auth", "middleware",use: middleHandler)
    }
    
    //wooky, 1234
    func basicHandler(_ req: Request) throws -> Future<String> {
        let user = try req.requireAuthenticated(User.self)
        return req.future("hello, \(user.name)")
    }
    
    func testHandler(_ req: Request) throws -> Future<String> {
        return req.future("Test Success!!")
    }
    
    func middleHandler(_ req: Request) throws -> Future<String> {
        return req.future("MiddleHandler Success!!")
    }
    
    func loginHandler(_ req: Request) throws -> Future<View> {
        return try req.leaf().render("login")
    }
    
    func loginPostHandler(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(LoginPostData.self).flatMap(to: Response.self) { data in
            let verifier = try req.make(BCryptDigest.self)
            return User.authenticate(username: data.username, password: data.password, using: verifier, on: req).map(to: Response.self) { user in
                guard let user = user else {
                    return req.redirect(to: "/login")
                }
                try req.authenticateSession(user)
                return req.redirect(to: "/")
            }
        }
    }
    
}

struct LoginPostData: Content {
    let username: String
    let password: String
}
