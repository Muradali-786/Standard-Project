
import 'dart:convert';

List<Account4UserRightsModel> account4UserRightsModelFromJson(String str) => List<Account4UserRightsModel>.from(json.decode(str).map((x) => Account4UserRightsModel.fromJson(x)));

String account4UserRightsModelToJson(List<Account4UserRightsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Account4UserRightsModel {
  Account4UserRightsModel({
    required this.id,
    required this.userRightsId,
    required this.account3Id,
    required this.menuName,
    required this.inserting,
    required this.edting,
    required this.deleting,
    required this.reporting,
    required this.view,
    required this.clientId,
    required this.clientUserId,
    required this.netCode,
    required this.sysCode,
    required this.updateDate,
    required this.sortBy,
    required this.groupSortBy,
  });



  int id;
  int userRightsId;
  String account3Id;
  String menuName;
  String inserting;
  String edting;
  String deleting;
  String reporting;
  String view;
  int clientId;
  int clientUserId;
  String netCode;
  String sysCode;
  String? updateDate = '';
  String sortBy;
  String groupSortBy;

  factory Account4UserRightsModel.fromJson(Map<String, dynamic> json) => Account4UserRightsModel(
    id: json["ID"],
    userRightsId: json["UserRightsID"],
    account3Id: json["Account3ID"],
    menuName: json["MenuName"],
    inserting: json["Inserting"],
    edting: json["Edting"],
    view  : json["Viwe"],
    deleting: json["Deleting"],
    reporting: json["Reporting"],
    clientId: json["ClientID"],
    clientUserId: json["ClientUserID"],
    netCode: json["NetCode"],
    sysCode: json["SysCode"],
    updateDate: '',
    sortBy: json["SortBy"],
    groupSortBy: json["GroupSortBy"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "UserRightsID": userRightsId,
    "Account3ID": account3Id,
    "MenuName": menuName,
    "Inserting": inserting,
    "Viwe" : view,
    "Edting": edting,
    "Deleting": deleting,
    "Reporting": reporting,
    "ClientID": clientId,
    "ClientUserID": clientUserId,
    "NetCode": netCode,
    "SysCode": sysCode,
    "UpdatedDate": '',
    "SortBy": sortBy,
    "GroupSortBy": groupSortBy,
  };
}
