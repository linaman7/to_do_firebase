import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:to_do_firebase/constants/app_style.dart';
import 'package:to_do_firebase/model/todo_model.dart';
import 'package:to_do_firebase/provider/Date_time_provider.dart';
import 'package:to_do_firebase/provider/radio_provider.dart';
import 'package:to_do_firebase/provider/service_provider.dart';
import 'package:to_do_firebase/widget/date_time_widget.dart';
import 'package:to_do_firebase/widget/radio_widget.dart';
import 'package:intl/intl.dart';
import 'package:to_do_firebase/widget/textfield_widget.dart';

final timeControllerProvider = StateProvider<String>((ref) => '');

class AddNewTask extends ConsumerStatefulWidget {
  AddNewTask({Key? key}) : super(key: key);

  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

final titleController = TextEditingController();
final descriptionController = TextEditingController();

class _AddNewTaskState extends ConsumerState<AddNewTask> {
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController();
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateProv = ref.watch(dateProvider);
    final String time = ref.watch(timeControllerProvider);

    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'Nouvelle Note',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Divider(
              thickness: 1.2,
              color: Colors.grey.shade200,
            ),
            const Gap(12),

            const Text(
              'Title Task',
              style: AppStyle.headingOne,
            ),
            TextFieldWidget(
              maxLine: 1,
              hintText: 'Add Task Name',
              txtController: timeController,
            ),
            const Gap(12),
            const Text('Description', style: AppStyle.headingOne),
            const Gap(6),
            TextFieldWidget(
              maxLine: 5,
              hintText: 'Add Description',
              txtController: descriptionController,
            ),
            const Gap(12),
            const Text('Category', style: AppStyle.headingOne),

            Row(
              children: [
                Expanded(
                  child: RadioWidget(
                    categColor: Colors.green,
                    titleRadio: 'LRN',
                    valueInput: 1,
                    onChangeValue: () =>
                        ref.read(radioProvider.notifier).update((state) => 1),
                  ),
                ),
                Expanded(
                  child: RadioWidget(
                    categColor: Colors.blueAccent,
                    titleRadio: 'Work',
                    valueInput: 2,
                    onChangeValue: () =>
                        ref.read(radioProvider.notifier).update((state) => 2),
                  ),
                ),
                Expanded(
                  child: RadioWidget(
                    categColor: Colors.purple,
                    titleRadio: 'Fun',
                    valueInput: 3,
                    onChangeValue: () =>
                        ref.read(radioProvider.notifier).update((state) => 3),
                  ),
                ),
              ],
            ),

            const Gap(16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DateTimeWidget(
                    titleText: 'Date',
                    ValueText: dateProv,
                    iconSection: CupertinoIcons.calendar,
                    onTap: () async {
                      final getValue = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025));
                      if (getValue != null) {
                        final format = DateFormat.yMd();
                        ref
                            .read(dateProvider.notifier)
                            .update((state) => format.format(getValue));
                      }
                    },
                  ),
                ),
                const Gap(22),
                Expanded(
                  child: DateTimeWidget(
                    titleText: 'Time',
                    ValueText: ref.watch(timeProvider),
                    iconSection: CupertinoIcons.clock,
                    onTap: () async {
                      final getTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (getTime != null) {
                        ref
                            .read(timeProvider.notifier)
                            .update((state) => getTime.format(context));
                      }
                    },
                  ),
                ),
              ],
            ),

            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.blue.shade800),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final getRadioValue = ref.read(radioProvider);
                      String category = '';

                      switch (getRadioValue) {
                        case 1:
                          category = 'Learning';
                          break;
                        case 2:
                          category = 'Working';
                          break;
                        case 3:
                          category = 'Fun';
                          break;
                      }
                      ref.read(serviceProvider).addNewTask(TodoModel(
                          titleTask: titleController.text,
                          description: descriptionController.text,
                          category: category,
                          dateTask: ref.read(dateProvider),
                          timeTask: ref.read(timeProvider),
                        isDone: false,
                      ));
                      print('Data is saving');
                      titleController.clear();
                      descriptionController.clear();
                      ref.read(radioProvider.notifier).update((state) => 0);
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
