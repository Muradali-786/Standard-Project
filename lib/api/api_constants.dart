class ApiConstants {
  static final String baseUrl = 'https://www.api.easysoftapp.com/';
  static final String projectMenu = 'PhpApi1/Project/GetProjectMenu.php';
  static final String countryCode =
      'PhpApi1/CountryCode/0_ImportAllDataInSQLite.php';
  static final String projectMenuSub = 'PhpApi1/Project/GetProjectMenuSub.php';
  static final String project = 'PhpApi1/Project/GetProject.php';
  static final String createAccount =
      "PhpApi1/CreateAccount/createAccountAc3Name.php";
  static final String checkEmail = "PhpApi1/CreateAccount/CheckEmail.php";
  static final String checkMobile = "PhpApi1/CreateAccount/CheckEmail.php";
  static final String loginEmail =
      'PhpApi1/CreateAccount/LoginWithMobileOrEmail.php';
  static final String updateMobileNumber =
      "PhpApi1/CreateAccount/UpdateMobileNumber.php";
  static final String loginWithMobileNoOrEmailPassword =
      'PhpApi1/CreateAccount/LoginWithMobileNoOrEmailPassword.php';
  static final String uploadImages = 'PhpApi1/ClientImages/CountryUserLogo/UploadImages.php';
  static final String uploadImageWithPath = 'PhpApi1/ImageUploadWithPath.php';
  static final String importLoginClientData =
      'PhpApi1/Client/1_ImportAllData.php';
  static final String clientCreateApiUrl = 'PhpApi1/Client/4_ClientCreate.php';

  /////////////////
  //Refreshing Apis
  //Insert and Update from server
  /////////////////

  //////////     Account2Group API URL  ////////////////
  static final String refreshAccount2Api =
      'PhpApi1/Account2Group/1_GetUpdatedAndNewDataFromServer.php';
  static final String refreshAccount2GroupUpdateToServerUrl =
      'PhpApi1/Account2Group/2_UpdatedDataToServer.php';
  static final String refreshAccount2GroupAddNewDataToServerUrl =
      'PhpApi1/Account2Group/3_AddNewDataToServer.php';

  //////////     Account3Name API URL  ////////////////
  static final String refreshAccount3ApiUrl =
      'PhpApi1/Account3Name/1_GetUpdatedAndNewDataFromServer.php';
  static final String refreshAccount3UpdateToServerUrl =
      'PhpApi1/Account3Name/2_UpdatedDataToServer.php';
  static final String refreshAccount3AddNewDataToServerUrl =
      'PhpApi1/Account3Name/3_AddNewDataToServer.php';

  //////////     Item2Group API URL  ////////////////
  static final String refreshItem2GroupApiUrl =
      'PhpApi1/Item2Group/1_GetUpdatedAndNewDataFromServer.php';
  static final String refreshItem2GroupUpdateToServerUrl =
      'PhpApi1/Account3Name/2_UpdatedDataToServer.php';
  static final String refreshItem2GroupAddNewDataToServerUrl =
      'PhpApi1/Account3Name/3_AddNewDataToServer.php';

  //////////     Item3Name API URL  ////////////////
  static final String refreshItem3NameApiUrl =
      'PhpApi1/Item3Name/1_GetUpdatedAndNewDataFromServer.php';
  static final String refreshItem3NameUpdateToServerUrl =
      'PhpApi1/Account3Name/2_UpdatedDataToServer.php';
  static final String refreshItem3NameAddNewDataToServerUrl =
      'PhpApi1/Account3Name/3_AddNewDataToServer.php';

  //////////     CashBook API URL  ////////////////
  static final String refreshCashBookApiUrl =
      'PhpApi1/CashBook/1_GetUpdatedAndNewDataFromServer.php';
  static final String refreshCashBookUpdateToServerUrl =
      'PhpApi1/CashBook/2_UpdatedDataToServer.php';
  static final String refreshCashBookAddNewDataToServerUrl =
      'PhpApi1/CashBook/3_AddNewDataToServer.php';

/////////////////
  //Refreshing Apis
  //Update edited record to server
  /////////////////

/////////////////
//Refreshing Apis
//Inserting new data to server
/////////////////

}
