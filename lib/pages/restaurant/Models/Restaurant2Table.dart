class Restaurant2Table {
  //int iD;
  int tableID;
  int portionID;
  String tableName;
  String tableDescription;
  String tableStatus;
  int clientID;
  int clientUserID;
  String netCode;
  String sysCode;
  String updatedDate;
  int salPur1ID;

  Restaurant2Table({
    //required this.iD,
    required this.tableID,
    required this.portionID,
    required this.tableName,
    required this.tableDescription,
    required this.tableStatus,
    required this.clientID,
    required this.clientUserID,
    required this.netCode,
    required this.sysCode,
    required this.updatedDate,
    required this.salPur1ID,
  });
}
