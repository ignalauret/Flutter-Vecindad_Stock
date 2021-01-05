import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/dialog_header.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/home_page/components/employees_selector.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CreateTransactionDialog extends StatefulWidget {
  CreateTransactionDialog({this.editTransaction});
  final CashTransaction editTransaction;
  @override
  _CreateTransactionDialogState createState() =>
      _CreateTransactionDialogState();
}

class _CreateTransactionDialogState extends State<CreateTransactionDialog> {
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedEmployeeId;
  TransactionType selectedType = TransactionType.Extraction;
  bool isEdit = false;
  bool _tapped = false;

  @override
  void initState() {
    if (widget.editTransaction != null) {
      isEdit = true;
      priceController.text = widget.editTransaction.amount.toStringAsFixed(2);
      descriptionController.text = widget.editTransaction.description;
      selectedType = widget.editTransaction.type;
      selectedEmployeeId = widget.editTransaction.employeeId;
    }

    priceController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogHeader(isEdit ? "Editar Movimiento" : "Agregar Movimiento"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 130,
              width: 600,
              child: EmployeeSelector(selectedEmployeeId, (id) {
                setState(() {
                  selectedEmployeeId = id;
                });
              }),
            ),
            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     mainAxisSize: MainAxisSize.max,
            //     children: TransactionType.values
            //         .map((type) => _buildTypeSelector(type))
            //         .toList(),
            //   ),
            // ),
            Container(
              child: DropdownButton<TransactionType>(
                items: TransactionType.values
                    .sublist(1)
                    .map(
                      (type) => DropdownMenuItem<TransactionType>(
                        child: Text(
                          kTransactionTypesNames[type],
                          style: CustomStyles.kNormalStyle,
                        ),
                        value: type,
                      ),
                    )
                    .toList(),
                value: selectedType,
                onChanged: (type) {
                  setState(() {
                    selectedType = type;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              child: _buildFieldInput("Monto", priceController, false),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              child:
                  _buildFieldInput("Descripción", descriptionController, true),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          height: 80,
          width: 180,
          margin: const EdgeInsets.all(20),
          child: ActionButton(
            label: isEdit ? "Guardar" : "Agregar",
            fontSize: 25,
            enabled: !_tapped &&
                descriptionController.text.isNotEmpty &&
                priceController.text.isNotEmpty &&
                selectedEmployeeId != null,
            onTap: () {
              setState(() {
                _tapped = true;
              });
              if (isEdit) {
                context
                    .read<TransactionsProvider>()
                    .editTransaction(
                      context,
                      id: widget.editTransaction.id,
                      description: descriptionController.text,
                      date: widget.editTransaction.date,
                      type: selectedType,
                      amount: double.parse(priceController.text),
                      employee: selectedEmployeeId,
                    )
                    .then(
                      (value) => Navigator.of(context).pop(true),
                    );
              } else {
                context
                    .read<TransactionsProvider>()
                    .createTransaction(
                      context,
                      description: descriptionController.text,
                      date: DateTime.now(),
                      type: selectedType,
                      amount: double.parse(priceController.text),
                      employee: selectedEmployeeId,
                    )
                    .then(
                      (value) => Navigator.of(context).pop(),
                    );
              }
            },
          ),
        ),
      ],
    );
  }

  Container _buildFieldInput(
      String label, TextEditingController controller, bool lengthLimit) {
    return Container(
      child: Column(
        children: [
          TextField(
            maxLength: lengthLimit ? 30 : null,
            style: CustomStyles.kNormalStyle,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }
}
