import 'package:auto_calendar_reminder/domain/calendar_event_option.dart';
import 'package:auto_calendar_reminder/ext.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:auto_calendar_reminder/presentation/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/app_textfield.dart';

class AddOptionScreen extends StatefulWidget {
  static String pageName = 'addOptionScreen';

  const AddOptionScreen({super.key});

  @override
  State<AddOptionScreen> createState() => AddOptionScreenState();
}

@visibleForTesting
class AddOptionScreenState extends State<AddOptionScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _iconLinkController = TextEditingController();

  late final _actionsDataController =
      ActionsDataController(controller: context.appDataController);

  @override
  void initState() {
    super.initState();

    _actionsDataController.addListener(() {
      final state = _actionsDataController.state;

      if (state.successText != null) {
        context.showBanner(state.successText!);

        context.popScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events Options")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppTextField(
              controller: _nameController,
              label: "Option name",
            ),
            AppTextField(
              controller: _descriptionController,
              label: "Description",
            ),
            Row(
              children: [
                Flexible(
                  child: AppTextField(
                    controller: _iconLinkController,
                    label: "Icon link",
                  ),
                ),
                Flexible(
                  child: AppTextField(
                    onTap: () async {
                      final platform = Theme.of(context).platform;

                      if (platform == TargetPlatform.android) {
                        final now = DateTime.now();

                        final dateTime = await showDatePicker(
                          context: context,
                          initialDate: now.add(const Duration(days: 1)),
                          firstDate: now,
                          lastDate: now.add(
                            const Duration(days: 365 * 5),
                          ),
                        );

                        _dateController.text = dateTime?.toFormattedDate ?? '';
                      } else if (platform == TargetPlatform.iOS) {
                        _showCupertinoDatePickerDialog();
                      }
                    },
                    controller: _dateController,
                    label: "Reminder Date",
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                listenable: Listenable.merge(
                  [
                    _nameController,
                    _descriptionController,
                    _iconLinkController,
                    _dateController,
                    _actionsDataController,
                  ],
                ),
                enable: _enableButton,
                onPress: () {
                  _saveEventOption();
                },
                loading: () => _actionsDataController.state.loading,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _saveEventOption() {
    _actionsDataController.addEventOption(
      CalendarEventOption(
        optionName: _nameController.text,
        optionDescription: _descriptionController.text,
        icon: _iconLinkController.text,
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        dateTime: _dateController.text,
      ),
    );
  }

  bool _enableButton() {
    return !_actionsDataController.state.loading &&
        _hasText(_nameController) &&
        _hasText(_descriptionController) &&
        _hasText(_iconLinkController) &&
        _hasText(_dateController);
  }

  bool _hasText(TextEditingController controller) => controller.text.isNotEmpty;

  void _showCupertinoDatePickerDialog() {
    final now = DateTime.now();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: now.add(const Duration(days: 1)),
            mode: CupertinoDatePickerMode.date,
            minimumDate: now,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              _dateController.text = newDate.toFormattedDate;
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _iconLinkController.dispose();
    _actionsDataController.dispose();
    super.dispose();
  }
}
