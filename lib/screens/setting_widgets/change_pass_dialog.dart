import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ChangePasswordDialogState createState() => ChangePasswordDialogState();
}

class ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  Future<void> _changePassword(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      try {
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: _oldPasswordController.text,
          ),
        );
        await user.updatePassword(_newPasswordController.text);
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green.shade100,
              content: Text(
                  AppLocalizations.of(context)!.password_changed_successfully)),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content:
                  Text(AppLocalizations.of(context)!.password_change_failed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Center(
        child: Text(
          AppLocalizations.of(context)!.change_password,
          style: GoogleFonts.sansita(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.old_password,
                        border: InputBorder.none,
                        labelStyle: GoogleFonts.sansita()),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_old_password;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.new_password,
                        border: InputBorder.none,
                        labelStyle: GoogleFonts.sansita()),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.new_password;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _confirmNewPasswordController,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.confirm_new_password,
                        border: InputBorder.none,
                        labelStyle: GoogleFonts.sansita()),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .confirm_new_password_instruction;
                      }
                      if (value != _newPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .passwords_do_not_match;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const Spacer(),
        MaterialButton(
          color: Colors.green.shade100,
          elevation: 18,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _changePassword(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.change_password,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
