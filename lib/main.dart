import 'package:flutter/material.dart';

void main() {
  runApp(RefuelApp());
}

class RefuelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Výpočet spotřeby paliva',
      home: RefuelScreen(),
    );
  }
}

class Refuel { // New record
  final double tachometer;
  final double fuel;

  final String date;
  final double price;
  final String notes;
  final double consuption;

  Refuel({
    required this.tachometer,
    required this.fuel,

    required this.date,
    required this.price,
    required this.notes,
    required this.consuption,
  });
}

class RefuelScreen extends StatefulWidget {
  @override
  RefuelScreenState createState() => RefuelScreenState();
}

class RefuelScreenState extends State<RefuelScreen> {
  final TextEditingController tachometerController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();

  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime date = DateTime.now();
  List<Refuel> RefuelList = [];

  @override
  void initState() {
    super.initState();
    dateInputController.text = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void addRefuel() {
    final tachometer = double.tryParse(tachometerController.text);
    final fuel = double.tryParse(fuelController.text);

    final date = dateInputController.text;
    final price = double.tryParse(priceController.text);
    final notes = notesController.text;

    if (tachometer != null && fuel != null && price != null) {
      setState(() {
        double consuption = (fuel / tachometer) * 100; // l/100km

        RefuelList.add( //Add new Refuel
          Refuel(
            date: date,
            tachometer: tachometer,
            fuel: fuel,
            price: price,
            notes: notes,
            consuption: consuption,
          ),
        );

        tachometerController.clear(); // Clear all textinputs
        fuelController.clear();
        DateTime now = DateTime.now();
        dateInputController.text = '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}'; //padLeft makes 03 instead of 3
        priceController.clear();
        notesController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nejsou vyplněna všechna pole!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotřeba a tankování paliva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Container v Bootstrapu
        child: Column(
          children: [
            TextField(
              controller: dateInputController,
              readOnly: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: tachometerController,
              decoration: InputDecoration(
                labelText: 'Stav tachometeru (km)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: fuelController,
              decoration: InputDecoration(
                labelText: 'Množství paliva (l)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Cena za litr (Kč)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Poznámka',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: addRefuel,
              child: Text('Uložit nové tankování'),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: RefuelList.length,
                itemBuilder: (context, index) {
                  final Refuel = RefuelList[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Dne: ${Refuel.date}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text(
                          'Spotřeba: ${Refuel.consuption.toStringAsFixed(2)} l/100 km\n'
                          'Najeto: ${Refuel.tachometer} km\n'
                              'Paliva: ${Refuel.fuel} l\n'
                              'Cena: ${Refuel.price} Kč/l\n'
                              'Poznámky: ${Refuel.notes}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}