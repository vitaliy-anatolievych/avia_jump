import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';

import 'load_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    const MaterialApp(
      home: LoadPage(),
    ),
  );
}
