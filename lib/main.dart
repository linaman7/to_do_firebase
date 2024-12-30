import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_firebase/common/show_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_firebase/view/home_page.dart';
import 'package:to_do_firebase/widget/card_todo_Widget.dart';

import 'firebase_options.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();

  // ...

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Project Template',
        theme: ThemeData(),
        home: HomePage(),
      ),
    ),
  );
}

