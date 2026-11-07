# AGOT - Dragon Chronicles : plan des évènements

Sous-mod de *A Game of Thrones* (CK3). Coche `[x]` ce que tu veux garder / développer.

## ✅ Déjà codés (v0.1.0)

### Temps de paix (pulse annuel des cavaliers de dragon)
- [x] 1. **Une faim perdue** : le dragon refuse de manger (caprice, fièvre, ou maladie si on l'ignore)
- [x] 2. **Une ombre près du dragon** : espion autour de l'antre (garde, piège basé intrigue, laisser le dragon agir)
- [x] 3. **Les dieux et le dragon** : un prêtre veut bénir le dragon
- [x] 4. **Le savant et la bête** : un érudit de la Citadelle veut l'étudier
- [x] 5. **Un festin chez le voisin** : le dragon dévore le troupeau d'un voisin
- [x] 6. **Une forêt de brigands** : un vassal paie pour brûler une forêt
- [x] 7. **Dans l'œil de la tempête** : vol dans la tempête (XP dragon ou blessures)
- [x] 8. **Feu sur les flots** : le dragon incendie un navire pirate
- [x] 9. **La Fête du Dragon** : festival populaire dans la capitale

### Batailles (fin de combat, cavalier présent dans l'armée)
- [x] 10. **Les fuyards** (victoire) : brûler ou épargner l'armée en déroute
- [x] 11. **Le carreau de scorpion** (victoire) : dragon blessé, détruire la machine ?
- [x] 12. **Entre les crocs** (victoire) : le commandant ennemi à la merci du dragon
- [x] 13. **Le rugissement de la victoire** (victoire)
- [x] 14. **La fureur du dragon** (défaite) : le dragon brûle ses propres troupes
- [x] 15. **Désarçonné** (défaite) : le cavalier tombe de selle
- [x] 16. **Couvrir la retraite** (défaite)

## 💡 Suggestions à cocher

### Batailles / guerre
- [ ] 17. **Duel de feu au-dessus de l'armée** : deux dragons ennemis se croisent pendant la bataille (déclenche un mini-duel aérien)
- [ ] 18. **Pluie de feu sur le camp** : raid nocturne du dragon sur le camp ennemi avant la bataille (bonus d'avantage, malus moral)
- [ ] 19. **Le dragon mange les chevaux** : la cavalerie ennemie refuse de charger (bonus au prochain combat)
- [ ] 20. **Mutinerie de terreur** : des levées de votre propre armée désertent par peur du dragon
- [ ] 21. **Le chevalier tueur de dragons** : un champion ennemi se porte volontaire pour tuer votre dragon (duel au sol)
- [ ] 22. **Brûler les récoltes** : pendant une guerre, raser les champs ennemis (dévastation + dread, opinion des paysans)
- [ ] 23. **Siège : percer les murailles** : le dragon fait fondre une porte (progression de siège)
- [ ] 24. **Bataille navale** : le dragon attaque une flotte (côtes uniquement)
- [ ] 25. **Prisonnier dragonnier** : un cavalier ennemi capturé ; son dragon sans maître ravage la région

### Dragon & cavalier
- [ ] 26. **Le dragon jaloux** : le dragon attaque le nouvel époux/épouse du cavalier
- [ ] 27. **Rêve de feu** : rêve prophétique partagé avec le dragon (lien renforcé, trait « rêveur »)
- [ ] 28. **Le dragon vieillissant** : le dragon ralentit, chaîne sur sa fin de vie
- [ ] 29. **Rivalité entre dragons** : deux dragons de la même cour se battent dans la fosse
- [ ] 30. **L'héritier et le dragon** : un enfant de la cour s'attache au dragon du parent (pré-lien)
- [ ] 31. **Le dragon disparaît** : il s'envole plusieurs mois ; chaîne de recherche (retour, sauvage, ou mort)
- [ ] 32. **Des œufs volés** : un voleur s'introduit dans la fosse pour dérober des œufs

### Monde / politique
- [ ] 33. **Les sorciers de Qarth** : des envoyés offrent une fortune pour le dragon
- [ ] 34. **Ambassade terrifiée** : arriver à dos de dragon à une négociation (bonus/malus diplomatiques)
- [ ] 35. **Culte du dragon** : une secte naît dans vos terres et vénère votre dragon
- [ ] 36. **Le Pacte de la Foi** : la Foi Militante exige la mort du dragon
- [ ] 37. **Le dragon sauvage voisin** : un dragon sauvage s'installe à la frontière (chasser, apprivoiser, ignorer)
- [ ] 38. **Le tournoi aérien** : course de dragons organisée à la cour

## 🛠 Technique
- Namespaces : `agot_dc` (paix), `agot_dc_battle` (batailles)
- Fréquence : pulse annuel ~1 évènement / 3 ans par cavalier ; batailles 35 % de chance
- Localisation : français + anglais (même texte FR pour l'instant)
