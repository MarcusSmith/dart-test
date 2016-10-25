import 'package:aqueduct/aqueduct.dart';
import 'dart:async';

class Migration1 extends Migration {
  Future upgrade() async {
    database.createTable(new SchemaTable("_User", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("email", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
      new SchemaColumn("hashedPassword", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("salt", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_Client", [
      new SchemaColumn("id", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("hashedPassword", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("salt", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_Kingdom", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
    ]));

    database.createTable(new SchemaTable("_CardSet", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
      new SchemaColumn("imageURL", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_Token", [
      new SchemaColumn("accessToken", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("refreshToken", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false),
      new SchemaColumn("issueDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("expirationDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("type", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("client", ManagedPropertyType.string, relatedTableName: "_Client", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: true, isUnique: false),
      new SchemaColumn.relationship("owner", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: true, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_AuthCode", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("code", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false),
      new SchemaColumn("redirectURI", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
      new SchemaColumn("clientID", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("resourceOwnerIdentifier", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("issueDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("expirationDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("token", ManagedPropertyType.string, relatedTableName: "_Token", relatedColumnName: "accessToken", rule: ManagedRelationshipDeleteRule.cascade, isNullable: true, isUnique: true),
    ]));

    database.createTable(new SchemaTable("_Card", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
      new SchemaColumn("typeListString", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("imageURL", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
      new SchemaColumn("cost", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
      new SchemaColumn("value", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
      new SchemaColumn.relationship("set", ManagedPropertyType.bigInteger, relatedTableName: "_CardSet", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("requiredForSet", ManagedPropertyType.bigInteger, relatedTableName: "_CardSet", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.nullify, isNullable: true, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_CardRequirement", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("card", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("requiredCard", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: false, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_KingdomCard", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("card", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("kingdom", ManagedPropertyType.bigInteger, relatedTableName: "_Kingdom", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.cascade, isNullable: false, isUnique: false),
    ]));

  }

  Future downgrade() async {
  }
  Future seed() async {
  }
}
