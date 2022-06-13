import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Map args = {
    'location': '',
    'flag': '',
    'time': '',
    'isDayTime' : false
  };

  void setUpWorldTime() async {
    WorldTime inst = WorldTime(
        location: 'mar del plata',
        flag: 'argentina.png',
        url: 'America/Argentina/Buenos_Aires',
        callback: redirect);
    await inst.getTime();
    args['location'] = inst.location;
    args['flag'] = inst.flag;
    args['time'] = inst.time;
    args['isDayTime'] = inst.isDayTime;
  }

  void redirect() {
    Navigator.pushNamed(context, '/home', arguments: args);
  }

  @override
  void initState() {
    super.initState();
    setUpWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Expanded(
          child: LoadingIndicator(
              indicatorType: Indicator.pacman, /// Required, The loading type of the widget
              colors: [Colors.red],       /// Optional, The color collections
              backgroundColor: Colors.black,      /// Optional, Background of the widget
              pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
          ),
        ),
      ]
    );
  }
}
