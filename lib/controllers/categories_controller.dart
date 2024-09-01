import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/common/color_constants.dart';
import 'transactions_controller.dart';

class CategoriesController {
  BuildContext context;
  CategoriesController({
    required this.context,
  });

  addCategoryPopup(
      //  {function,}
      ) {
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
                Get.back();
              },
            ),
            TextButton(
              child: const Text('add'),
              onPressed: () {
                TransactionsController request = TransactionsController();
                request.addCategory(name: titleController.text);
                // function;
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
