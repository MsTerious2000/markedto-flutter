import 'package:flutter/material.dart';
import 'package:marketdo_flutter/models/user_model.dart';
import 'package:marketdo_flutter/service.dart';
import 'package:marketdo_flutter/widgets/colors.dart';
import 'package:marketdo_flutter/widgets/dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void addUser(BuildContext context) {
    var data = {
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    Services.addUser(data, context);
    clearFields();
  }

  void updateUser(
    BuildContext context,
    String id,
    String name,
  ) {
    var data = {
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    Services.updateUser(context, id, data);
  }

  void deleteUser(
    BuildContext context,
    String id,
    String name,
  ) {}

  void clearFields() {
    _nameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarketDo CRUD'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false),
        child: FutureBuilder(
          future: Services.getUsers(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<User> users = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text('${users[index].name}\n${users[index].email}'),
                    subtitle: Text(users[index].id),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _nameController.text = users[index].name;
                            _emailController.text = users[index].email;
                            _passwordController.text = users[index].password;
                            showDialog(
                              context: context,
                              builder: (updateUserDialog) => AlertDialog(
                                scrollable: true,
                                title: Text(
                                  'UPDATE USER',
                                  style: TextStyle(color: darkblue),
                                ),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    formTextField(
                                        _nameController, 'NAME', Icons.person),
                                    formTextField(
                                        _emailController, 'EMAIL', Icons.email),
                                    formTextField(_passwordController,
                                        'PASSWORD', Icons.password),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(updateUserDialog),
                                    child: Text('CANCEL',
                                        style: TextStyle(color: gray)),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: darkblue,
                                    ),
                                    onPressed: () {
                                      if (_nameController.text.isEmpty ||
                                          _emailController.text.isEmpty ||
                                          _passwordController.text.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (addFailedDialog) =>
                                              errorDialog(
                                            'Failed to add user! Please do not leave a blank!',
                                            addFailedDialog,
                                          ),
                                        );
                                      } else {
                                        updateUser(
                                          context,
                                          users[index].id,
                                          users[index].name,
                                        );
                                        Navigator.pop(updateUserDialog);
                                      }
                                    },
                                    child: Text('UPDATE',
                                        style: TextStyle(color: white)),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: darkblue),
                        ),
                        IconButton(
                          onPressed: () {
                            confirmDialog(
                                context, 'Delete user?\n${users[index].name}');
                            deleteUser(
                              context,
                              users[index].id,
                              users[index].name,
                            );
                          },
                          icon: Icon(Icons.delete, color: darkred),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (addUserDialog) => AlertDialog(
            scrollable: true,
            title: Text(
              'ADD USER',
              style: TextStyle(color: darkgreen),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                formTextField(_nameController, 'NAME', Icons.person),
                formTextField(_emailController, 'EMAIL', Icons.email),
                formTextField(_passwordController, 'PASSWORD', Icons.password),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(addUserDialog);
                  clearFields();
                },
                child: Text('CANCEL', style: TextStyle(color: gray)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: darkgreen,
                ),
                onPressed: () {
                  if (_nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (addFailedDialog) => errorDialog(
                        'Failed to add user! Please do not leave a blank!',
                        addFailedDialog,
                      ),
                    );
                  } else {
                    addUser(context);
                    Navigator.pop(addUserDialog);
                  }
                },
                child: Text('ADD', style: TextStyle(color: white)),
              ),
            ],
          ),
        ),
        backgroundColor: darkgreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget formTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    bool hidePassword = false;
    if (controller == _passwordController) {
      hidePassword = true;
    } else {
      hidePassword = false;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: hidePassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(label),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
