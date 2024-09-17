import 'package:expenses_app/common/prints.dart';
import 'package:expenses_app/controllers/transactions_controller.dart';
import 'package:flutter/material.dart';

import '/common/color_constants.dart';

editTransactionPopup({
  required BuildContext context,
  required String docId,
  required String oldname,
  required String oldPrice,
}) {
  TextEditingController titleController = TextEditingController(text: oldname);
  TextEditingController priceController = TextEditingController(text: oldPrice);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Your Transaction'),
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
                  hintText: "Enter The Transaction Name",
                ),
              ),
              TextFormField(
                controller: priceController,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
                decoration: const InputDecoration(
                  hintText: "Enter The Transaction price",
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
            child: const Text('Edit'),
            onPressed: () async {
              TransactionsController request =
                  TransactionsController(context: context);

              await request.editTransaction(
                docId: docId,
                name: titleController.text.isNotEmpty
                    ? titleController.text
                    : oldname,
                price: priceController.text.isNotEmpty
                    ? priceController.text
                    : oldPrice,
              );
              // printWarning(titleController.text);
              // printWarning(priceController.text);
              // printWarning(oldname);
              // printWarning(oldPrice);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
