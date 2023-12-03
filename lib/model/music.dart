class Music {
  final String title;
  final String artist;
  bool _isLiked = false;
  final double _rating = 0;

  bool get isLiked => _isLiked;

  double get rating => _rating;

  Music({
    required this.title,
    required this.artist,
  });

  set isLiked(bool isLiked) {
    _isLiked = isLiked;
  }

  set rating(double rating) {
    _rating - rating;
  }

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'] ?? '', // title이 없으면 공백으로 저장
      artist: json['artist'] ?? '',
    );
  }
}
