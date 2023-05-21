import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookie_app/utils/themeProvider.dart';
import 'package:cookie_app/cookie.appbar.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkModeEnabled = themeProvider.isDarkModeEnabled;

    return Scaffold(
      appBar: CookieAppBar(title: '테마'),
      body: Column(
        children: [
          ListTile(
            title: const Text('밝은 테마'),
            leading: Radio(
              value: false,
              groupValue: isDarkModeEnabled,
              onChanged: (value) {
                themeProvider.toggleDarkMode();
              },
            ),
          ),
          ListTile(
            title: const Text('어두운 테마'),
            leading: Radio(
              value: true,
              groupValue: isDarkModeEnabled,
              onChanged: (value) {
                themeProvider.toggleDarkMode();
              },
            ),
          ),
        ],
      ),
    );
  }
}
