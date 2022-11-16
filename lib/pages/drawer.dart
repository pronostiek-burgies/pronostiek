import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/controllers/base_page_controller.dart';
import 'package:pronostiek/controllers/login_controller.dart';
import 'package:pronostiek/controllers/register_controller.dart';
import 'package:pronostiek/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';



class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              ListTile(
                tileColor: wcRed,
                iconColor: Colors.white,
                trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ),
              if (controller.isLogged) ...[
                UserAccountsDrawerHeader(
                  onDetailsPressed: () => controller.toggleDetailOpen(),
                  accountName: Text("${controller.user?.firstname ?? "???"} ${controller.user?.lastname ?? "???"}"),
                  accountEmail: Text(controller.user?.username ?? "??"),
                  currentAccountPicture: controller.user?.getProfilePicture(),
                )
              ],
              if (controller.detailsOpen) ...[
                Visibility(visible: kIsWeb, child: ListTile(
                  leading: SizedBox(width: Get.theme.iconTheme.size, child: controller.user!.getProfilePicture(border:false),),
                  trailing: const Icon(Icons.edit),
                  title: const Text("Change profile picture"),
                  onTap: () async {
                    XFile? pickedFile = await controller.picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile == null) {return;}
                    await controller.repo.saveProfilePicture(await pickedFile.readAsBytes());
                    controller.user!.customProfilePicture = true;
                    await controller.repo.saveUserDetails();
                    controller.user!.profilePicture = await controller.repo.getProfilePicture(controller.user!);
                    controller.update();
                  },
                )),
                ListTile(
                  leading: Icon(Icons.circle, color: controller.user!.color),
                  trailing: const Icon(Icons.edit),
                  title: const Text("Change profile color"),
                  onTap: () async {
                    Get.defaultDialog(
                      title: 'Pick a color!',
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: controller.user!.color,
                          onColorChanged: (Color color) => controller.setPickerColor(color),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Got it'),
                          onPressed: () async {
                            await controller.setColor(controller.pickerColor);
                            Get.back();
                          },
                        ),
                      ],
                    );                    
                  },
                ),
                const Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Dashboard"),
                onTap: () {
                  Get.find<BasePageController>().changeTabIndex(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                textColor: controller.isLogged && !(controller.user?.admin ?? true) ? null : Colors.grey,
                leading: const Icon(Icons.sports_soccer),
                title: const Text("My Pronostiek"),
                onTap: controller.isLogged && !(controller.user?.admin ?? false) ? () {
                    Get.find<BasePageController>().changeTabIndex(1);
                    Navigator.pop(context);
                  }
                  : (controller.user?.admin ?? false)
                    ? () => Get.defaultDialog(title: "No access to your pronostiek", content: const Text("Admin has no pronostiek."))
                    : () => Get.defaultDialog(title: "No access to your pronostiek", content: const Text("Log in to get access."))
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("Details"),
                onTap: () {
                  Get.find<BasePageController>().changeTabIndex(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.rule),
                title: const Text("Rules"),
                onTap: () {
                  Get.find<BasePageController>().changeTabIndex(3);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              if (controller.isLogged) ...[
                if (controller.user?.admin ?? false) ...[
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text("Admin"),
                    onTap: () {
                      Get.find<BasePageController>().changeTabIndex(4);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                ],
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log out"),
                  onTap: () {
                    Get.find<BasePageController>().changeTabIndex(0);
                    controller.logout();
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  trailing: controller.loginOpen ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                  onTap: () => controller.toggleLogin(),
                ),
                if (controller.loginOpen) ...[
                  GetBuilder<LoginController>(
                    global: false,
                    init: LoginController(),
                    builder: (controller) {
                      return Form(
                        key: controller.loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: controller.usernameController,
                              keyboardType: TextInputType.name,
                              validator: (username) {
                                if (username!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter username",
                                labelText: "Username",
                                prefixIcon: Icon(Icons.account_circle),
                              ),
                            ),
                            TextFormField(
                              controller: controller.passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter password",
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            OutlinedButton(
                              onPressed: controller.busy ? null : () async {
                                await controller.login();
                              },
                              child: controller.busy ? const CircularProgressIndicator() : const Text("Login"),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text("Register"),
                  trailing: controller.registerOpen ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                  onTap: () => controller.toggleRegister(),
                ),
                if (controller.registerOpen) ...[
                  GetBuilder<RegisterController>(
                    global: false,
                    init: RegisterController(),
                    builder: (controller) {
                      return Form(
                        key: controller.loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: controller.usernameController,
                              keyboardType: TextInputType.name,
                              validator: (username) {
                                if (username!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter username",
                                labelText: "Username",
                                prefixIcon: Icon(Icons.account_circle),
                              ),
                            ),
                            TextFormField(
                              controller: controller.firstnameController,
                              keyboardType: TextInputType.name,
                              validator: (firstname) {
                                if (firstname!.isEmpty) {
                                  return 'Please enter a firstname';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter firstname",
                                labelText: "firstname",
                                prefixIcon: Icon(Icons.perm_identity),
                              ),
                            ),
                            TextFormField(
                              controller: controller.lastnameController,
                              keyboardType: TextInputType.name,
                              validator: (lastname) {
                                if (lastname!.isEmpty) {
                                  return 'Please enter a lastname';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter lastname",
                                labelText: "lastname",
                                prefixIcon: Icon(Icons.perm_identity)
                              ),
                            ),
                            TextFormField(
                              controller: controller.passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter password",
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            TextFormField(
                              controller: controller.passwordController2,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return 'Please repeat password';
                                }
                                if (controller.passwordController.text !=
                                    controller.passwordController2.text) {
                                  return "Password does not match";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter password",
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            OutlinedButton(
                              onPressed: controller.busy ? null : () {
                                controller.register();
                              },
                              child: controller.busy ? const CircularProgressIndicator() : const Text("Register"),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ],
              ]
            ],
          ),
        );
      }
    );
  }
}
