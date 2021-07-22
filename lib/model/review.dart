class Review {
  int? prvPdtId;
  String? prvMedia;
  String? prvUrl;
  String? prvAuthor;
  String? prvTitle;
  String? prvRecommend;

  Review({this.prvPdtId=0,this.prvMedia ="", this.prvUrl="", this.prvAuthor="", this.prvTitle="",this.prvRecommend=""});

  Review.fromJson(Map<String, dynamic> json)
    : prvPdtId = json['prvPdtId'] == null ? "" : json['prvPdtId'],
      prvMedia = json['prvMedia'] == null ? "" : json['prvMedia'].toString(),
      prvUrl = json['prvUrl'] == null ? "" : json['prvUrl'].toString(),
      prvAuthor = json['prvAuthor'] == null ? "" : json['prvAuthor'].toString(),
      prvTitle = json['prvTitle'] == null ? "" : json['prvTitle'].toString(),
      prvRecommend = json['prvRecommend'] == null ? "" : json['prvRecommend'].toString();

  Map<String, dynamic> toJson() =>
      {
        'prvPdtId': prvPdtId,
        'prvMedia' : prvMedia,
        'prvUrl': prvUrl,
        'prvAuthor': prvAuthor,
        'prvTitle' : prvTitle,
        'prvRecommend' : prvRecommend,
      };
}