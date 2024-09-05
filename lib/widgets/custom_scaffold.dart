import 'package:flutter/material.dart';

import '/common/color_constants.dart';

customScaffold({
  toolbarHeight,
  appBarTitle,
  body,
}) {
  return Scaffold(
    appBar: AppBar(
      title: appBarTitle,
      toolbarHeight: toolbarHeight,
      backgroundColor: AppTheme.white,
      surfaceTintColor: AppTheme.white,
      elevation: 10,
      shadowColor: AppTheme.grey.withOpacity(0.08),
    ),
    body: body,
  );
}
