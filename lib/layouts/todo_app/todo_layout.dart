import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/modules/archived-tasks/archived_tasks_screen.dart';
import 'package:newsapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:newsapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:newsapp/shared/components/cosntants.dart';
import 'package:newsapp/shared/cubit/cubit.dart';
import 'package:newsapp/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/components/components.dart';

class TodoLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertToDBState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex] + ' Tasks'),
              backgroundColor: Colors.purple[200],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDBLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(
                  child: CircularProgressIndicator(color: Colors.purple[200])),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.purple[200],
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertTodatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.grey[100],
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    label: 'Task title',
                                    prefix: Icons.title,
                                    type: TextInputType.text,
                                    onSubmit: () {},
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    label: 'Task time',
                                    prefix: Icons.watch_later_outlined,
                                    type: TextInputType.datetime,
                                    onSubmit: () {},
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    label: 'Task date',
                                    prefix: Icons.date_range_outlined,
                                    type: TextInputType.datetime,
                                    onSubmit: () {},
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-12-12'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.purple[200],
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.chageIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New Tasks',
                  backgroundColor: Colors.purple[200],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done Tasks',
                  backgroundColor: Colors.purple[200],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived Tasks',
                  backgroundColor: Colors.purple[200],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
