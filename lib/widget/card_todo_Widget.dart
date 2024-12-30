import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../provider/service_provider.dart';

class CardTodoListWidget extends ConsumerWidget {
  final int getIndex;

  const CardTodoListWidget({
    Key? key,
    required this.getIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchStreamProvider);

    return todoData.when(
      data: (todoData) {
        Color categoryColor = Colors.white;
        final getCategory = todoData[getIndex].category;

        // Simplified switch statement
        switch (getCategory) {
          case 'Learning':
          case 'Working':
            categoryColor = Colors.green;
            break;
          case 'Fun':
            categoryColor = Colors.amber.shade700;
            break;
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: IconButton(icon: Icon(CupertinoIcons.delete),onPressed: ()=> ref.read(serviceProvider).deleteTask(todoData[getIndex].docID),),
                        title: Text(todoData[getIndex].titleTask,maxLines: 1,
                        style: TextStyle(decoration: todoData[getIndex].isDone? TextDecoration.lineThrough:null
                        ),
                        ),
                        subtitle: Text(todoData[getIndex].description,maxLines: 1,
                        style: TextStyle(decoration: todoData[getIndex].isDone? TextDecoration.lineThrough:null
                       ),),
                        trailing: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.blue.shade800,
                            shape: const CircleBorder(),
                            value: todoData[getIndex].isDone,
                            onChanged: (value) {
                              // Update task only if value is not null
                              if (value != null) {
                                ref.read(serviceProvider).updateTask(todoData[getIndex].docID, value);
                              }
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: Column(
                          children: [
                            const Divider(
                              thickness: 1.5,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                Text('Samedi'),
                                Gap(12),
                                Text(todoData[getIndex].timeTask),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error\nStackTrace: $stackTrace',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
