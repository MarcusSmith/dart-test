part of dominion_dart;

class Card extends ManagedObject<_Card> implements _Card {
  @managedTransientOutputAttribute
  List<String> get types => typeListString.split(",");

  @managedTransientInputAttribute
  void set types(List<String> l) {
    typeListString = l.join(",");
  }
}

class _Card {
  @managedPrimaryKey
  int id;

  @ManagedColumnAttributes(unique: true, indexed: true)
  String name;

  String typeListString;
  String description;

  @ManagedColumnAttributes(nullable: true)
  String imageURL;

  @ManagedColumnAttributes(nullable: true)
  int cost;

  @ManagedColumnAttributes(nullable: true)
  int value;

  @ManagedRelationship(#cards, isRequired: true, onDelete: ManagedRelationshipDeleteRule.cascade)
  CardSet set;

  @ManagedRelationship(#requiredCards, isRequired: false)
  CardSet requiredForSet;

  ManagedSet<CardRequirement> requiredCards;
  ManagedSet<CardRequirement> dependentCards;

  ManagedSet<KingdomCard> includedInKingdoms;
}
