import 'package:flutter/material.dart';

import 'screen/home_page.dart';

void main() {
  runApp(mainapp());
}
Widget mainapp(){
  return
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
      '/': (context) => HomePage(),
      },
    );
}

