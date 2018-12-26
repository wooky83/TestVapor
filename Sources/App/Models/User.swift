//
//  User.swift
//  App
//
//  Created by wooky83 on 09/05/2018.
//

import Foundation
import FluentMySQL
import Vapor

final class User: Codable {
    var id: UUID?
    var name: String
    var birthday: Int
    var rate: Int
    
    init(name: String, birthday: Int, rate: Int) {
        self.name = name
        self.birthday = birthday
        self.rate = rate
    }
}

extension User: MySQLUUIDModel {}
extension User: Migration {}
extension User: Content {}
extension User: Parameter {}
extension User {
    var favorites: Children<User, Favorite> {
        return children(\.userId)
    }
}
