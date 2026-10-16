import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router/app_router.dart';
import 'viewmodels/home_viewmodel.dart';

class MonitoresApp extends StatelessWidget {
  const MonitoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: MaterialApp.router(
        title: 'Monitores DCOMP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2457C5),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}