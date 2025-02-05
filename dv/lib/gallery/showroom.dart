import 'package:dv/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'showroom_features/showroom_body.dart';
import 'showroom_features/showroom_header.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LogInProvider>(context);

    return Scaffold(
      appBar: showroomAppBar(context),
      body: loginProvider.isLoggedIn
          ? showroomBody(context)
          : showroomLoginCheck(context, loginProvider.isLoggedIn),
    );
  }
}
