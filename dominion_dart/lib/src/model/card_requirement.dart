part of dominion_dart;

class CardRequirement extends ManagedObject<_CardRequirement> implements _CardRequirement {}

class _CardRequirement {
  @managedPrimaryKey
  int id;

  @ManagedRelationship(#dependentCards, isRequired: true, onDelete: ManagedRelationshipDeleteRule.cascade)
  Card card;

  @ManagedRelationship(#requiredCards, isRequired: true, onDelete: ManagedRelationshipDeleteRule.cascade)
  Card requiredCard;
}
