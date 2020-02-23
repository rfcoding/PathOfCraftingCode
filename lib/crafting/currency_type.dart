import 'package:poe_clicker/repository/item_repo.dart';

class CurrencyType {
  static final String exalt = "exalt";
  static final String hunterExalt = "hunterExalt";
  static final String crusaderExalt = "crusaderExalt";
  static final String redeemerExalt = "redeemerExalt";
  static final String warlordExalt = "warlordExalt";
  static final String divine = "divine";
  static final String annulment = "annulment";
  static final String chaos = "chaos";
  static final String regal = "regal";
  static final String alchemy = "alchemy";
  static final String scour = "scour";
  static final String alteration = "alteration";
  static final String augmentation = "augmentation";
  static final String transmute = "transmute";
  static final String chance = "chance";
  static final String blessed = "blessed";
  static final String regret = "regret";
  static final String vaal = "vaal";
  static final String gcp = "gcp";
  static final String glassblower = "glassblower";
  static final String armourers = "armourers";
  static final String whetstone = "whetstone";
  static final String fusing = "fusing";

  static final Map<String, String> idToCurrency = {
    "Metadata/Items/Currency/CurrencyAddModToRare" : exalt,
    "Metadata/Items/AtlasExiles/AddModToRareHunter" : hunterExalt,
    "Metadata/Items/AtlasExiles/AddModToRareCrusader" : crusaderExalt,
    "Metadata/Items/AtlasExiles/AddModToRareRedeemer" : redeemerExalt,
    "Metadata/Items/AtlasExiles/AddModToRareWarlord" : warlordExalt,
    "Metadata/Items/Currency/CurrencyModValues": divine,
    "Metadata/Items/Currency/CurrencyRemoveMod": annulment,
    "Metadata/Items/Currency/CurrencyRerollRare": chaos,
    "Metadata/Items/Currency/CurrencyUpgradeMagicToRare": regal,
    "Metadata/Items/Currency/CurrencyUpgradeToRare": alchemy,
    "Metadata/Items/Currency/CurrencyConvertToNormal": scour,
    "Metadata/Items/Currency/CurrencyRerollMagic": alteration,
    "Metadata/Items/Currency/CurrencyAddModToMagic": augmentation,
    "Metadata/Items/Currency/CurrencyUpgradeToMagic": transmute,
    "Metadata/Items/Currency/CurrencyUpgradeRandomly": chance,
    "Metadata/Items/Currency/CurrencyRerollImplicit": blessed,
    "Metadata/Items/Currency/CurrencyPassiveRefund": regret,
    "Metadata/Items/Currency/CurrencyCorrupt": vaal,
    "Metadata/Items/Currency/CurrencyGemQuality": gcp,
    "Metadata/Items/Currency/CurrencyFlaskQuality": glassblower,
    "Metadata/Items/Currency/CurrencyArmourQuality": armourers,
    "Metadata/Items/Currency/CurrencyWeaponQuality": whetstone,
    "Metadata/Items/Currency/CurrencyRerollSocketLinks": fusing,
  };

  static final Map<String, String> idToImagePath = {
    "Metadata/Items/Currency/CurrencyAddModToRare" : 'assets/images/exalted.png',
    "Metadata/Items/Currency/CurrencyModValues": 'assets/images/divine.png',
    "Metadata/Items/Currency/CurrencyRemoveMod": 'assets/images/annulment.png',
    "Metadata/Items/Currency/CurrencyRerollRare": 'assets/images/chaos.png',
    "Metadata/Items/Currency/CurrencyUpgradeMagicToRare": 'assets/images/regal.png',
    "Metadata/Items/Currency/CurrencyUpgradeToRare": 'assets/images/alchemy.png',
    "Metadata/Items/Currency/CurrencyConvertToNormal": 'assets/images/scour.png',
    "Metadata/Items/Currency/CurrencyRerollMagic": 'assets/images/alteration.png',
    "Metadata/Items/Currency/CurrencyAddModToMagic": 'assets/images/augmentation.png',
    "Metadata/Items/Currency/CurrencyUpgradeToMagic": 'assets/images/transmute.png',
    "Metadata/Items/Currency/CurrencyUpgradeRandomly": 'assets/images/chance.png',
    "Metadata/Items/Currency/CurrencyRerollImplicit": 'assets/images/blessed.png',
    "Metadata/Items/Currency/CurrencyPassiveRefund": 'assets/images/regret.png',
    "Metadata/Items/Currency/CurrencyCorrupt": 'assets/images/vaal.png',
    "Metadata/Items/Currency/CurrencyGemQuality": 'assets/images/gcp.png',
    "Metadata/Items/Currency/CurrencyFlaskQuality": 'assets/images/glassblower.png',
    "Metadata/Items/Currency/CurrencyArmourQuality": 'assets/images/armourers.png',
    "Metadata/Items/Currency/CurrencyWeaponQuality": 'assets/images/whetstone.png',
    "Metadata/Items/Currency/CurrencyRerollSocketLinks": 'assets/images/fusing.png'
  };

  static final Map<String, String> currencyToId = {
    exalt: "Metadata/Items/Currency/CurrencyAddModToRare",
    hunterExalt : "Metadata/Items/AtlasExiles/AddModToRareHunter",
    crusaderExalt : "Metadata/Items/AtlasExiles/AddModToRareCrusader",
    redeemerExalt : "Metadata/Items/AtlasExiles/AddModToRareRedeemer",
    warlordExalt : "Metadata/Items/AtlasExiles/AddModToRareWarlord",
    divine: "Metadata/Items/Currency/CurrencyModValues",
    annulment: "Metadata/Items/Currency/CurrencyRemoveMod",
    chaos: "Metadata/Items/Currency/CurrencyRerollRare",
    regal: "Metadata/Items/Currency/CurrencyUpgradeMagicToRare",
    alchemy: "Metadata/Items/Currency/CurrencyUpgradeToRare",
    scour: "Metadata/Items/Currency/CurrencyConvertToNormal",
    alteration: "Metadata/Items/Currency/CurrencyRerollMagic",
    augmentation: "Metadata/Items/Currency/CurrencyAddModToMagic",
    transmute: "Metadata/Items/Currency/CurrencyUpgradeToMagic",
    chance: "Metadata/Items/Currency/CurrencyUpgradeRandomly",
    blessed: "Metadata/Items/Currency/CurrencyRerollImplicit",
    regret: "Metadata/Items/Currency/CurrencyPassiveRefund",
    vaal: "Metadata/Items/Currency/CurrencyCorrupt",
    gcp: "Metadata/Items/Currency/CurrencyGemQuality",
    glassblower: "Metadata/Items/Currency/CurrencyFlaskQuality",
    armourers: "Metadata/Items/Currency/CurrencyArmourQuality",
    whetstone: "Metadata/Items/Currency/CurrencyWeaponQuality",
    fusing: "Metadata/Items/Currency/CurrencyRerollSocketLinks"
  };

  static String getDisplayName(String currency) {
    return ItemRepository.instance.baseItemMap[currencyToId[currency]].name;
  }
}
