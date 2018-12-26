//
//  FavoriteController.swift
//  App
//
//  Created by wooky83 on 10/05/2018.
//

import Foundation
import Vapor

struct FavoriteController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("rest", "favorite")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<Favorite> {
        return try req.content.decode(Favorite.self).flatMap(to: Favorite.self) { user in
            return user.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Favorite]> {
        return Favorite.query(on: req).all()
    }
    
}
