// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  static SharedPreferences? prefs;
  static final USER_ID = 'user_id';
  static final String CLIENT_ID_SESSION = "client_id_session";
  static final String initializeFirebaseFirstTimeForMobile = "false";
  static final String initializeFirebaseFirstTimeForWeb = "false";
  static final String USER_RIGHTS_SESSION = "user_rights_session";
  static final String countryClientId = 'country_client_id';
  static final String countryUserId = 'country_user_id';
  static final String nameOfPerson = 'name_of_person';
  static final String email = 'email';
  static final String defaultSaleTwoAccount = 'defaultSaleTwoAccount';
  static final String defaultSaleTwoAccountName = 'defaultSaleTwoAccountName';
  static final String mobileNumber = 'mobile_number';

  //////////////////////////////////////////////////////////////////////////
  //Client Preferences
  /////////////////////////////////////////////////////////////////////////
  static final String countryClientID2 = 'CountryClientId2';
  static final String countryUserId2 = 'CountryUserId2';
  static final String clinetId = 'ClinetId';
  // static final String clinetId='3';
  static final String clientUserId = 'ClientUserId';
  static final String userName = 'UserName';
  static final String companyName = 'CompanyName';
  static final String companyAddress = 'CompanyAddress';
  static final String companyNumber = 'CompanyNumber';
  static final String website = 'Website';
  static final String emailClient = 'EmailClient';
  static final String nameOfPersonOwner = 'NameOfPersonOwner';
  static final String bussinessDescription = 'BussinessDescription';
  static final String userRightsClient = 'UserRightsClient';
  static final String netcode = 'NetCode';
  static final String sysCode = 'SysCode';
  static final String projectId = 'ProjectID';
  static final String projectIdForProject = 'ProjectIDForProject';

  //static final String projectId='2';
  static final String fromDate = 'FromDate';
  static final String toDate = 'ToDate';
  static final String showHomePage = 'ShowHomePage';
  static final String currencySign = 'currencySign';

  /////
  static final String subMenuQuery = 'SubMenuQuery';
  static final String isDefaultApisCall = 'isDefaultApisCall';
  static final String dateFormat = 'yyyy-MM-dd';
}
