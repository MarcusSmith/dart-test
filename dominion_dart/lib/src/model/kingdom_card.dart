part of dominion_dart;

class KingdomCard extends ManagedObject<_KingdomCard> implements _KingdomCard {}

class _KingdomCard {
  @managedPrimaryKey
  int id;

  @ManagedRelationship(#includedInKingdoms, isRequired: true, onDelete: ManagedRelationshipDeleteRule.cascade)
  Card card;

  @ManagedRelationship(#kingdomCards, isRequired: true, onDelete: ManagedRelationshipDeleteRule.cascade)
  Kingdom kingdom;
}
