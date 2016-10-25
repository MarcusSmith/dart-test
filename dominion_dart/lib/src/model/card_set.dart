part of dominion_dart;

class CardSet extends ManagedObject<_CardSet> implements _CardSet {}

class _CardSet {
  @managedPrimaryKey
  int id;

  @ManagedColumnAttributes(unique: true, indexed: true)
  String name;

  @ManagedColumnAttributes(nullable: true)
  String imageURL;

  ManagedSet<Card> cards;
  ManagedSet<Card> requiredCards;
}
