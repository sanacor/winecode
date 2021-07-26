class Comment {
  int? pucPdtId;
  String? pucUserId;
  String? pucUserComment;
  Comment({this.pucPdtId=0,this.pucUserId ="", this.pucUserComment=""});

  Comment.fromJson(Map<String, dynamic> json)
    : pucPdtId = json['pucPdtId'] == null ? "" : json['pucPdtId'],
      pucUserId = json['pucUserId'] == null ? "" : json['pucUserId'].toString(),
      pucUserComment = json['pucUserComment'] == null ? "" : json['pucUserComment'].toString();

  Map<String, dynamic> toJson() =>
      {
        'pucPdtId': pucPdtId,
        'pucUserId' : pucUserId,
        'pucUserComment': pucUserComment,
      };
}