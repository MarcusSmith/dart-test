import 'dart:async';
import 'dart:convert';

import 'package:args/args.dart';
import 'package:dominion_dart/dominion_dart.dart';

Future main(List<String> args) async {
  var argParser = new ArgParser()
    ..addOption("host", allowMultiple: true, help: "Scheme, host and port for available instances. Example: https://api.myapp.com:8000")
    ..addFlag("help", negatable: false, help: "Shows this documentation");

  var values = argParser.parse(args);
  if (values["help"]) {
    print(argParser.usage);
    return;
  }

  List<String> hostValues = values["host"] as List<String>;
  List<Uri> hosts = hostValues?.map((str) => Uri.parse(str))?.toList() ?? [];
  if (hosts.any((uri) => uri == null)) {
    print("Invalid host in $hostValues, must identity scheme, host and port. Example: https://api.myapp.com:8000");
    return;
  }

  var configuration = new DominionDartConfiguration("config.yaml.src");
  var app = new Application<DominionDartSink>()
    ..configuration.configurationOptions = {
      DominionDartSink.ConfigurationKey : configuration
    };

  var resolver = new PackagePathResolver(".packages");
  var document = app.document(resolver);
  document.hosts = hosts.map((uri) {
    return new APIHost()
        ..host = "${uri.host}:${uri.port}"
        ..scheme = uri.scheme;
  }).toList();

  var json = JSON.encode(document.asMap());
  print("$json");
}
