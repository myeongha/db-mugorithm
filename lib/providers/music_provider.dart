import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mugorithm/model/User.dart';
import 'package:mugorithm/model/music.dart';
import 'package:http/http.dart' as http;
import 'package:mugorithm/providers/user_provider.dart';

class MusicProvider extends ChangeNotifier {
  List<Music> _allMusicList = [];

  List<Music> _myMusicList = [];

  List<Music> _recommendMusicList = [];

  List<Music> get allMusicList => _allMusicList;

  List<Music> get myMusicList => _myMusicList;

  List<Music> get recommendMusicList => _recommendMusicList;

  final String _allMusicListApi = '전체 뮤직 api 주소';

  final String _recommendMusicListApi = '전체 뮤직 api 주소';

  final String _myMusicListApi = '전체 뮤직 api 주소';

  final String _updateMymusicApi = 'my music update api';

  final String _deleteMymusicApi = 'my music delete api';

  // 모든 음악 리스트 가져오는 함수
  Future<List> fetchAllMusicList(User user) async {
    // 실제 동작 부분
    try {
      final response = await http.get(Uri.parse(_allMusicListApi));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _allMusicList = data.map((json) => Music.fromJson(json)).toList();
      } else {
        print('서버 응답 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }

    // test
    /*   final List<Map<String, dynamic>> fakeMusicData = [
      {
        'title': 'Song 1',
        'artist': 'Artist 1',
        'phone': '11111',
      },
      {
        'title': 'Song 2',
        'artist': 'Artist 2',
        'phone': '11111',
      },
      {
        'title': 'Song 3',
        'artist': 'Artist 3',
        'phone': '11111',
      },
      {
        'title': 'Song 4',
        'artist': 'Artist 4',
      },
      {
        'title': 'Song 5',
        'artist': 'Artist 5',
      },
      {
        'title': 'Song 6',
        'artist': 'Artist 6',
      },
      {
        'title': 'Song 7',
        'artist': 'Artist 7',
      },
      {
        'title': 'Song 8',
        'artist': 'Artist 8',
      },
      {
        'title': 'Song 9',
        'artist': 'Artist 9',
      },
      {
        'title': 'Song 10',
        'artist': 'Artist 10',
      },

      // 추가적인 더미 데이터
    ];

    _allMusicList = fakeMusicData.map((json) => Music.fromJson(json)).toList();

    print("all music dalay 전\n");
    await Future.delayed(Duration(seconds: 5));
    print("all music dalay 후\n");
    notifyListeners();
    print('Data updated: ${_allMusicList.length} items');*/
    return _allMusicList;
  }

  // 나의 음악 리스트 가져오는 함수
  Future<List> fetchMymusicList(User user) async {
    //실제 통신
    try {
      final response = await http.get(Uri.parse(_myMusicListApi));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _myMusicList = data.map((json) => Music.fromJson(json)).toList();
      } else {
        print('서버 응답 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }

    // test
/*    final List<Map<String, dynamic>> fakeMusicData = [
      {
        'title': 'Song 4',
        'artist': 'Artist 4',
        'phone': '1111',
      },
      {
        'title': 'Song 5',
        'artist': 'Artist 5',
      },
      {
        'title': 'Song 6',
        'artist': 'Artist 6',
      },
      {
        'title': 'Song 7',
        'artist': 'Artist 7',
      },
      {
        'title': 'Song 8',
        'artist': 'Artist 8',
      },
      {
        'title': 'Song 9',
        'artist': 'Artist 9',
      },
      {
        'title': 'Song 10',
        'artist': 'Artist 10',
      },

      // 추가적인 더미 데이터
    ];

    _myMusicList = fakeMusicData.map((json) => Music.fromJson(json)).toList();*/

    //all뮤직리스트에서 나의 뮤직리스트의 뮤직들을 좋아요 표시하기 위한 로직
    for (Music myMusic in _myMusicList) {
      myMusic.isLiked = true; // 나의 뮤직리스트는 디폴트로 좋아요
      for (Music allMusic in _allMusicList) {
        if (myMusic.title == allMusic.title) {
          allMusic.isLiked = true;
          break;
        }
      }
    }

    return _myMusicList;
  }

// 추천음악리스트 가져오는 함수
  Future<List> fetchRecommendMusicList(User user) async {
    //실제 통신
    try {
      final response = await http.get(Uri.parse(_recommendMusicListApi));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _myMusicList = data.map((json) => Music.fromJson(json)).toList();
      } else {
        print('서버 응답 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    // test
/*    final List<Map<String, dynamic>> fakeMusicData = [
      {
        'title': 'Song 11',
        'artist': 'Artist 11',
        'phone': '1111',
      },
      {
        'title': 'Song 12',
        'artist': 'Artist 12',
      },
      {
        'title': 'Song 13',
        'artist': 'Artist 13',
      },
      {
        'title': 'Song 14',
        'artist': 'Artist 14',
      },
      {
        'title': 'Song a',
        'artist': 'Artist a',
      },
      {
        'title': 'Song b',
        'artist': 'Artist b',
      },

      // 추가적인 더미 데이터
    ];
    //test
    _recommendMusicList =
        fakeMusicData.map((json) => Music.fromJson(json)).toList();*/
    return _recommendMusicList;
  }

  //음악 좋아요추가
  Future<void> updateMyMusic(Music music, User user) async {
    // 서버에 보낼 데이터를 Map 형태로 구성
    final Map<String, dynamic> requestData = {
      'userName': user.email, // 사용자 이름
      'musicTitle': music.title, // 음악 제목
      'rating': music.rating,
    };

    try {
      final response = await http.post(
        Uri.parse(_updateMymusicApi),
        body: json.encode(requestData),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        print('서버 응답 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  //mymusic에서 제거
  Future<void> deleteMymusic(Music music, User user) async {
    // 서버에 보낼 데이터를 Map 형태로 구성
    final Map<String, dynamic> requestData = {
      'userName': user.email, // 사용자 이름
      'musicTitle': music.title, // 음악 제목
    };

    try {
      final response = await http.delete(
        Uri.parse(_deleteMymusicApi),
        body: json.encode(requestData),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        print('서버 응답 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}
