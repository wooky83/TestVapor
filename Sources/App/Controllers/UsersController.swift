//
//  UsersController.swift
//  App
//
//  Created by wooky83 on 09/05/2018.
//

import Foundation
import Vapor
import Authentication

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("rest", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(User.parameter, "favorites", use: getFavoritesHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self) { user in
            let hasher = try req.make(BCryptDigest.self)
            user.password = try hasher.hash(user.password)
            return user.save(on: req)
        }
    }
    
    //http://localhost:8080/rest/users/
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    //http://localhost:8080/rest/users/2409C30E-065F-413E-B7BA-04592BC98641/favorites
    func getFavoritesHandler(_ req: Request) throws -> Future<[Favorite]> {
        return try req.parameters.next(User.self).flatMap(to: [Favorite].self) { user in
            return try user.favorites.query(on: req).all()
        }
    }
}
