part of dominion_dart;

class Kingdom extends ManagedObject<_Kingdom> implements _Kingdom {

  @managedTransientOutputAttribute
  List<Card> get setOfTen {
    var cards = kingdomCards.map((kc) => kc.card).toList();
    cards.sort((c1, c2) => c1.id.compareTo(c2.id));
    return cards;
  }

  @managedTransientOutputAttribute
  List<CardSet> get requiredSets {
    var sets = setOfTen.map((c) => c.set);
    var uniqueSets = sets.fold(new List<CardSet>(), (List<CardSet> list, CardSet set) {
      var setIDs = list.map((s) => s.id);

      if (!setIDs.contains(set.id)) {
        list.add(set);
      }

      return list;
    });

    uniqueSets.sort((s1, s2) => s1.id.compareTo(s2.id));

    return uniqueSets;
  }

  @managedTransientOutputAttribute
  List<Card> get supportCards {
    List<Card> requiredCards = setOfTen.map((c) => c.requiredCards.map((r) => r.requiredCard)).expand((l) => l);
    requiredCards.addAll(requiredSets.map((s) => s.requiredCards).expand((l) => l));
    requiredCards.fold(new List<Card>(), (List<Card> list, Card card) {
      var cardIDs = list.map((c) => c.id);

      if (!cardIDs.contains(card.id)) {
        list.add(card);
      }

      return list;
    });

    requiredCards.sort((c1, c2) => c1.id.compareTo(c2.id));

    return requiredCards;
  }
}

class _Kingdom {
  @managedPrimaryKey
  int id;

  @ManagedColumnAttributes(unique: true, indexed: true)
  String name;

  ManagedSet<KingdomCard> kingdomCards;
}
