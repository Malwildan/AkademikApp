import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PairedDevicesPage extends StatefulWidget {
  @override
  _PairedDevicesPageState createState() => _PairedDevicesPageState();
}

class _PairedDevicesPageState extends State<PairedDevicesPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  List<String> _connectionHistory = [];
  BluetoothDevice? _selectedDevice;
  bool _isConnecting = false;
  bool _isBluetoothConnected = false;

  @override
  void initState() {
    super.initState();
    _refreshPage(); // Refresh the page on initial load
    _loadConnectionHistory(); // Load connection history
  }

  Future<void> _refreshPage() async {
    // Method to refresh the Bluetooth connection status and paired devices
    await _checkBluetoothConnection();
    await _getPairedDevices();
    setState(() {});
  }

  Future<void> _checkBluetoothConnection() async {
    try {
      _isBluetoothConnected = await bluetooth.isConnected == true;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check Bluetooth connection: $e')),
      );
    }
  }

  Future<void> _getPairedDevices() async {
    try {
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get paired devices: $e')),
      );
    }
  }

  Future<void> _loadConnectionHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _connectionHistory = prefs.getStringList('connectionHistory') ?? [];
    });
  }

  Future<void> _saveConnectionHistory(String deviceAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _connectionHistory.add(deviceAddress);
    await prefs.setStringList('connectionHistory', _connectionHistory);
  }

  void _connectToDevice(BluetoothDevice device) async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
    });

    try {
      if (_isBluetoothConnected) {
        await bluetooth.disconnect();
      }

      await bluetooth.connect(device);
      await _saveConnectionHistory(device.address!); // Save the device address to the history
      Navigator.pop(context, device); // Return the selected device to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to device: $e')),
      );
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paired Devices'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPage, // Refresh the page state when the refresh icon is pressed
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isBluetoothConnected)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Bluetooth is connected', style: TextStyle(color: Colors.green)),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Bluetooth is not connected', style: TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _devices[index];
                bool isConnected = _connectionHistory.contains(device.address);
                return ListTile(
                  title: Text(device.name ?? 'Unknown device'),
                  subtitle: Text(device.address ?? 'No address'),
                  trailing: isConnected ? Icon(Icons.check, color: Colors.green) : null,
                  onTap: () => _connectToDevice(device),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
