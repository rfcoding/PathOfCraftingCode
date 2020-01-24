import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/item/normal_item.dart';
import 'package:poe_clicker/repository/item_repo.dart';
import 'package:poe_clicker/widgets/craft/crafting_widget.dart';
import 'package:poe_clicker/widgets/utils.dart';

import 'item/item.dart';
import 'item/magic_item.dart';
import 'item/rare_item.dart';

abstract class CraftingOrb {
  String imagePath;
  String description;

  CraftingOrb({this.imagePath, this.description});

  Widget getWidget(Item item, CraftingWidgetState state) {
    return imageButton(imagePath, description, () => useOnItem(item, state));
  }

  void useOnItem(Item item, CraftingWidgetState state);
}

class Scouring extends CraftingOrb {
  Scouring()
      : super(imagePath: "assets/images/scour.png", description: "Orb of Scouring");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    if (item is RareItem) {
      state.craftingUsedOnItem(item.scour(), this);
    } else if (item is MagicItem) {
      state.craftingUsedOnItem(item.scour(), this);
    }
  }
}

class AnnulmentOrb extends CraftingOrb {
  AnnulmentOrb()
      : super(
            imagePath: "assets/images/annulment.png", description: "Orb of Annulment");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    if (item is MagicItem) {
      state.craftingUsedOnItem(item.annulment(), this);
    } else if (item is RareItem) {
      state.craftingUsedOnItem(item.annulment(), this);
    }
  }
}

class ChaosOrb extends CraftingOrb {
  ChaosOrb()
      : super(imagePath: "assets/images/chaos.png", description: "Chaos Orb");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as RareItem).chaos(), this);
  }
}

class ExaltedOrb extends CraftingOrb {
  ExaltedOrb()
      : super(imagePath: "assets/images/exalted.png", description: "Exalted Orb");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    if (item.influenceTags.isEmpty && ItemRepository.instance.itemCanHaveInfluence(item.itemClass)) {
      state.showExaltMenu(item, this);
    } else {
      state.craftingUsedOnItem((item as RareItem).exalt(), this);
    }
  }
}

class VaalOrb extends CraftingOrb {
  VaalOrb()
      : super(imagePath: "assets/images/vaal.png", description: "Vaal Orb");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as RareItem).corrupt(), this);
  }
}

class DivineOrb extends CraftingOrb {
  DivineOrb()
      : super(imagePath: "assets/images/divine.png", description: "Divine Orb");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem(item.divine(), this);
  }
}

class AlterationOrb extends CraftingOrb {
  AlterationOrb()
      : super(
            imagePath: "assets/images/alteration.png",
            description: "Orb of Alteration");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as MagicItem).alteration(), this);
  }
}

class AugmentationOrb extends CraftingOrb {
  AugmentationOrb()
      : super(
            imagePath: "assets/images/augmentation.png",
            description: "Orb of Augmentation");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as MagicItem).augment(), this);
  }
}

class RegalOrb extends CraftingOrb {
  RegalOrb()
      : super(imagePath: "assets/images/regal.png", description: "Regal Orb");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as MagicItem).regal(), this);
  }
}

class TransmutationOrb extends CraftingOrb {
  TransmutationOrb()
      : super(
            imagePath: "assets/images/transmute.png",
            description: "Orb of Transmutation");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as NormalItem).transmute(), this);
  }
}

class AlchemyOrb extends CraftingOrb {
  AlchemyOrb()
      : super(
            imagePath: "assets/images/alchemy.png",
            description: "Orb of Alchemy");

  @override
  void useOnItem(Item item, CraftingWidgetState state) {
    state.craftingUsedOnItem((item as NormalItem).alchemy(), this);
  }
}
