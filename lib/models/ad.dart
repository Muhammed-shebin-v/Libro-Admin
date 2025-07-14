class AdModel {
  final String? uid;
  final String title;
  final String content;
  final String imgUrl;

  AdModel({
    required this.uid,
    required this.title,
    required this.content,
    required this.imgUrl,
  });

  factory AdModel.fromMap(Map<String, dynamic> data) {
    return AdModel(
      uid: data['uid'],
      title: data['title'],
      content: data['content'],
      imgUrl: data['imgUrl'],
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'content':content,
      'imgUrl':imgUrl
    };
  }
}
