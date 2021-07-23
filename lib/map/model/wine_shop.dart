class WineShop {
  String? retail_id;
  String? retail_name;
  String? retail_phone;
  String? retail_address;
  String? retail_bhours;
  String? retail_exp;
  bool? retail_partner;

  WineShop({this.retail_id, this.retail_name,this.retail_phone,this.retail_address,this.retail_bhours,this.retail_exp,this.retail_partner});


  WineShop.fromJson(Map<String, dynamic> json)
      : retail_id = json['rtlId'] == null ? "" : json['rtlId'].toString(),
        retail_name = json['rtlName'] == null ? "" : json['rtlName'].toString(),
        retail_phone = json['rtlPhone'] == null ? "" : json['rtlPhone'].toString(),
        retail_address = json['rtlAddress'] == null ? "" : json['rtlAddress'].toString(),
        retail_bhours = json['rtlBhours'] == null ? "" : json['rtlBhours'].toString(),
        retail_exp = json['rtlExp'] == null ? "" : json['rtlExp'].toString(),
        retail_partner = json['rtlPartner'] == "Y" ? true : false;
}


