import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountDetailWidget extends StatefulWidget {
  final String farmId;

  const AccountDetailWidget({super.key, required this.farmId});

  @override
  AccountDetailWidgetState createState() => AccountDetailWidgetState();
}

class AccountDetailWidgetState extends State<AccountDetailWidget> {
  late Future<Map<String, dynamic>> _accountDetails;

  @override
  void initState() {
    super.initState();
    _accountDetails = _fetchAccountDetails(widget.farmId);
  }

  Future<Map<String, dynamic>> _fetchAccountDetails(String farmId) async {
    final firestore = FirebaseFirestore.instance;
    DocumentSnapshot farmDoc =
        await firestore.collection('farms').doc(farmId).get();
    var farmData = farmDoc.data() as Map<String, dynamic>;
    return farmData['accountDetails'] as Map<String, dynamic>;
  }

  void _showUpdateDialog(Map<String, dynamic> accountDetails) {
    showDialog(
      context: context,
      builder: (context) => UpdateAccountDialog(
        farmId: widget.farmId,
        accountDetails: accountDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _accountDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child:
                  Text(AppLocalizations.of(context)!.error_fetching_details));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child: Text(AppLocalizations.of(context)!.no_details_found));
        }

        var accountDetails = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(184, 181, 181, 1),
                    offset: Offset(2, 2),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    blurStyle: BlurStyle.normal),
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  offset: Offset(-0, -1),
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.green,
              ),
              title: Text(accountDetails['accountName'] ??
                  AppLocalizations.of(context)!.no_details_found),
              subtitle: Text(accountDetails['bankName'] ?? ''),
              trailing: IconButton(
                icon: const Icon(CupertinoIcons.forward),
                onPressed: () => _showUpdateDialog(accountDetails),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UpdateAccountDialog extends StatefulWidget {
  final String farmId;
  final Map<String, dynamic> accountDetails;

  const UpdateAccountDialog(
      {super.key, required this.farmId, required this.accountDetails});

  @override
  UpdateAccountDialogState createState() => UpdateAccountDialogState();
}

class UpdateAccountDialogState extends State<UpdateAccountDialog> {
  late TextEditingController _accountNameController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;

  @override
  void initState() {
    super.initState();
    _accountNameController =
        TextEditingController(text: widget.accountDetails['accountName'] ?? '');
    _bankNameController =
        TextEditingController(text: widget.accountDetails['bankName'] ?? '');
    _accountNumberController = TextEditingController(
        text: widget.accountDetails['accountNumber'] ?? '');
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _updateAccountDetails() async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('farms').doc(widget.farmId).update({
        'accountDetails': {
          'accountName': _accountNameController.text,
          'bankName': _bankNameController.text,
          'accountNumber': _accountNumberController.text,
        }
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account details updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update account details: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Account Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _accountNameController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.account_name),
          ),
          TextField(
            controller: _bankNameController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.bank_name),
          ),
          TextField(
            controller: _accountNumberController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.account_number),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: _updateAccountDetails,
          child: Text(AppLocalizations.of(context)!.update),
        ),
      ],
    );
  }
}
