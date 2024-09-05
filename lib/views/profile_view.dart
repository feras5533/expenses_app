import 'package:expenses_app/common/images_urls.dart';
import 'package:expenses_app/widgets/custom_button.dart';
import 'package:expenses_app/widgets/custom_snackbar.dart';
import 'package:expenses_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_scaffold.dart';
import '/common/color_constants.dart';
import '/controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _userNameController =
      TextEditingController(text: 'Feras Atiyat');
  final TextEditingController _emailController =
      TextEditingController(text: 'feras@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+962790363835');
  final TextEditingController _passwordController =
      TextEditingController(text: '12345678');

  bool isEditing = false;

  signOut() {
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
      body: SingleChildScrollView(
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
                    // color: AppTheme.grey,
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
                        title: 'This feature is not available yet',
                        context: context);
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.04,
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
                        style: TextStyle(fontWeight: FontWeight.bold),
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
            ListView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              shrinkWrap: true,
              children: [
                Text('Name'),
                CustomTextField(
                  hintText: 'User Name',
                  controller: _userNameController,
                  isProfileField: true,
                  isEnabled: isEditing,
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Text('Email'),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  isProfileField: true,
                  isEnabled: isEditing,
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Text('Phone Number'),
                CustomTextField(
                  hintText: 'Phone Number',
                  controller: _phoneController,
                  isProfileField: true,
                  isEnabled: isEditing,
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Text('Password'),
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isProfileField: true,
                  lastField: true,
                  isEnabled: isEditing,
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                if (isEditing)
                  CustomButton(
                    title: 'Edit',
                    onPressed: () {},
                  )
              ],
            ),
          ],
        ),
      ),
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
