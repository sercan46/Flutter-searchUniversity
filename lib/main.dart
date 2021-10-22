// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_university/models/university_model.dart';
import 'package:http/http.dart' as http;
import 'package:search_university/provider/isshowtext.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => IsShowTextField()),
      ], child: MyApp()),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      supportedLocales: [Locale('en')],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UniversityVM> _universityVM = [];
  final TextEditingController _universityName = TextEditingController();
  String countryName = "";
  @override
  void initState() {
    super.initState();
    _universityName.text = "";
    countryName = "United States";
    getUniversity('United States').then((res) {
      _universityVM = res;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.read<IsShowTextField>().isShowText =
                    !context.read<IsShowTextField>().isShowText;
              },
              icon: Icon(Icons.search))
        ],
        centerTitle: true,
        titleTextStyle: TextStyle(),
        title: Text(
          'University Search',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Consumer<IsShowTextField>(builder: (_, isShow, __) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isShow.isShowText == true
                  ? Expanded(
                      flex: 2,
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 23),
                          child: TextFormField(
                            controller: _universityName,
                            maxLength: 20,
                            enabled: true,
                            cursorColor: Colors.purple,
                            decoration: InputDecoration(
                              hintText: "University Name",
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              hintStyle: TextStyle(fontWeight: FontWeight.bold),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 25,
                            right: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                      onPressed: () {
                                        getUniversityName(countryName)
                                            .then((value) {
                                          setState(() {
                                            _universityVM = value;
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.arrow_right,
                                        color: Colors.purple,
                                        size: 50,
                                      )),
                                ),
                              ],
                            ))
                      ]),
                    )
                  : Container(),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, left: 23),
                    child: Text('Select Country',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )),
              Expanded(
                flex: 2,
                child: CountryCodePicker(
                    onChanged: (value) {
                      _universityName.text = "";
                      _onChangeCountry(value);
                      countryName = value.name!;
                    },
                    initialSelection: 'US',
                    favorite: ['DE', 'GB', 'US'],
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    flagWidth: 65,
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              Expanded(
                flex: 7,
                child: _universityVM.length > 0
                    ? ListView.builder(
                        itemCount: _universityVM.length,
                        itemBuilder: (BuildContext context, index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.purple[200],
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  height: 150,
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.purple[400],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _universityVM[index]
                                                  .alphaTwoCode
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Icon(
                                                    Icons.apartment,
                                                    size: 30,
                                                    color: Colors.black,
                                                  )),
                                              Expanded(
                                                  flex: 6,
                                                  child: Text(
                                                    _universityVM[index]
                                                        .name
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.5),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.purple[100],
                                          height: 20,
                                          endIndent: 30,
                                          indent: 30,
                                          thickness: 2,
                                        ),
                                        Column(
                                          children: [
                                            Row(children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Icon(
                                                    Icons.school,
                                                    size: 20,
                                                    color: Colors.black,
                                                  )),
                                              Expanded(
                                                  flex: 6,
                                                  child: Text(
                                                    _universityVM[index]
                                                        .domains![0]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  )),
                                            ]),
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: Icon(
                                                      Icons.public,
                                                      size: 20,
                                                      color: Colors.black,
                                                    )),
                                                Expanded(
                                                    flex: 6,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        launch(
                                                            _universityVM[index]
                                                                .webPages![0]
                                                                .toString());
                                                      },
                                                      child: Text(
                                                        _universityVM[index]
                                                            .webPages![0]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                    ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        })
                    : Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://cdn.pixabay.com/photo/2018/01/04/15/51/404-error-3060993_960_720.png',
                        ),
                      ),
              )
            ],
          ),
        );
      }),
    );
  }

  _onChangeCountry(CountryCode value) {
    getUniversity(value.name!).then((e) {
      _universityVM = e;
      setState(() {});
    });
  }

  Future<List<UniversityVM>> getUniversity(String country) async {
    String getCountry = "";
    List<String> filterCountry;
    var isArray = country.indexOf('[');
    if (isArray != -1) {
      filterCountry = country.split(',');
      getCountry = filterCountry[0].replaceAll('[', '');
      if (getCountry == "United States of America") {
        getCountry = "United States";
      }
    } else {
      getCountry = country;
    }

    List<UniversityVM> myModels;
    var url = Uri.parse(
        'http://universities.hipolabs.com/search?country=${getCountry}');
    var response = await http.get(url);

    myModels = (json.decode(response.body) as List)
        .map((i) => UniversityVM.fromJson(i))
        .toList();
    return myModels;
  }

  Future<List<UniversityVM>> getUniversityName(String country) async {
    print(country);
    _universityVM = [];
    String getCountry = "";
    List<String> filterCountry;
    var isArray = country.indexOf('[');
    if (isArray != -1) {
      filterCountry = country.split(',');
      getCountry = filterCountry[0].replaceAll('[', '');
      if (getCountry == "United States of America") {
        getCountry = "United States";
      }
    } else {
      getCountry = country;
    }
    print(getCountry);
    print(_universityName.text);
    List<UniversityVM> myModels;
    var url = Uri.parse(
        'http://universities.hipolabs.com/search?country=${getCountry}&name=${_universityName.text}');
    var response = await http.get(url);

    myModels = (json.decode(response.body) as List)
        .map((i) => UniversityVM.fromJson(i))
        .toList();
    return myModels;
  }
}
