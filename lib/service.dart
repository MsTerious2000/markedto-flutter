import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketdo_flutter/models/user_model.dart';
import 'package:marketdo_flutter/widgets/dialogs.dart';

class Services {
  static String baseUrl = 'http://60.60.2.137:2023';

  static addUser(
    Map mapBody,
    BuildContext context,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/users/addUser'),
        body: mapBody,
      );

      var data = jsonDecode(res.body.toString());
      if (data['success'] == true) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => successDialog(
                '${data["message"]}',
                context,
              )),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => errorDialog('${data["message"]}', context)),
        );
      }
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => errorDialog('$e', context)),
      );
    }
  }

  static getUsers(BuildContext context) async {
    List<User> users = [];

    try {
      final res = await http.get(Uri.parse('$baseUrl/users/getUsers'));
      var data = jsonDecode(res.body);

      if (data['success'] == true) {
        data['users'].forEach(
          (value) => {
            users.add(
              User(
                id: value['_id'],
                name: value['name'],
                email: value['email'],
                password: value['password'],
              ),
            ),
          },
        );
        return users;
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => errorDialog('${data["message"]}', context)),
        );
        return [];
      }
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => errorDialog('$e', context)),
      );
    }
  }

  static updateUser(BuildContext context, id, mapBody) async {
    try {
      final res = await http.patch(
        Uri.parse('$baseUrl/users/updateUser/$id'),
        body: mapBody,
      );
      var data = jsonDecode(res.body.toString());

      if (data['success'] == true) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => successDialog(
                '${data["message"]}',
                context,
              )),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => errorDialog(
                '${data["message"]}',
                context,
              )),
        );
      }
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => errorDialog('$e', context)),
      );
    }
  }

  static deleteUser(BuildContext context, String id) async {
    try {
      final res = await http.patch(Uri.parse('$baseUrl/users/deleteUser/$id'));
      var data = jsonDecode(res.body.toString());

      if (data['success'] == true) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => successDialog(
                '${data["message"]}',
                context,
              )),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => errorDialog(
                '${data["message"]}',
                context,
              )),
        );
      }
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => errorDialog('$e', context)),
      );
    }
  }
}
