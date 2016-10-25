import 'package:dominion_dart/dominion_dart.dart';
import 'package:scribe/scribe.dart';
import 'dart:async';

class TestApplication {
  TestApplication() {
    configuration = new DominionDartConfiguration("config.yaml.src");
    configuration.database.isTemporary = true;
  }

  Application<DominionDartSink> application;
  DominionDartSink get sink => application.mainIsolateSink;
  LoggingServer logger = new LoggingServer([]);
  TestClient client;
  DominionDartConfiguration configuration;

  Future start() async {
    await logger.start();

    application = new Application<DominionDartSink>();
    application.configuration.configurationOptions = {
      DominionDartSink.ConfigurationKey: configuration,
      DominionDartSink.LoggingTargetKey : logger.getNewTarget()
    };

    await application.start(runOnMainIsolate: true);

    ManagedContext.defaultContext = sink.context;

    await createDatabaseSchema(sink.context, sink.logger);
    await addClientRecord();

    client = new TestClient(application)
      ..clientID = "com.aqueduct.test"
      ..clientSecret = "kilimanjaro";
  }

  Future stop() async {
    await sink.context.persistentStore?.close();
    await logger?.stop();
    await application?.stop();
  }

  static Future addClientRecord({String clientID: "com.aqueduct.test", String clientSecret: "kilimanjaro"}) async {
    var salt = AuthServer.generateRandomSalt();
    var hashedPassword = AuthServer.generatePasswordHash(clientSecret, salt);
    var testClientRecord = new ClientRecord();
    testClientRecord.id = clientID;
    testClientRecord.salt = salt;
    testClientRecord.hashedPassword = hashedPassword;

    var clientQ = new Query<ClientRecord>()
      ..values.id = clientID
      ..values.salt = salt
      ..values.hashedPassword = hashedPassword;
    await clientQ.insert();
  }

  static Future createDatabaseSchema(ManagedContext context, Logger logger) async {
    var builder = new SchemaBuilder.toSchema(context.persistentStore, new Schema.fromDataModel(context.dataModel), isTemporary: true);

    for (var cmd in builder.commands) {
      logger?.info("$cmd");
      await context.persistentStore.execute(cmd);
    }
  }
}