import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:loomeive/loomeive.dart';
import 'package:loomeive/widgets/menu.widget.dart';
import 'package:miss_minutes/ui/settings/widgets/courses.widget.dart';
import 'package:miss_minutes/ui/settings/widgets/userdata.widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.arrowLeft),
                ),
                Expanded(
                  child: Text(
                    tr('settings.title').toSmartSentenceCase,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: MenuWidget(
                shrinkWrap: false,
                menuSections: [
                  MenuSection(
                    title: tr('settings.preferences').toSmartSentenceCase,
                    items: [
                      MenuItem(
                        label:
                            tr('settings.user_data.title').toSmartSentenceCase,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDataWidget(),
                              ),
                            ),
                        icon: Icon(LucideIcons.idCard),
                      ),
                      MenuItem(
                        label: tr('settings.courses.title').toSmartSentenceCase,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoursesWidget(),
                              ),
                            ),
                        icon: Icon(LucideIcons.waves),
                      ),
                      MenuItem(
                        label: 'Prezzario',
                        onTap: () => print("Config prezzi"),
                        icon: Icon(LucideIcons.coins),
                      ),
                    ],
                  ),
                  MenuSection(
                    title: "Impostazioni app",
                    items: [
                      MenuItem(
                        label: 'Lingua',
                        icon: CountryFlag.fromLanguageCode(
                          context.locale.languageCode,
                          theme: const ImageTheme(
                            shape: Circle(),
                            width: 24,
                            height: 24,
                          ),
                        ),
                        onTap: () => print("Lingua ${context.locale}"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
