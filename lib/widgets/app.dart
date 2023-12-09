// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:green_taxi/utils/app_constants.dart';
// import 'package:uuid/uuid.dart';
//
// const kGoogleApiKey = AppConstants.kGoogleApiKey;
//
// final customTheme = ThemeData(
//   primarySwatch: Colors.blue,
//   brightness: Brightness.dark,
//   // accentColor: Colors.redAccent,
//   inputDecorationTheme: InputDecorationTheme(
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(4.00)),
//     ),
//     contentPadding: EdgeInsets.symmetric(
//       vertical: 12.50,
//       horizontal: 10.00,
//     ),
//   ),
// );
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//     title: "My App",
//     theme: customTheme,
//     routes: {
//       "/": (_) => MyApp(),
//       "/search": (_) => CustomSearchScaffold(),
//     },
//   );
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// final homeScaffoldKey = GlobalKey<ScaffoldState>();
// final searchScaffoldKey = GlobalKey<ScaffoldState>();
//
// class _MyAppState extends State<MyApp> {
//   Mode _mode = Mode.overlay;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: homeScaffoldKey,
//       appBar: AppBar(
//         title: Text("My App"),
//       ),
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               _buildDropdownMenu(),
//               ElevatedButton(
//                 onPressed: _handlePressButton,
//                 child: Text("Search places"),
//               ),
//               ElevatedButton(
//                 child: Text("Custom"),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed("/search");
//                 },
//               ),
//             ],
//           )),
//     );
//   }
//
//   Widget _buildDropdownMenu() =>DropdownButton<Mode>(
//     value: _mode,
//     items: <DropdownMenuItem<Mode>>[
//       DropdownMenuItem<Mode>(
//         child: Text("Overlay"),
//         value: Mode.overlay,
//       ),
//       DropdownMenuItem<Mode>(
//         child: Text("Fullscreen"),
//         value: Mode.fullscreen,
//       ),
//     ],
//     onChanged: (Mode? m) {
//       if (m != null) {
//         setState(() {
//           _mode = m;
//         });
//       }
//     },
//   );
//
//
//   void onError(PlacesAutocompleteResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(response.errorMessage.toString())),
//     );
//   }
//
//   Future<void> _handlePressButton() async {
//     // show input autocomplete with selected mode
//     // then get the Prediction selected
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: onError,
//       mode: _mode,
//       language: "fr",
//       decoration: InputDecoration(
//         hintText: 'Search',
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       components: [Component(Component.country, "fr")],
//     );
//     // ScaffoldMessenger.of(context).
//     displayPrediction(p!, searchScaffoldKey.currentState!);
//   }
// }
//
// Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: kGoogleApiKey,
//       apiHeaders: await GoogleApiHeaders().getHeaders(),
//     );
//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
//     final lat = detail.result.geometry?.location.lat;
//     final lng = detail.result.geometry?.location.lng;
//
//     Get.to(SnackBar(content: Text("${p.description} - $lat/$lng")),);
//   }
// }
//
// // custom scaffold that handle search
// // basically your widget need to extends [GooglePlacesAutocompleteWidget]
// // and your state [GooglePlacesAutocompleteState]
// class CustomSearchScaffold extends PlacesAutocompleteWidget {
//   CustomSearchScaffold()
//       : super(
//     offset: 0,
//     radius: 1000,
//     strictbounds: false,
//     region: "us",
//     language: "en",
//     mode: Mode.overlay,
//     apiKey: AppConstants.kGoogleApiKey,
//     components: [new Component(Component.country, "us")],
//     types: ["(cities)"],
//     hint: "Search City",
//     sessionToken: Uuid().generateV4(),
//   );
//
//   @override
//   _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
// }
//
// class _CustomSearchScaffoldState extends PlacesAutocompleteState {
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
//     final body = PlacesAutocompleteResult(
//       onTap: (p) {
//         displayPrediction(p, searchScaffoldKey.currentState!);
//       },
//       logo: Row(
//         children: [FlutterLogo()],
//         mainAxisAlignment: MainAxisAlignment.center,
//       ),
//     );
//     return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
//   }
//
//   @override
//   void onResponseError(PlacesAutocompleteResponse response) {
//     super.onResponseError(response);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(response.errorMessage ?? "An error occurred")),
//     );
//   }
//
//   @override
//   void onResponse(PlacesAutocompleteResponse? response) {
//     super.onResponse(response);
//     if (response != null && response.predictions.isNotEmpty) {
//       // searchScaffoldKey.currentState?.showSnackBar(
//         Get.to(SnackBar(
//           content: Text("Got answer"),
//         ));
//       // );
//
//     }
//   }
// }
//
// class Uuid {
//   final Random _random = Random();
//
//   String generateV4() {
//     // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
//     final int special = 8 + _random.nextInt(4);
//
//     return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
//         '${_bitsDigits(16, 4)}-'
//         '4${_bitsDigits(12, 3)}-'
//         '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
//         '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
//   }
//
//   String _bitsDigits(int bitCount, int digitCount) =>
//       _printDigits(_generateBits(bitCount), digitCount);
//
//   int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);
//
//   String _printDigits(int value, int count) =>
//       value.toRadixString(16).padLeft(count, '0');
// }




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/directions.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:green_taxi/utils/app_constants.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   Completer<GoogleMapController> _controller = Completer();
//   GoogleMapController? mapController;
// // on below line we have specified camera position
//   static final CameraPosition _kGoogle = const CameraPosition(
//     target:LatLng( 30.033333,  31.233334),
//     zoom: 14.4746,
//   );
//   LatLng startLocation = LatLng( 30.033333,  31.233334);
//   String location = "Search Location";
// // on below line we have created the list of markers
//   final List<Marker> _markers = <Marker>[
//     Marker(
//         markerId: MarkerId('1'),
//         position:LatLng( 30.033333,  31.233334),
//         infoWindow: InfoWindow(
//           title: 'My Position',
//         )
//     ),
//   ];
//
// // created method for getting user current location
//   Future<Position> getUserCurrentLocation() async {
//     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
//
//     if (!isLocationServiceEnabled) {
//       // Location services are not enabled, handle accordingly.
//       return Future.error("Location services are disabled");
//     }
//
//     try {
//       await Geolocator.requestPermission();
//       return await Geolocator.getCurrentPosition();
//     } on MissingPluginException catch (e) {
//       // Handle MissingPluginException here.
//       print("MissingPluginException: $e");
//       return Future.error("Location plugin is not implemented on this platform");
//     } catch (e) {
//       // Handle other exceptions here.
//       print("Error: $e");
//       return Future.error("Error getting current location");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0F9D58),
//         // on below line we have given title of app
//         title: Text("GFG"),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             child: SafeArea(
//               // on below line creating google maps
//               child: GoogleMap(
//                 // on below line setting camera position
//                 initialCameraPosition: _kGoogle,
//                 // on below line we are setting markers on the map
//                 markers: Set<Marker>.of(_markers),
//                 // on below line specifying map type.
//                 mapType: MapType.normal,
//                 // on below line setting user location enabled.
//                 myLocationEnabled: true,
//                 // on below line setting compass enabled.
//                 compassEnabled: true,
//                 // on below line specifying controller on map complete.
//                 onMapCreated: (GoogleMapController controller){
//                   _controller.complete(controller);
//                 },
//               ),
//             ),
//           ),
//           Positioned(  //search input bar
//               top:10,
//               child: InkWell(
//                   onTap: () async {
//                     var place = await PlacesAutocomplete.show(
//                         context: context,
//                         apiKey: AppConstants.kGoogleApiKey,
//                         mode: Mode.overlay,
//                         types: [],
//                         strictbounds: false,
//                         components: [Component(Component.country, 'eg')],
//                         //google_map_webservice package
//                         onError: (err){
//                           print(err);
//                         }
//                     );
//
//                     if(place != null){
//                       setState(() {
//                         location = place.description.toString();
//                       });
//
//                       //form google_maps_webservice package
//                       final plist = GoogleMapsPlaces(apiKey:AppConstants.kGoogleApiKey,
//                         apiHeaders: await GoogleApiHeaders().getHeaders(),
//                         //from google_api_headers package
//                       );
//                       String placeid = place.placeId ?? "0";
//                       final detail = await plist.getDetailsByPlaceId(placeid);
//                       final geometry = detail.result.geometry!;
//                       final lat = geometry.location.lat;
//                       final lang = geometry.location.lng;
//                       var newlatlang = LatLng(lat, lang);
//                       //move map camera to selected place with animation
//                       mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
//                     }
//                   },
//                   child:Padding(
//                     padding: EdgeInsets.all(15),
//                     child: Card(
//                       child: Container(
//                           padding: EdgeInsets.all(0),
//                           width: MediaQuery.of(context).size.width - 40,
//                           child: ListTile(
//                             title:Text(location, style: TextStyle(fontSize: 18),),
//                             trailing: Icon(Icons.search),
//                             dense: true,
//                           )
//                       ),
//                     ),
//                   )
//               )
//           )]),
//
//       // on pressing floating action button the camera will take to user current location
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async{
//           getUserCurrentLocation().then((value) async {
//             print(value.latitude.toString() +" "+value.longitude.toString());
//             // marker added for current users location
//             _markers.add(
//                 Marker(
//                   markerId: MarkerId("2"),
//                   position: LatLng(value.latitude, value.longitude),
//                   infoWindow: InfoWindow(
//                     title: 'My Current Location',
//                   ),
//                 )
//             );
//             // specified current users location
//             CameraPosition cameraPosition = new CameraPosition(
//               target: LatLng(value.latitude, value.longitude),
//               zoom: 14,
//             );
//
//             final GoogleMapController controller = await _controller.future;
//             controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//             setState(() {
//             });
//           });
//         },
//         child: Icon(Icons.local_activity),
//       ),
//     );
//   }
// }
//
//
//
//
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
// import 'package:your_places_autocomplete_package/places_autocomplete.dart';

import '../utils/app_constants.dart';

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String selectedPlace = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Search Autocomplete'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Place: $selectedPlace',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Prediction? p;
                try{
                p = await PlacesAutocomplete.show(
                    offset: 0,
                    radius: 1000,
                    strictbounds: false,
                    region: "us",
                    language: "en",
                    context: context,
                    mode: Mode.overlay,
                    // apiKey:"5cba00b8femshcef2e31c8c84b55p1a7e64jsn0e43052b6af8",
                    apiKey:"AIzaSyAuPVmFZkg54S-cfFn9LWAhz_gseok4CKQ",
                    components: [new Component(Component.country, "us")],
                    types: ["(cities)"],
                    hint: "Search City",onError:(e){print("!!!!!!!!!!!!!!!!$e");}
                );
                }catch(e){
                  print("(((((((((((((((((($e");
                }

                if (p != null) {
                  print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
                  setState(() {
                    selectedPlace = p!.description!;
                  });
                }
              },
              child: Text('Search for a place'),
            ),
          ],
        ),
      ),
    );
  }
}
