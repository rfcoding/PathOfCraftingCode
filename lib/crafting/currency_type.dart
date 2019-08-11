class CurrencyType {
  static final String exalt = "exalt";
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

  static final Map<String, String> idToCurrency = {
    "Metadata/Items/Currency/CurrencyAddModToRare" : exalt,
    "Metadata/Items/Currency/CurrencyAddModToMagic": divine,
    "Metadata/Items/Currency/CurrencyRemoveMod": annulment,
    "Metadata/Items/Currency/CurrencyRerollRare": chaos,
    "Metadata/Items/Currency/CurrencyConvertToNormal": regal,
    "Metadata/Items/Currency/CurrencyUpgradeToRare": alchemy,
    "Metadata/Items/Currency/CurrencyConvertToNormal": scour,
    "Metadata/Items/Currency/CurrencyRerollMagic": alteration,
    "Metadata/Items/Currency/CurrencyAddModToMagic": augmentation,
    "Metadata/Items/Currency/CurrencyUpgradeToMagic": transmute,
    "Metadata/Items/Currency/CurrencyUpgradeRandomly": chance,
  };

  static final Map<String, String> idToImagePath = {
    "Metadata/Items/Currency/CurrencyAddModToRare" : 'assets/images/exalt.png',
    "Metadata/Items/Currency/CurrencyAddModToMagic": 'assets/images/divine.png',
    "Metadata/Items/Currency/CurrencyRemoveMod": 'assets/images/annulment.png',
    "Metadata/Items/Currency/CurrencyRerollRare": 'assets/images/chaos.png',
    "Metadata/Items/Currency/CurrencyConvertToNormal": 'assets/images/regal.png',
    "Metadata/Items/Currency/CurrencyUpgradeToRare": 'assets/images/alchemy.png',
    "Metadata/Items/Currency/CurrencyConvertToNormal": 'assets/images/scour.png',
    "Metadata/Items/Currency/CurrencyRerollMagic": 'assets/images/alteration.png',
    "Metadata/Items/Currency/CurrencyAddModToMagic": 'assets/images/augmentation.png',
    "Metadata/Items/Currency/CurrencyUpgradeToMagic": 'assets/images/transmute.png',
    "Metadata/Items/Currency/CurrencyUpgradeRandomly": 'assets/images/transmute.png' //TODO: chance orb
  };
}
