import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zomato_demo/AddressInputWidget.dart';
import 'package:zomato_demo/customAppBar.dart';
import 'package:zomato_demo/dummyData.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Map locationMap;
  final TextEditingController _locationController = new TextEditingController();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  void showDialogBox() {
    AlertDialog(
                  content:ListTile(
                leading: Icon(Icons.location_on),
                title: TextFormField(
                  // onChanged: (value) {
                  //   print("on address changed $value");
                  //   newProvider["location"] = value;
                  // },
                  readOnly: true,
                  controller: _locationController,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.dark,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Your Address is Required";
                    }
                    return null;
                  },
                  onTap: () async {
                    // Map loc = await initPlatformState();

                    // if (loc != null) {
                    //   newProvider["location"] = loc["address"];
                    //   newProvider["latitude"] = loc["lat"];
                    //   newProvider["longitude"] = loc["lon"];
                    //   setState(() {
                    //     _locationController.text = loc["address"];
                    //   });
                    // }
                    var address = await showDialog(
                        context: context,
                        builder: (context) => AddressInputWidget(
                              addressMap: locationMap,
                            ));

                    if (address != null) {
                      locationMap = address;
                      _locationController.text = address['addressLine'];
                      address = _locationController.value.text;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Address",
                    hintText: "Enter Your Address",
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                ),
                // trailing: GestureDetector(
                //     onTap: () async {
                //       // Map loc = await initPlatformState();

                //       // if (loc != null) {
                //       //   newProvider["location"] = loc["address"];
                //       //   newProvider["latitude"] = loc["lat"];
                //       //   newProvider["longitude"] = loc["lon"];
                //       //   setState(() {
                //       //     _locationController.text = loc["address"];
                //       //   });
                //       // }
                //       var address = await showDialog(
                //           context: context,
                //           builder: (context) => AddressInputWidget(
                //                 addressMap: locationMap,
                //               ));

                //       print(address);
                //       if (address != null) {
                //         locationMap = address;
                //         _locationController.text = address['addressLine'];
                //       }
                //     },
                //     child: Icon(Icons.location_searching)),
              )
                );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: ,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.red),
                child: Column(
                  children: [
                    Image.network(
                        'https://img.icons8.com/office/80/000000/french-fries.png'),
                    Text('Zomato'),
                  ],
                ))
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(onTap: showDialogBox),
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 8),
            child: Text('VENUES',
                style: TextStyle(
                    color: Colors.orangeAccent,
                    textBaseline: TextBaseline.ideographic,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: dummyData()
                  .data
                  .map((e) => Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        elevation: 2,
                        child: Container(
                          height: size.height * 0.25,
                          width: size.width,
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                  image: NetworkImage(e['img_url'].toString()),
                                  fit: BoxFit.cover),
                              ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [Colors.black, Colors.transparent])),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    children: [
                                      Text(
                                        e["name"],
                                        style: TextStyle(
                                            backgroundColor: Colors.transparent,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey[50],
                                            fontSize: 30),
                                      ),
                                      Text(
                                        e["description"],
                                        style: TextStyle(
                                            backgroundColor: Colors.transparent,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.grey[50]),
                                      ),
                                      Text(
                                        e['deliveryDetails'],
                                        style: TextStyle(
                                            backgroundColor: Colors.transparent,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15,
                                            color: Colors.grey[50]),
                                      )
                                    ],
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: size.width * 0.2,
                                          height: 34,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(17)),
                                          child: Center(
                                              child: Text(
                                            e['time'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          )),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              e.keys.contains("offer")
                                                  ? e['offer']
                                                  : "",
                                              style: TextStyle(
                                                backgroundColor:
                                                    Colors.transparent,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            Text(
                                              e.keys.contains("offer")
                                                  ? "Welcome Offer"
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ])
                                ]),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining), label: 'Delivery'),
          BottomNavigationBarItem(icon: Icon(Icons.dining), label: 'Dine-in')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
