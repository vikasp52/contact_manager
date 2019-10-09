class ContactModel {
  int _contactId;
  String _name;
  String _dob;
  String _mobNo;
  String _profilePicUrl;
  String _favourite;

  ContactModel(this._name, this._dob, this._mobNo, this._profilePicUrl, this._favourite);

  ContactModel.map(dynamic obj) {
    this._contactId = obj["contactId"];
    this._name = obj["name"];
    this._dob = obj["dob"];
    this._mobNo = obj["mobileNo"];
    this._profilePicUrl = obj["profilePhotoUrl"];
    this._favourite = obj["favourite"];
  }

  int get contactId => _contactId;

  String get name => _name;

  String get dob => _dob;

  String get mobileNo => _mobNo;

  String get profilePhotoUrl => _mobNo;

  String get favourite => _favourite;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["dob"] = _dob;
    map["mobileNo"] = _mobNo;
    map["profilePhotoUrl"] = _profilePicUrl;
    map["favourite"] = _favourite;
    if (_contactId != null) {
      map["contactId"] = _contactId;
    }
    return map;
  }

  ContactModel.fromMap(Map<String, dynamic> map) {
    this._contactId = map["contactId"];
    this._name = map["name"];
    this._dob = map["dob"];
    this._mobNo = map["mobileNo"];
    this._profilePicUrl = map["profilePhotoUrl"];
    this._favourite = map["favourite"];
  }
}
