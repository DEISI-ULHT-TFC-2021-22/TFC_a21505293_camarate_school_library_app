import 'package:camarate_school_library/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

final ZoomDrawerController _controlarZoomMenuLateral = ZoomDrawerController();

class _MenuLateralState extends State<MenuLateral> {
  @override
  Widget build(BuildContext context) {
    //
    return ZoomDrawer(
      menuBackgroundColor: Colors.blue,
      controller: _controlarZoomMenuLateral,
      borderRadius: 10.0,
      style: DrawerStyle.defaultStyle,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.50,
      duration: const Duration(milliseconds: 500),
      angle: 0.0,
      mainScreen: const Home(),
      menuScreen: const CamposMenuLateral(),
    );
  }
}

class _CamposMenuLateralState extends State<CamposMenuLateral> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        children: const [],
      ),
    );
  }
}

class MenuLateral extends StatefulWidget {
  const MenuLateral({Key? key}) : super(key: key);

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class CamposMenuLateral extends StatefulWidget {
  const CamposMenuLateral({Key? key}) : super(key: key);

  @override
  State<CamposMenuLateral> createState() => _CamposMenuLateralState();
}
