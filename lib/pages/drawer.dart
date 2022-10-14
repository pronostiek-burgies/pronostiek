import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/base_page_controller.dart';
import 'package:pronostiek/controllers/login_controller.dart';
import 'package:pronostiek/controllers/register_controller.dart';
import 'package:pronostiek/controllers/user_controller.dart';

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
              if (controller.isLogged) ...[
                UserAccountsDrawerHeader(
                  accountName: Text("${controller.user?.firstname ?? "???"} ${controller.user?.lastname ?? "???"}"),
                  accountEmail: Text(controller.user?.username ?? "??"),
                  currentAccountPicture: Container(
                    height: 46,
                    width: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      controller.user?.firstname.substring(0,1) ?? "?",
                      style: const TextStyle(fontSize: 45, color: Colors.white),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Dashboard"),
                  onTap: () {
                    Get.find<BasePageController>().changeTabIndex(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sports_soccer),
                  title: const Text("My Pronostiek"),
                  onTap: () {
                    Get.find<BasePageController>().changeTabIndex(1);
                    Navigator.pop(context);
                  },
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
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log out"),
                  onTap: () {
                    controller.logout();
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  trailing: controller.login_open ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                  onTap: () => controller.toggleLogin(),
                ),
                if (controller.login_open) ...[
                  GetBuilder<LoginController>(
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
                              onPressed: controller.busy ? null : () {
                                controller.login();
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
                  trailing: controller.register_open ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                  onTap: () => controller.toggleRegister(),
                ),
                if (controller.register_open) ...[
                  GetBuilder<RegisterController>(
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
