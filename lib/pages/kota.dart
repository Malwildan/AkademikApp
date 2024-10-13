///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:myapp/pages/editKota.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/pages/tambahKota.dart';

class KotaPage extends StatefulWidget {
  @override
  State<KotaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<KotaPage> {
  TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  Future<List<Map<String, dynamic>>> fetchSiswaList() async {
    final response = await supabase.from('kota').select('id, Nama');

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3d58e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Kota",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: 24),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TambahKota())),
                icon:
                    Icon(Icons.add_circle, color: Color(0xffffffff), size: 24)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: TextField(
              controller: searchController,
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
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide(color: Color(0xffa9a7a7), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide(color: Color(0xffa9a7a7), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide(color: Color(0xffa9a7a7), width: 1.5),
                ),
                hintText: "Pencarian",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xffaaa8a8),
                ),
                filled: true,
                fillColor: Color(0xffefeeee),
                isDense: false,
                contentPadding: EdgeInsets.fromLTRB(20, 8, 12, 8),
                suffixIcon:
                    Icon(Icons.search, color: Color(0xffb0afaf), size: 24),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchSiswaList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found.'));
                } else {
                  List<Map<String, dynamic>> siswaList = snapshot.data!;

                  String searchQuery = searchController.text.toLowerCase();
                  List<Map<String, dynamic>> filteredSiswaList =
                      siswaList.where((kota) {
                    final nama = kota['Nama']?.toLowerCase() ?? '';

                    return nama.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                      itemCount: filteredSiswaList.length,
                      itemBuilder: (context, index) {
                        final kota = filteredSiswaList[index];
                        final nama = kota['Nama'] ?? 'Unknown';

                        return Card(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          color: Color(0xff3b57e7),
                          shadowColor: Color(0x00939393),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side:
                                BorderSide(color: Color(0x4d9e9e9e), width: 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          nama,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                   IconButton(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:951211980.
                                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditKota(id: kota['id']))),
                                     icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xffffffff),
                                      size: 24,
                                                                       ),
                                   ),
                                
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => TambahKota()));
            },
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            backgroundColor: Colors.amber,
          ),
        ],
      ),
    );
  }
}
