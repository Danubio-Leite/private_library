import 'package:flutter/material.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:private_library/components/custom_textformfield.dart';
import 'package:provider/provider.dart';

import '../../../helpers/user_db_helper.dart';
import '../../../models/user_model.dart';
import '../../../routes/routes.dart';

class AddUserPage extends StatefulWidget {
  final bool twoPop;
  const AddUserPage({super.key, this.twoPop = false});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (twoPop) {
        if (twoPop) {
          //Estudar addPostFrameCallback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add User'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 16.0,
          ),
          child: Column(
            children: [
              CustomFormField(label: 'Nome', controller: nameController),
              const SizedBox(height: 10),
              CustomFormField(
                  label: 'Telefone (opcional)', controller: phoneController),
              const SizedBox(height: 10),
              CustomFormField(
                  label: 'Email (opcional)', controller: emailController),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    final User user = User(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                    );
                    Provider.of<UserDbHelper>(context, listen: false)
                        .saveUser(user);
                    print(user.name);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: Color.fromARGB(255, 77, 144, 117),
                        content: Text('Usuário Adicionado com Sucesso'),
                      ),
                    );
                  },
                  texto: 'Gravar Usuário',
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
