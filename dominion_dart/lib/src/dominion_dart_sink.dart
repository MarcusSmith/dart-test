part of dominion_dart;

class DominionDartConfiguration extends ConfigurationItem {
  DominionDartConfiguration(String fileName) : super.fromFile(fileName);

  DatabaseConnectionConfiguration database;
  int port;
}

class DominionDartSink extends RequestSink {
  static const String ConfigurationKey = "ConfigurationKey";
  static const String LoggingTargetKey = "LoggingTargetKey";

  DominionDartSink(Map<String, dynamic> opts) : super(opts) {
    configuration = opts[ConfigurationKey];

    LoggingTarget target = opts[LoggingTargetKey];
    target?.bind(logger);

    context = contextWithConnectionInfo(configuration.database);

    authenticationServer = new AuthServer<User, Token, AuthCode>(new DominionDartAuthenticationDelegate());
  }

  ManagedContext context;
  AuthServer<User, Token, AuthCode> authenticationServer;
  DominionDartConfiguration configuration;

  @override
  void setupRouter(Router router) {
    router
        .route("/auth/token")
        .pipe(new Authorizer(authenticationServer, strategy: AuthStrategy.client))
        .generate(() => new AuthController(authenticationServer));

    router
        .route("/auth/code")
        .pipe(new Authorizer(authenticationServer, strategy: AuthStrategy.client))
        .generate(() => new AuthCodeController(authenticationServer));

    router
        .route("/identity")
        .pipe(new Authorizer(authenticationServer))
        .generate(() => new IdentityController());

    router
        .route("/register")
        .pipe(new Authorizer(authenticationServer, strategy: AuthStrategy.client))
        .generate(() => new RegisterController());

    router
        .route("/users/[:id]")
        .pipe(new Authorizer(authenticationServer))
        .generate(() => new UserController());
  }

  ManagedContext contextWithConnectionInfo(DatabaseConnectionConfiguration database) {
    var connectionInfo = configuration.database;
    var dataModel = new ManagedDataModel.fromPackageContainingType(this.runtimeType);
    var psc = new PostgreSQLPersistentStore.fromConnectionInfo(connectionInfo.username,
        connectionInfo.password, connectionInfo.host, connectionInfo.port, connectionInfo.databaseName);

    var ctx = new ManagedContext(dataModel, psc);
    ManagedContext.defaultContext = ctx;

    return ctx;
  }

  @override
  Map<String, APISecurityScheme> documentSecuritySchemes(PackagePathResolver resolver) {
    return authenticationServer.documentSecuritySchemes(resolver);
  }

}
