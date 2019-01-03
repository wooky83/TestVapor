import FluentMySQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(AuthenticationProvider())

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    try services.register(LeafProvider())

    /// Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "wooky", password: "1234", database: "test")
//    let database = MySQLDatabase(config: mysqlConfig)
//    databases.add(database: database, as: .mysql)
//    services.register(databases)
//   
//    /// Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: User.self, database: .mysql)
//    migrations.add(model: Favorite.self, database: .mysql)
//    migrations.add(model: Todo.self, database: .mysql)
//    services.register(migrations)
//    
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)


}
