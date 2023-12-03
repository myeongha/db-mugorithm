import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mugorithm/model/music.dart';
import 'package:mugorithm/providers/music_provider.dart';
import 'package:mugorithm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class GridMusicItem extends StatefulWidget {
  final Music music;

  const GridMusicItem({Key? key, required this.music}) : super(key: key);

  @override
  State<GridMusicItem> createState() => _GridMusicItemState();
}

class _GridMusicItemState extends State<GridMusicItem> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final musicProvider = Provider.of<MusicProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      // width: 160,
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //이미지
          Container(
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'testImg/musicImg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
              bottom: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    //노래제목
                    Text(
                      widget.music.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    // 아티스트
                    Text(
                      widget.music.artist,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(
                      widget.music.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.music.isLiked ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (widget.music.isLiked) // 이미 좋아요
                        {
                          // 이미 좋아요
                          widget.music.isLiked = !widget.music.isLiked;
                          musicProvider.deleteMymusic(
                              widget.music!, userProvider.user!);
                        } else {
                          // 좋아요 누름
                          widget.music.isLiked = !widget.music.isLiked;
                          _showRatingPopup(context, userProvider, musicProvider,
                              widget.music);
                        }
                      });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingPopup(BuildContext context, UserProvider userProvider,
      MusicProvider musicProvider, Music music) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0;

        return AlertDialog(
          title: Text(
            '별점 주기',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 별점 위젯
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //mymusic update
                  print("${rating}\n");
                  music.rating = rating;
                  musicProvider.updateMyMusic(music, userProvider.user!);
                  Navigator.of(context).pop();
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
