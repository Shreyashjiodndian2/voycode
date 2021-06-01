import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zomato_demo/AddressInputWidget.dart';

class CustomAppBar extends StatefulWidget {
  final Function onTap;
  CustomAppBar({this.onTap});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  // String location = "";
  Position _location;
  String address = "";
  
  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) => {
      // _location = value,
      // print(value),
      Geocoder.local.findAddressesFromCoordinates((new Coordinates(value.latitude, value.longitude))).then((value) => setState(() {
        address = value[0].addressLine;
      }))
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft:Radius.circular(0),
          topRight:Radius.circular(0),
          bottomLeft: Radius.circular(10.0),
          bottomRight:Radius.circular(10.0)
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: const Offset(
            5.0,5.0
          ), 
          blurRadius: 10.0, spreadRadius: 2.0)
        ]
      ),
      padding: EdgeInsets.fromLTRB(16,30,16,5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(child: Image.asset("assets/menu.png", height: 20,), onTap: () => {
            Scaffold.of(context).openDrawer(),
          },
          splashColor: Colors.red,),
        // SizedBox(child: SvgPicture.asset('menu.svg', color: Colors.red, height: 22, width: 22, allowDrawingOutsideViewBox: true,), height: 22),
        Column(
          children: [
            Text('Delivering to', style: TextStyle(color: Colors.grey[400])),
            InkWell(
              onTap: () => widget.onTap(),
              child: Row(
                children: [
                  Text(address == null || address.isEmpty || address.length == 0 ? "Select Address": address.substring(0,19)+"...",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.red,
                  )
                ],
              ),
            )
          ],
        ),
        Icon(Icons.search, color: Colors.red, size: 30,)
      ]),
    );
  }
}
