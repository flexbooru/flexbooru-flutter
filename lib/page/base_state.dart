import 'package:flutter/material.dart';
import 'package:flexbooru/helper/settings.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> with ActiveBooruListener {
  
  @override
  void initState() {
    super.initState();
    Settings.instance.registerActiveBooruListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    Settings.instance.unregisterActiveBooruListener(this);
  }

}