class Item3Name {
  int item3NameID;
  int item2GroupID;
  String itemName;
  int clientID;
  int clientUserID;
  String netCode;
  String sysCode;
  double salePrice;
  String itemCode;
  double stock;
  String updatedDate;
  String itemStatus;
  String webUrl;
  int minimumStock;
  String itemDescription;
  int count = 0;
  addCount() => count = count + 1;
  addCountMass(int val) => count = count + val;
  subCount() => count = count - 1;
  Item3Name({
    required this.item3NameID,
    required this.item2GroupID,
    required this.itemName,
    required this.clientID,
    required this.clientUserID,
    required this.netCode,
    required this.sysCode,
    required this.salePrice,
    required this.itemCode,
    required this.stock,
    required this.updatedDate,
    required this.itemStatus,
    required this.webUrl,
    required this.minimumStock,
    required this.itemDescription,
    //count,
  });
}
