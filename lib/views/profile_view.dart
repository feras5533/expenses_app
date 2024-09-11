import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/user_controller.dart';
import '/common/images_urls.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_snackbar.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/custom_scaffold.dart';
import '/controllers/auth_controller.dart';
import '/common/color_constants.dart';
import '/models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  bool isEditing = false;
  bool isHidden = true;
  CollectionReference<UserModel>? data;

  getUserData() async {
    UserController request = UserController(context: context);
    data = await request.getUserData();
    setState(() {
      isLoading = false;
    });
  }

  void signOut() {
    AuthController request = AuthController(context: context);
    request.signout();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return customScaffold(
      toolbarHeight: height * 0.1,
      appBarTitle: appBar(width: width),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ))
          : StreamBuilder<QuerySnapshot<UserModel>>(
              stream: data!.where('id', isEqualTo: userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ));
                } else {
                  List<UserModel> userList =
                      snapshot.data!.docs.map((doc) => doc.data()).toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                height: height * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset(
                                  ImagesUrls.profileImage,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  customDialog(
                                      title:
                                          'This feature is not available yet',
                                      context: context);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                },
                                icon: Row(
                                  children: [
                                    const Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    const Icon(
                                      Icons.edit,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          userList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: userList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final UserModel user = userList[index];
                                    _userNameController.text = user.name!;
                                    _phoneController.text = user.phoneNumber!;
                                    _emailController.text = FirebaseAuth
                                        .instance.currentUser!.email!;
                                    return customFields(
                                        height: height, width: width);
                                  },
                                )
                              : customFields(height: height, width: width),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  customFields({
    required height,
    required width,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name'),
        CustomTextField(
          hintText: 'User Name',
          controller: _userNameController,
          isEnabled: isEditing,
        ),
        SizedBox(
          height: height * 0.025,
        ),
        const Text('Email'),
        CustomTextField(
          hintText: 'Email',
          controller: _emailController,
          isEnabled: isEditing,
        ),
        SizedBox(
          height: height * 0.025,
        ),
        const Text('Phone Number'),
        CustomTextField(
          hintText: 'Phone Number',
          controller: _phoneController,
          isEnabled: isEditing,
        ),
        SizedBox(
          height: height * 0.025,
        ),
        const Text('Password'),
        CustomTextField(
          hintText: 'Password',
          controller: _passwordController,
          lastField: true,
          isEnabled: isEditing,
          isPassword: true,
          isHidden: isHidden,
        ),
        SizedBox(
          height: height * 0.025,
        ),
        if (isEditing)
          CustomButton(
            title: 'Edit',
            width: width * 1,
            onPressed: () {},
          ),
      ],
    );
  }

  appBar({
    width,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Row(
                children: [
                  const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  const Icon(
                    Icons.output_sharp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
