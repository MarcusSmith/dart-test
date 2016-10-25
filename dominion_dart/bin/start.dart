import 'dart:async';
import 'dart:io';

import 'package:dominion_dart/dominion_dart.dart';

main() async {
  try {
    var configFileName = "config.yaml";
    var logPath = "api.log";

    var config = new DominionDartConfiguration(configFileName);
    var logger = new LoggingServer([new RotatingLoggingBackend(logPath)]);
    await logger.start();

    var app = new Application<DominionDartSink>();
    app.configuration.port = config.port;
    app.configuration.configurationOptions = {
      DominionDartSink.LoggingTargetKey : logger.getNewTarget(),
      DominionDartSink.ConfigurationKey : config
    };

    await app.start(numberOfInstances: 3);

    var signalPath = new File(".aqueductsignal");
    await signalPath.writeAsString("ok");
  } on ApplicationSupervisorException catch (e, st) {
    await writeError("IsolateSupervisorException, server failed to start: ${e.message} $st");
  } catch (e, st) {
    await writeError("Server failed to start: $e $st");
  }
}

Future writeError(String error) async {
  var file = new File("error.log");
  await file.writeAsString(error);
}
