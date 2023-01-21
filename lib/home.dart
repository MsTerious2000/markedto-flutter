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
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _username = TextEditingController();

  void addUser(BuildContext context) {
    var data = {
      "firstName": _firstName.text.toUpperCase(),
      "middleName": _middleName.text.toUpperCase(),
      "lastName": _lastName.text.toUpperCase(),
      "username": _username.text,
    };

    Services.addUser(data, context);
    clearFields();
  }

  void updateUser(BuildContext context, String id) {
    var data = {
      "firstName": _firstName.text.toUpperCase(),
      "middleName": _middleName.text.toUpperCase(),
      "lastName": _lastName.text.toUpperCase(),
      "username": _username.text,
    };

    Services.updateUser(context, id, data);
  }

  void deleteUser(BuildContext context, String id) {
    Services.deleteUser(context, id);
  }

  void clearFields() {
    _firstName.text = '';
    _middleName.text = '';
    _lastName.text = '';
    _username.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAMPLE CRUD'),
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
              return const Center(child: CircularProgressIndicator());
            } else {
              List<User> users = snapshot.data;
              return users.isEmpty
                  ? const Center(child: Text('EMPTY RECORD!'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 50),
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(
                              '${users[index].lastName}, ${users[index].firstName} ${users[index].middleName}'),
                          subtitle: Text(users[index].username),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _firstName.text = users[index].firstName;
                                  _middleName.text = users[index].middleName;
                                  _lastName.text = users[index].lastName;
                                  _username.text = users[index].username;
                                  showDialog(
                                    context: context,
                                    builder: (updateUserDialog) => AlertDialog(
                                      scrollable: true,
                                      title: Text(
                                        'UPDATE USER',
                                        style: TextStyle(color: darkblue),
                                      ),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          formTextField(
                                              _firstName, 'FIRST NAME'),
                                          formTextField(
                                              _middleName, 'MIDDLE NAME'),
                                          formTextField(_lastName, 'LAST NAME'),
                                          formTextField(_username, 'USERNAME'),
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
                                            if (_firstName.text.isEmpty ||
                                                _lastName.text.isEmpty ||
                                                _username.text.isEmpty) {
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
                                                  context, users[index].id);
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
                                  showDialog(
                                    context: context,
                                    builder: (deleteUserDialog) => AlertDialog(
                                      scrollable: true,
                                      title: Text(
                                        'DELETE USER',
                                        style: TextStyle(color: darkred),
                                      ),
                                      content: Text(
                                          'FIRST NAME: ${users[index].firstName}\nMIDDLE NAME: ${users[index].middleName}\nLAST NAME: ${users[index].lastName}\nUSERNAME: ${users[index].username}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(deleteUserDialog),
                                          child: Text('CANCEL',
                                              style: TextStyle(color: gray)),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: darkred,
                                          ),
                                          onPressed: () {
                                            deleteUser(
                                                context, users[index].id);
                                            Navigator.pop(deleteUserDialog);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(color: white),
                                          ),
                                        ),
                                      ],
                                    ),
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
                formTextField(_firstName, 'FIRST NAME'),
                formTextField(_middleName, 'MIDDLE NAME'),
                formTextField(_lastName, 'LAST NAME'),
                formTextField(_username, 'USERNAME'),
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
                  if (_firstName.text.isEmpty ||
                      _lastName.text.isEmpty ||
                      _username.text.isEmpty) {
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
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(label),
        ),
      ),
    );
  }
}
