import 'package:flutter/material.dart';
import '../services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  Map args = {};
  List<WorldTime> locations = [];

  void setUpWorldTime() {
    locations = [
      WorldTime(url: 'Europe/London', location: 'London', flag: 'uk.png', callback: redirect),
      WorldTime(url: 'Europe/Berlin', location: 'Athens', flag: 'greece.png', callback: redirect),
      WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'egypt.png', callback: redirect),
      WorldTime(url: 'Africa/Nairobi', location: 'Nairobi', flag: 'kenya.png', callback: redirect),
      WorldTime(url: 'America/Chicago', location: 'Chicago', flag: 'usa.png', callback: redirect),
      WorldTime(url: 'America/New_York', location: 'New York', flag: 'usa.png', callback: redirect),
      WorldTime(url: 'Asia/Seoul', location: 'Seoul', flag: 'south_korea.png', callback: redirect),
      WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', flag: 'indonesia.png', callback: redirect),
    ];
  }

  void updateTime(location) async {
    await location.getTime();
    args['location'] = location.location;
    args['flag'] = location.flag;
    args['time'] = location.time;
    args['isDayTime'] = location.isDayTime;
  }

  void redirect() {
    Navigator.pop(context, args);
  }

  @override
  Widget build(BuildContext context) {
    setUpWorldTime();
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Choose Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  updateTime(locations[index]);
                },
                title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${locations[index].flag}'),
                ),
              ),
            ),
          );
        },
        itemCount: locations.length,
      ),
    );
  }
}
