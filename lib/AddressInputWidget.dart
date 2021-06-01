import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart' as geo;
import 'package:toast/toast.dart';
import '../globals.dart';

class AddressInputWidget extends StatefulWidget {
  final Map addressMap;

  AddressInputWidget({@required this.addressMap});

  @override
  _AddressInputWidgetState createState() =>
      _AddressInputWidgetState(addressMap);
}

class _AddressInputWidgetState extends State<AddressInputWidget> {
  bool fetchingLocation = false;
  final _formKey = GlobalKey<FormState>();

  _AddressInputWidgetState(addressMap) {
    if (addressMap != null) {
      line1Controller.text = addressMap['line1'];
      line2Controller.text = addressMap['line2'];
      stateController.text = addressMap['state'];
      cityController.text = addressMap['city'];
      countryController.text = addressMap['country'];
      pincodeController.text = addressMap['pincode'];
    }
  }

  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var dialogWidth = MediaQuery.of(context).size.width * .8;

    return Dialog(
      child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .7),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        bottom: 0, left: 15, right: 15, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Enter Address",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(5),
                          onPressed: fetchingLocation
                              ? null
                              : () async {
                                  if (fetchingLocation) return;

                                  setState(() {
                                    fetchingLocation = true;
                                  });
                                  Map loc = await initPlatformState();

                                  if (loc == null) {
                                    Toast.show(
                                        "Location needs to be allowed", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      fetchingLocation = false;
                                    });
                                    return;
                                  }

                                  var address = await geo.Geocoder.local
                                      .findAddressesFromQuery(loc["address"]);

                                  print(
                                      "location: ${address.first.toMap().toString()}");

                                  countryController.text =
                                      address.first.countryName;
                                  stateController.text =
                                      address.first.adminArea;
                                  cityController.text =
                                      address.first.subAdminArea;
                                  pincodeController.text =
                                      address.first.postalCode;
                                  line1Controller.text = address
                                      .first.addressLine
                                      .trim()
                                      .replaceAll(
                                          RegExp(
                                              '${address.first.countryName},*|${address.first.adminArea},*|${address.first.subAdminArea},*|${address.first.locality},*|${address.first.postalCode},*'),
                                          '')
                                      .trim()
                                      .replaceAll(
                                          RegExp(',\$', multiLine: true), '');
                                  line2Controller.text = address.first.locality;

                                  setState(() {
                                    fetchingLocation = false;
                                  });
                                },
                          child: Row(
                            children: [
                              Text(
                                'My Location',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context).primaryColor),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: fetchingLocation
                                    ? Container(
                                        width: 17,
                                        height: 17,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Icon(Icons.location_searching_rounded,
                                        size: 20,
                                        color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                controller: line1Controller,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "Address Line 1"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                controller: line2Controller,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "Address Line 2"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                controller: stateController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: "State"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                controller: cityController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: "City"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                controller: countryController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Country"),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                controller: pincodeController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Pin Code"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                      padding: EdgeInsets.all(15),
                      splashColor: Colors.lightBlue,
                      textColor: Colors.white,
                      color: Theme.of(context).colorScheme.primary,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Done",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          var locationMap = Map.fromEntries([
                            MapEntry('country', countryController.text),
                            MapEntry('state', stateController.text),
                            MapEntry('city', cityController.text),
                            MapEntry('pincode', pincodeController.text),
                            MapEntry('line1', line1Controller.text),
                            MapEntry('line2', line2Controller.text),
                          ]);

                          locationMap['addressLine'] =
                              "${locationMap['line1']}, ${locationMap['line2']}, ${locationMap['city']}, ${locationMap['state']}, ${locationMap['country']}, ${locationMap['pincode']}";

                          Navigator.of(context).pop(locationMap);
                        }
                      })
                ],
              ))),
    );
  }
}
