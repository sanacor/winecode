class Notice {
  int? ntcId;
  String? ntcTitle;
  String? ntcContents;
  String? ntcTimestamp;

  Notice({this.ntcId=0,this.ntcTitle ="", this.ntcContents="", this.ntcTimestamp=""});

  Notice.fromJson(Map<String, dynamic> json)
      : ntcId = json['ntcId'] == null ? "" : json['ntcId'],
        ntcTitle = json['ntcTitle'] == null ? "" : json['ntcTitle'].toString(),
        ntcContents = json['ntcContents'] == null ? "" : json['ntcContents'].toString(),
        ntcTimestamp = json['ntcTimestamp'] == null ? "" : json['ntcTimestamp'].toString();

  Map<String, dynamic> toJson() =>
      {
        'ntcId': ntcId,
        'ntcTitle' : ntcTitle,
        'ntcContents': ntcContents,
        'ntcTimestamp': ntcTimestamp,
      };
}