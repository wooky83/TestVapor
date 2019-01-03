import Vapor
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hash", String.parameter) { req -> String in
        let string = try req.parameters.next(String.self)
        let hasher = try BCrypt.hash(string)
        return hasher
    }

    // Example of configuring a controller
//    let todoController = TodoController()
//    router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.post("info") { req -> Future<InfoResponse> in
        return try req.content.decode(InfoData.self).map(to: InfoResponse.self) { data in
            return InfoResponse(request: data)
        }
    }
    
    router.post("user-info") { req -> Future<String> in
        return try req.content.decode(UserInfo.self).map(to: String.self) { userInfo in
            return "Hello \(userInfo.name), you are \(userInfo.age)!"
        }
    }
    
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    let favoriteController = FavoriteController()
    try router.register(collection: favoriteController)
    
    let websiteController = WebsiteController()
    try router.register(collection: websiteController)
    
    let authController = AuthController()
    try router.register(collection: authController)
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

struct UserInfo: Content {
    let name: String
    let age: Int
}
