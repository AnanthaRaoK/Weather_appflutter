import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import 'const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? city;
  TextEditingController cityName=TextEditingController();
  final WeatherFactory _wf=WeatherFactory(OPEN_WEATHER_APIKEY);
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName("London").then((weat) {
      setState(() {
        _weather=weat;
      });
    });
  }
  void _fetchWeather(String city) {
    _wf.currentWeatherByCityName(city).then((weat) {
      setState(() {
        _weather = weat;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyfunc() ,);
  }
  Widget _bodyfunc(){
    if (_weather==null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: cityName,
                decoration: InputDecoration(
                  border:OutlineInputBorder() ,
                  labelText: 'Enter city name',
                ),
              ),
              ElevatedButton(onPressed:() {
                _fetchWeather(cityName.text);
              },
                  child:Text('Submit')),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),
              Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}\u00B0C",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 90),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),
              Text(_weather?.areaName ?? " ",
              style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),
              _datetimeinfo(),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
              Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: MediaQuery.sizeOf(context).height*0.08,
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),),
                  Text(_weather?.weatherDescription ?? " ",
                  style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],),
        ),
      ),
    );
  }
  Widget _datetimeinfo(){
    DateTime now=_weather!.date!;
    return Column(children: [
      Text(DateFormat("hh:mm a").format(now),
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
      SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(DateFormat("EEEE").format(now),
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
          ),
          Text("   ${DateFormat("d/M/y").format(now)}",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
          ),
      ],)
    ],);
  }
}
