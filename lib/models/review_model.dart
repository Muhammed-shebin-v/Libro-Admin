

class ReviewModel {
  final String userId;
  final String userName;
  final String userImage;
  final String reviewText;
  final double rating;
  final String date;

  ReviewModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.reviewText,
    required this.rating,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'reviewText': reviewText,
      'rating': rating,
      'date': date,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      userId: data['userId']??'',
      userName: data['userName']??'',
      userImage: data['userImage']??'',
      reviewText: data['reviewText']??'',
      rating: data['rating']??'',
      date: data['date']??'',
    );
  }
}
