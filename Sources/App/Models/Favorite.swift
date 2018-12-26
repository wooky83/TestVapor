//
//  Favorite.swift
//  App
//
//  Created by wooky83 on 10/05/2018.
//

import Foundation
import FluentMySQL
import Vapor

final class Favorite: Codable {
    var id: Int?
    var userId: User.ID
    var car: String
    var hobby: String
    
    init(userId: User.ID, car: String, hobby: String) {
        self.userId = userId
        self.car = car
        self.hobby = hobby
    }
}

extension Favorite: MySQLModel {}
extension Favorite: Migration {}
extension Favorite: Content {}
