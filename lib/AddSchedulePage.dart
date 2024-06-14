import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final List<String> _hours =
      List.generate(24, (index) => index.toString().padLeft(2, '0'));
  final List<String> _minutes =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  int _selectedHour = 7;
  int _selectedMinute = 0;
  int _portions = 15;
  List<bool> _isSelected = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Schedule',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Save schedule logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 6),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedHour = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    _hours[index],
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: _selectedHour == index
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              childCount: _hours.length,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 1,
                            height: 150,
                            margin: EdgeInsets.only(bottom: 1),
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedMinute = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    _minutes[index],
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: _selectedMinute == index
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              childCount: _minutes.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Repeat', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChoiceChip(0, 'Monday'),
                          SizedBox(width: 45),
                          _buildChoiceChip(1, 'Tuesday'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChoiceChip(2, 'Wednesday'),
                          SizedBox(width: 40),
                          _buildChoiceChip(3, 'Thursday'),
                          SizedBox(width: 40),
                          _buildChoiceChip(4, 'Friday'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChoiceChip(5, 'Saturday'),
                          SizedBox(width: 45),
                          _buildChoiceChip(6, 'Sunday'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wrapped the content with a Column widget
                  Text('Portion(s)', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height:
                            70, // Menambahkan height untuk menyamakan tinggi dengan tombol
                        child: IconButton(
                          icon: Icon(Icons.remove_circle,
                              color: Colors.red, size: 60),
                          onPressed: () {
                            setState(() {
                              if (_portions > 1) _portions--;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal:
                                20), // Tetapkan padding untuk kotak porsi
                        child: Center(
                          child: Text(
                            _portions.toString(),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height:
                            70, // Menambahkan height untuk menyamakan tinggi dengan tombol
                        child: IconButton(
                          icon: Icon(Icons.add_circle,
                              color: Colors.green, size: 60),
                          onPressed: () {
                            setState(() {
                              _portions++;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Text('1 Portion = 10g',
                      style: TextStyle(fontSize: 17, color: Colors.grey)),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(int index, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _isSelected[index],
      onSelected: (bool selected) {
        setState(() {
          _isSelected[index] = selected;
        });
      },
      selectedColor: Colors.blue,
    );
  }
}
