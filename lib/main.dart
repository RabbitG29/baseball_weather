import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'baseball_park.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '야구장 날씨',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '야구장 날씨 알아보기'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String weather = "날씨를 조회하세요";
  BaseballPark ssg = BaseballPark(
      nx: "55",
      ny: "124",
      latitude: "126.68",
      longitude: "37.43",
      name: "인천SSG랜더스필드");
  BaseballPark lgDoosan = BaseballPark(
      nx: "62",
      ny: "125",
      latitude: "127.05",
      longitude: "37.30",
      name: "서울종합운동장 야구장");
  BaseballPark kt = BaseballPark(
      nx: "61",
      ny: "121",
      latitude: "127.01",
      longitude: "37.17",
      name: "수원KT위즈파크");
  BaseballPark nc = BaseballPark(
      nx: "89",
      ny: "77",
      latitude: "128.35",
      longitude: "35.13",
      name: "창원NC파크");
  BaseballPark kia = BaseballPark(
      nx: "59",
      ny: "74",
      latitude: "126.53",
      longitude: "35.09",
      name: "광주기아챔피언스필드");
  BaseballPark lotte = BaseballPark(
      nx: "98",
      ny: "76",
      latitude: "129.03",
      longitude: "35.11",
      name: "사직 야구장");
  BaseballPark samsung = BaseballPark(
      nx: "91",
      ny: "90",
      latitude: "128.42",
      longitude: "35.50",
      name: "대구삼성라이온즈파크");
  BaseballPark hanhwa = BaseballPark(
      nx: "68",
      ny: "100",
      latitude: "127.26",
      longitude: "36.18",
      name: "대전한화생명이글스파크");
  BaseballPark kiwoom = BaseballPark(
      nx: "58",
      ny: "125",
      latitude: "126.51",
      longitude: "37.29",
      name: "고척 스카이돔");

  String _parseWeatherInfos(List<dynamic> items, String baseTime) {
    Map<String, String> map = {};
    for (var item in items) {
      if (item["baseTime"] == baseTime) {
        map = _parseWeatherInfo(item, map);
      }
    }

    return _convertWeatherMapToString(map);
  }

  Map<String, String> _parseWeatherInfo(var item, var map) {
    switch (item["category"]) {
      case "T1H":
      case "RN1":
      case "WSD":
      case "REH":
        map[item["category"]] = item["fcstValue"];
        break;
      case "SKY":
        map[item["category"]] = _parseSky(int.parse(item["fcstValue"]));
        break;
      case "PTY":
        map[item["category"]] = _parsePty(int.parse(item["fcstValue"]));
        break;
      default:
    }

    return map;
  }

  String _parseSky(int sky) {
    String result = "";
    switch (sky) {
      case 0:
        result = "맑음";
        break;
      case 3:
        result = "구름많음";
        break;
      case 4:
        result = "흐림";
        break;
      default:
    }
    return result;
  }

  String _parsePty(int? pty) {
    String result = "";
    if (pty == null) {
      return "없음";
    }
    switch (pty) {
      case 0:
        result = "없음";
        break;
      case 1:
        result = "비";
        break;
      case 2:
        result = "비/눈";
        break;
      case 3:
        result = "눈";
        break;
      case 5:
        result = "빗방울";
        break;
      case 6:
        result = "빗방울눈날림";
        break;
      case 7:
        result = "눈날림";
        break;
      default:
    }
    return result;
  }

  String _convertWeatherMapToString(Map<String, String> map) {
    String result = "날씨 : ${map['SKY']}\n";
    result += "기온 : ${map['T1H']}℃\n";
    result += "강수형태 : ${map['PTY']}\n";
    result += "1시간 내 강수량 : ${map['RN1']}mm\n";
    result += "풍속 : ${map['WSD']}m/s\n";
    result += "습도 : ${map['REH']}%\n";

    return result;
  }

  void _getWeatherInfo(BaseballPark park) async {
    const endPoint =
        "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst";
    const serviceKey =
        "3gEzKN8bX4%2FcM%2FVA%2BA%2BilUk52BqnLj396LZurkEN5b7x1dVcT%2F0yOFFAiDh%2B8W6YRaVFo47g9tfSK83%2FbbuBTQ%3D%3D";
    const pageNo = "1";
    const numOfRows = "60";
    const dataType = "JSON";
    DateTime now = DateTime.now().toLocal();
    String encodedMonth =
        now.month < 10 ? "0${now.month}" : now.month.toString();
    String baseDate = now.year.toString() + encodedMonth + now.day.toString();
    String baseTime = now.minute > 35 ? "${now.hour}30" : "${now.hour - 1}30";
    String url =
        "$endPoint?serviceKey=$serviceKey&pageNo=$pageNo&numOfRows=$numOfRows&dataType=$dataType&base_date=$baseDate&base_time=$baseTime&nx=${park.nx}&ny=${park.ny}";
    var response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(url);
      print('Response body: ${response.body}');
    }
    // TODO : exception or error response handling
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    List<dynamic> items = parsedJson["response"]["body"]["items"]["item"];
    setState(() {
      weather = "${park.name} 날씨\n${_parseWeatherInfos(items, baseTime)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(ssg);
                    },
                    child: Text(ssg.name)),
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(lgDoosan);
                    },
                    child: Text(lgDoosan.name)),
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(kt);
                    },
                    child: Text(kt.name)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(nc);
                    },
                    child: Text(nc.name)),
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(kia);
                    },
                    child: Text(kia.name)),
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(lotte);
                    },
                    child: Text(lotte.name)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(samsung);
                    },
                    child: Text(samsung.name)),
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(hanhwa);
                    },
                    child: Text(hanhwa.name)),
                ElevatedButton(
                    onPressed: () {
                      _getWeatherInfo(kiwoom);
                    },
                    child: Text(kiwoom.name)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Text(
                  weather,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
