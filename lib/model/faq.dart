class Faq {
  int? faqId;
  String? faqQ;
  String? faqA;

  Faq({this.faqId=0,this.faqQ ="", this.faqA=""});

  Faq.fromJson(Map<String, dynamic> json)
      : faqId = json['faqId'] == null ? "" : json['faqId'],
        faqQ = json['faqQ'] == null ? "" : json['faqQ'].toString(),
        faqA = json['faqA'] == null ? "" : json['faqA'].toString();

  Map<String, dynamic> toJson() =>
      {
        'faqId': faqId,
        'faqQ' : faqQ,
        'faqA': faqA,
      };
}