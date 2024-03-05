

class ModelSaleItemQuantity {
  late String _itemID;
  late String _itemName;
  late String _quantity;
  late String _price;
  late String _total;

  static const String itemIDKey = 'ItemID';
  static const String itemNameKey = 'ItemName';
  static const String quantityKey = 'quantity';
  static const String priceKey = 'Price';
  static const String totalKey = 'total';

  ModelSaleItemQuantity({
    required String itemID,
    required String itemName,
    required String quantity,
    required String price,
    required String total,
  })  : _itemID = itemID,
        _itemName = itemName,
        _price = price,
        _quantity = quantity,
        _total = total;

  String get total => _total;

  set total(String value) {
    _total = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get quantity => _quantity;

  set quantity(String value) {
    _quantity = value;
  }

  String get itemName => _itemName;

  set itemName(String value) {
    _itemName = value;
  }

  String get itemID => _itemID;

  set itemID(String value) {
    _itemID = value;
  }

  Map<String, dynamic> toMap() {
    return {
      itemIDKey: itemID,
      itemNameKey: itemName,
      priceKey: price,
      quantityKey: quantity,
      totalKey: total
    };
  }
}
