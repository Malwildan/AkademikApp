import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendMessagePage extends StatefulWidget {
  final String nomor;

  SendMessagePage({required this.nomor});

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  @override
  void initState() {
    super.initState();
    GetToken();
    _numberController.text = widget.nomor;
  }

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // API Configuration
  final String baseUrl = 'https://id.nobox.ai';
  final String accountId = '602123638153989';
  String token = '';

  Future<void> GetToken() async {
    final url = Uri.parse('https://id.nobox.ai/AccountApi/GenerateToken');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": "ultrazyzz28@gmail.com",
          "password": "Sakkarep28",
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        token = responseData['token'];
      }
    } catch (e) {
      print('Gagal mengirim pesan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim pesan: $e')),
      );
    }
  }

  Future<void> sendMessageToAPI(String nomorTujuan, String pesan) async {
    final url = Uri.parse('$baseUrl/Inbox/Send');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "ExtId": nomorTujuan,
          "ChannelId": "1", // Channel ID untuk WhatsApp
          "AccountIds": accountId, // Masukkan ID akun yang didapat dari NoBox
          "BodyType": "Text",
          "Body": pesan,
          "Attachment": "" // Kosongkan jika tidak ada lampiran
        }),
      );

      if (response.statusCode == 200) {
        print('Pesan berhasil terkirim');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesan berhasil dikirim!')),
        );
      } else {
        print('Gagal mengirim pesan: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pesan: ${response.body}')),
        );
      }
    } catch (e) {
      print('Gagal mengirim pesan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim pesan: $e')),
      );
    }
  }

  void sendMessage() {
    final String number = _numberController.text;
    final String message = _messageController.text;

    if (number.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor tujuan dan pesan tidak boleh kosong')),
      );
      return;
    }

    sendMessageToAPI(number, message);

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirim Pesan Whatsapp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Tujuan',
                hintText: 'Contoh: 6281234567890',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Pesan',
                hintText: 'Masukkan pesan yang akan dikirim',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Kirim Pesan'),
            ),
          ],
        ),
      ),
    );
  }
}
