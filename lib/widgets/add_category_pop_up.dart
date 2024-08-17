import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/color_constants.dart';
import '../controllers/transactions_controller.dart';

addCategoryPopup({required context}) {
  TextEditingController titleController = TextEditingController();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add a Category'),
        content: ListView(
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
        actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          GetBuilder<TransactionsController>(
            init: TransactionsController(),
            builder: (controller) => TextButton(
              child: const Text('add'),
              onPressed: () {
                controller.addCategory(name: titleController.text);
                Get.back();
              },
            ),
          ),
        ],
      );
    },
  );
}
