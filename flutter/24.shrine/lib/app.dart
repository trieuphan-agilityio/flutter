// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shrine/data/gallery_options.dart';

import 'backdrop.dart';
import 'category_menu_page.dart';
import 'expanding_bottom_sheet.dart';
import 'home.dart';
import 'login.dart';
import 'model/app_state_model.dart';
import 'page_status.dart';
import 'scrim.dart';
import 'supplemental/layout_cache.dart';
import 'theme.dart';

class ShrineApp extends StatefulWidget {
  const ShrineApp();

  static const String loginRoute = '/shrine/login';
  static const String homeRoute = '/shrine';

  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> with TickerProviderStateMixin {
  // Controller to coordinate both the opening/closing of backdrop and sliding
  // of expanding bottom sheet
  AnimationController _controller;

  // Animation Controller for expanding/collapsing the cart menu.
  AnimationController _expandingController;

  AppStateModel _model;

  final Map<String, List<List<int>>> _layouts = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );
    _expandingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _model = AppStateModel()..loadProducts();
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget home = Builder(
      builder: (context) => LayoutCache(
        layouts: _layouts,
        child: PageStatus(
          menuController: _controller,
          cartController: _expandingController,
          child: HomePage(
            backdrop: _buildBackdrop(context),
            scrim: Scrim(controller: _expandingController),
            expandingBottomSheet: ExpandingBottomSheet(
              hideController: _controller,
              expandingController: _expandingController,
            ),
          ),
        ),
      ),
    );

    return ScopedModel<AppStateModel>(
      model: _model,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
          title: 'Shrine',
          debugShowCheckedModeBanner: false,
          initialRoute: ShrineApp.loginRoute,
          onGenerateInitialRoutes: (_) {
            return [
              MaterialPageRoute<void>(
                builder: (context) => const LoginPage(),
              ),
            ];
          },
          routes: {
            ShrineApp.loginRoute: (context) => const LoginPage(),
            ShrineApp.homeRoute: (context) => home,
          },
          theme: shrineTheme.copyWith(
            platform: GalleryOptions.of(context).platform,
          ),
          // L10n settings.
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: GalleryOptions.of(context).locale,
        ),
      ),
    );
  }

  Widget _buildBackdrop(BuildContext context) {
    return Backdrop(
      frontLayer: const ProductPage(),
      backLayer: CategoryMenuPage(onCategoryTap: () => _controller.forward()),
      frontTitle: const Text('SHRINE'),
      backTitle: Text(AppLocalizations.of(context).shrineMenuCaption),
      controller: _controller,
    );
  }

  // Closes the bottom sheet if it is open.
  Future<bool> _onWillPop() async {
    final status = _expandingController.status;
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.forward) {
      await _expandingController.reverse();
      return false;
    }

    return true;
  }
}
