class Comment {
  int? pucPdtId;
  String? pucUsrNickname;
  String? pucUserComment;
  Comment({this.pucPdtId=0,this.pucUsrNickname ="", this.pucUserComment=""});

  Comment.fromJson(Map<String, dynamic> json)
      : pucPdtId = json['pucPdtId'] == null ? 0 : int.parse(json['pucPdtId']),
        pucUsrNickname = json['pucUsrNickname'] == null ? "" : json['pucUsrNickname'].toString(),
        pucUserComment = json['pucUserComment'] == null ? "" : json['pucUserComment'].toString();

  Map<String, dynamic> toJson() =>
      {
        'pucPdtId': pucPdtId,
        'pucUsrNickname' : pucUsrNickname,
        'pucUserComment': pucUserComment,
      };
}