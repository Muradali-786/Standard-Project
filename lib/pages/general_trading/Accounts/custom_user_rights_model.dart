class CustomUserRights {
  CustomUserRights();

  bool deleting=false;
  bool editing=false;
  bool reporting=false;
  bool inserting=false;
  bool view = false;


  Map<String, dynamic> toMap() => {
    "Deleting": deleting,
    "Editing": editing,
    "View" : view,

    "Reporting": reporting,
    "Inserting": inserting,
  };
}


