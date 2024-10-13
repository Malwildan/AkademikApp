///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:myapp/pages/kota.dart';
import 'package:myapp/pages/login.dart';

class EditKota extends StatefulWidget {
  int id;

  EditKota({required this.id});

  @override
  State<EditKota> createState() => _EditKotaState();
}

class _EditKotaState extends State<EditKota> {
  TextEditingController _namaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchKotaDetails();
  }

  void _fetchKotaDetails() async {
    final response =
        await supabase.from('kota').select().eq('id', widget.id).single() ;

    if (response != null) {
      setState(() {
        _namaController.text = response['Nama'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data not found')));
    }
  }

  void _updateKota() async {
    try {
      final response = await supabase.from('kota').update({
        'Nama': _namaController.text,
      }).eq('id', widget.id);

      if (response == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('City updated successfully')));

        Navigator.pop(context); // Go back to the previous page
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update city, $e')));
    }
  }

  void _deleteKota() async {
    try {
      final response = await supabase.from('kota').delete().eq('id', widget.id);

      if (response == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('City deleted successfully')));

        Navigator.pop(context); // Go back to the previous page
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete city, $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Edit Kota Asal",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                onPressed: () => _deleteKota(),
                icon: Icon(Icons.delete, color: Color(0xffffffff), size: 24)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          "Nama",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _namaController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: Color(0x00000000), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: Color(0x00000000), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: Color(0x00000000), width: 1),
                      ),
                      hintText: "Kota",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: Color(0xffdad8d8),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 40),
                    child: MaterialButton(
                      onPressed: () {
                        _updateKota();
                      },
                      color: Color(0xff3b58e8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Simpan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      textColor: Color(0xffffffff),
                      height: 40,
                      minWidth: 140,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
