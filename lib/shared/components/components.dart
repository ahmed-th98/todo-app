import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/shared/components/cosntants.dart';
import 'package:newsapp/shared/cubit/cubit.dart';

Widget defaultFormField({
  required String label,
  required IconData prefix,
  required TextEditingController controller,
  required TextInputType type,
  required Function onSubmit,
  Null Function()? onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit(),
      onTap: onTap,
      enabled: isClickable,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return ' empty';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(
          prefix,
          color: Colors.purple[200],
        ),
      ),
    );

Widget buidTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple[200],
              child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box_outlined,
                  color: Colors.purple[200],
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archived', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Color.fromARGB(255, 33, 33, 33),
                )),
          ],
        ),
      ),
    );
