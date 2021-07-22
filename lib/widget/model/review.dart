class Review {
  int? prvPdtId;
  String? prvMedia;
  String? prvUrl;

  Review({this.prvPdtId=0,this.prvMedia ="", this.prvUrl=""});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(prvPdtId: json['prvPdtId'],
        prvMedia: json['prvMedia'],
        prvUrl: json['prvUrl'],
    );
  }
}