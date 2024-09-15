import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/models/categories_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controllers/categories_controller.dart';
import '../widgets/add_edit_category_popup.dart';
import '/widgets/custom_scaffold.dart';
import '/common/color_constants.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({
    super.key,
  });

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    getCategoriesData();
    super.initState();
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;

  int activeMonth = 3;
  bool isLoading = true;
  CollectionReference<CategoriesModel>? categories;

  getCategoriesData() async {
    CategoriesController request = CategoriesController(context: context);
    categories = await request.getCategoriesData();
    setState(() {
      isLoading = false;
    });
  }

  addCategory() async {
    addEditCategoryPopup(
      context: context,
      funcType: 'add',
    );
  }

  editCategory({required String docId}) async {
    addEditCategoryPopup(
      context: context,
      docId: docId,
      funcType: 'edit',
    );
  }

  deleteCategory({required String docId}) {
    CategoriesController request = CategoriesController(context: context);
    request.deleteCategory(docId: docId);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return customScaffold(
      toolbarHeight: height * 0.1,
      appBarTitle: appBar(
        height: height,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : StreamBuilder<QuerySnapshot<CategoriesModel>>(
              stream: categories!.where('id', isEqualTo: userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> categoriesList =
                      snapshot.data!.docs.map((doc) {
                    return {
                      'data': doc.data(),
                      'id': doc.id,
                    };
                  }).toList();

                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      itemCount: categoriesList.length,
                      itemBuilder: (context, index) {
                        final CategoriesModel category =
                            categoriesList[index]['data'];
                        return customCategory(
                          height: height,
                          width: width,
                          name: category.name,
                          total: category.total,
                          percentage: category.percentage,
                          docId: categoriesList[index]['id'],
                        );
                      });
                } else {
                  return const Center(
                    child: Text('There is no Categories yet\n Try Adding some'),
                  );
                }
              }),
    );
  }

  customCategory({
    required double height,
    required double width,
    required String name,
    required double total,
    required double percentage,
    required String docId,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.03,
        right: width * 0.03,
        bottom: height * 0.015,
      ),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteCategory(docId: docId);
              },
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(15),
              ),
            ),
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(15),
              ),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: const Color(0xff67727d).withOpacity(0.6),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "\$$total",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${(percentage).toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: const Color(0xff67727d).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xff67727d).withOpacity(0.1),
                      ),
                    ),
                    Container(
                      width: percentage * 3,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: widget.categories[index]['color'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  appBar({
    height,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black),
            ),
            IconButton(
              onPressed: () {
                addCategory();
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
      ],
    );
  }
}
