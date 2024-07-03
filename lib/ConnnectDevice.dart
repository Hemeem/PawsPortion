import 'package:flutter/material.dart';
import 'package:pawsportion/main.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';



class WelcomeDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PawsPortion Feeder'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDevicePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDevicePage()),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle, size: 50, color: Colors.orange),
                    SizedBox(height: 10),
                    Text(
                      'ADD DEVICE',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add a device to get started',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  bool _isConnected = false;
  String? _currentSSID;
  bool _isCheckingConnection = false;

  @override
  void initState() {
    super.initState();
    _initializeConnection();
  }

  void _initializeConnection() async {
    await _requestLocationPermission();
    await _updateConnectionStatus();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      // Permission granted, proceed with WiFi check
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Needed'),
        content: Text('This app requires location permission to access WiFi networks. Please enable it in the app settings.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateConnectionStatus() async {
    setState(() {
      _isCheckingConnection = true;
    });

    try {
      String? connectionSSID = await WiFiForIoTPlugin.getSSID();
      setState(() {
        _currentSSID = connectionSSID;
        _isConnected = connectionSSID == 'PawsPortion';
        _isCheckingConnection = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingConnection = false;
      });
      print('Error checking connection: $e');
    }
  }

  void _onWifiButtonPressed() {
    if (!_isConnected) {
      _updateConnectionStatus();
    } else {
      _showWifiWarning();
    }
  }

  void _showWifiWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("WiFi Connection Needed"),
          content: Text("Please connect to the 'PawsPortion' WiFi network to proceed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD DEVICE'),
        leading: IconButton( 
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Turn on WiFi',
                suffixIcon: Icon(Icons.wifi),
              ),
              onTap: _onWifiButtonPressed,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Current SSID: ${_currentSSID ?? "Not connected"}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _updateConnectionStatus,
            child: Text('Check Connection'),
          ),
          SizedBox(height: 20),
          if (_isConnected)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConnectDevicePage()),
                );
              },
              child: Text('Next'),
            ),
          SizedBox(height: 50),
          Center(
            child: Column(
              children: [
                if (_isCheckingConnection)
                  CircularProgressIndicator()
                else
                  Icon(Icons.wifi_tethering, size: 50, color: Colors.blue),
                SizedBox(height: 20),
                Text(
                  'Searching for nearby devices...',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Keep your phone within 50 cm from the device',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD DEVICE'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('PawsPortion Feeder'),
            trailing: Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealPageWithBottomNav()),
              );
            },
          ),
        ],
      ),
    );
  }
}
