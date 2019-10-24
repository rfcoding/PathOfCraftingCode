
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatchFusingsDialog extends StatefulWidget{

  static Future<int> showBatchFusingDialog(BuildContext context) async {
    int numberOfFusings = await showDialog(context: context, builder: (BuildContext context) => fusingsDialog(context));
    return numberOfFusings != null ? numberOfFusings : 0;
  }

  static Dialog fusingsDialog(
      BuildContext context) {
    return Dialog(child: BatchFusingsDialog());
  }

  @override
  State<StatefulWidget> createState() {
    return BatchFusingsDialogState();
  }
}

class BatchFusingsDialogState extends State<BatchFusingsDialog> {
  final _formKey = GlobalKey<FormState>();
  static int previouslySelectedValue;
  int numberOfFusings = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 24),
          Text("How many fusings do you want to use?", style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
          SizedBox(height: 24),
          _numberOfFusingsForm(),
          SizedBox(height: 24),
          RaisedButton(
            child: Text("Go!"),
            onPressed: () => _validateAndReturn(),
          ),
          SizedBox(height: 24),

        ],
      ),
    );
  }

  Widget _numberOfFusingsForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onSaved: (input) {
          numberOfFusings = int.parse(input);
        },
        initialValue: previouslySelectedValue != null ? previouslySelectedValue.toString() : '100',
        validator: (text) {
          if (text.isEmpty) {
            return "Number of Fusings cannot be empty";
          }
          int value = int.parse(text);
          if (value > 0 && value <= 100000) {
            previouslySelectedValue = value;
            return null;
          }
          return "Number of fusings has to be between 1 and 100000";
        },
        autovalidate: true,
      ),
    );
  }

  void _validateAndReturn() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop(numberOfFusings);
    }
  }

}