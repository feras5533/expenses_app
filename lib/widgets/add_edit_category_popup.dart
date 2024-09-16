import 'package:flutter/material.dart';

import '/common/color_constants.dart';
import '/controllers/categories_controller.dart';

addEditCategoryPopup({
  required BuildContext context,
  required String funcType,
  String docId = '',
}) {
  TextEditingController titleController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add a Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: titleController,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
                decoration: const InputDecoration(
                  hintText: "Enter The Category Name",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Done'),
            onPressed: () async {
              CategoriesController request =
                  CategoriesController(context: context);
              switch (funcType) {
                case 'add':
                  await request.addCategory(name: titleController.text);

                case 'edit':
                  await request.editCategory(
                      docId: docId, name: titleController.text);
                  break;
                default:
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
