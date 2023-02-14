import 'package:flutter/material.dart';

class MedicalBill {
  String patientName;
  String patientAddress;
  String hospitalName;
  DateTime dateOfService;
  double billAmount;

  MedicalBill({
    required this.patientName,
    required this.patientAddress,
    required this.hospitalName,
    required this.dateOfService,
    required this.billAmount,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MedicalBill> _bills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Bill List'),
      ),
      body: ListView.builder(
        itemCount: _bills.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Patient Name: ${_bills[index].patientName}'),
                  Text('Patient Address: ${_bills[index].patientAddress}'),
                  Text('Hospital Name: ${_bills[index].hospitalName}'),
                  Text('Date of Service: ${_bills[index].dateOfService}'),
                  Text('Bill Amount: ${_bills[index].billAmount}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPage(bills: _bills),
            ),
          ).then((value) {
            setState(() {
              // refresh state of HomePage
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  final List<MedicalBill> bills;
  FormPage({required this.bills});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final MedicalBill _bill = MedicalBill(
      patientName: "",
      patientAddress: "",
      hospitalName: "",
      dateOfService: DateTime.now(),
      billAmount: 0);

  Future _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _bill.dateOfService = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medical Bill'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _bill.patientName = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Address'),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter the patient address';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _bill.patientAddress = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Hospital Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the hospital name';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _bill.hospitalName = value!;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  _bill.dateOfService == null
                      ? 'No Date Chosen'
                      : 'Date of Service: ${_bill.dateOfService.toString()}',
                ),
              ),
              ElevatedButton(
                onPressed: _pickDate,
                child: Text('Choose Date'),
              ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Date of Service'),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter the date of service';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     setState(() {
              //       _bill.dateOfService = value!;
              //     });
              //   },
              // ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Bill Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter the bill amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _bill.billAmount = double.parse(value!);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.bills.add(_bill);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Bill App',
      home: HomePage(),
    );
  }
}
