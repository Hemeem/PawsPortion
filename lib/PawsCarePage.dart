import 'package:flutter/material.dart';
import 'package:pawsportion/AddPawsCarePage.dart';

class PawsCarePage extends StatelessWidget {
  final List<CareItem> careItems = [
    CareItem(
      title: 'Water',
      time: '10:00',
      description: 'Isi Air buat Miko',
      reminder: 'Mon, Tue, Wed, Thu, Fri, Sat',
      icon: Icons.water_drop,
      color: Colors.blue,
    ),
    CareItem(
      title: 'Vet',
      time: '12:30',
      description: 'Vaksin di Dr. Veri, Sukajadi',
      reminder: 'Mon, Tue, Wed, Thu, Fri, Sat',
      icon: Icons.local_hospital,
      color: Colors.red,
    ),
    CareItem(
      title: 'Grooming',
      time: '16:00',
      description: 'Datang ke rumah nanti',
      reminder: 'Tue',
      icon: Icons.pets,
      color: Colors.orange,
    ),
    CareItem(
      title: 'Clean',
      time: '06:30',
      description: 'Supaya tidak dehidrasi',
      reminder: 'Daily',
      icon: Icons.cleaning_services,
      color: Colors.green,
    ),
    CareItem(
      title: 'Food',
      time: '06:30',
      description: 'Kasih makan Dry Food',
      reminder: 'Daily',
      icon: Icons.fastfood,
      color: Colors.purple,
    ),
    CareItem(
      title: 'Food',
      time: '18:30',
      description: 'Kasih makan Ikan dan Nasi',
      reminder: 'Daily',
      icon: Icons.fastfood,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PawsCare',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: careItems.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(height: 20.0); // Spacing at the top
          }
          final item = careItems[index - 1];
          return Container(
            margin: EdgeInsets.symmetric(
                vertical: 6.0), // Mengatur margin lebih besar
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.grey), // Menambahkan garis pinggir
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    5.0), // Menambahkan padding agar card lebih besar
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0), // Mengatur jarak antar tulisan
                  leading: Icon(item.icon, size: 40, color: item.color),
                  title: Text(
                    item.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4), // Menambahkan jarak antar tulisan
                      Text('${item.time} - ${item.description}'),
                      SizedBox(height: 2),
                      Text('Reminder: ${item.reminder}'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPawsCarePage()),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

class CareItem {
  final String title;
  final String time;
  final String description;
  final String reminder;
  final IconData icon;
  final Color color;

  CareItem({
    required this.title,
    required this.time,
    required this.description,
    required this.reminder,
    required this.icon,
    required this.color,
  });
}
