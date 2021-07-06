import 'package:agenda_manager_app/model/agenda.dart';
import 'package:agenda_manager_app/ui/homepage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';

class Add extends StatelessWidget {
  final String text;
  final int indexAgenda;

  Add(this.text, [this.indexAgenda = 0]);
  @override
  Widget build(BuildContext context) {
    TextEditingController judulController = new TextEditingController();
    TextEditingController deskripsiController = new TextEditingController();
    TextEditingController waktuController = new TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
                alignment: Alignment(-0.9, -0.85),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF42A5F5),
                  ),
                  iconSize: 35,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage(text :"OP");
                        },
                      ),
                    );
                  },
                )),
            Container(
                alignment: Alignment(0, -0.5),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 20,
                      fontWeight: FontWeight.bold),
                )),
            FutureBuilder(
              future: Hive.openBox("agendas"),
              builder: (context, snapshot) {
                var agendas = Hive.box("agendas");
                Agenda agenda = agendas.getAt(indexAgenda);
                if (text == "Edit") {
                  judulController.text = agenda.judul;
                  deskripsiController.text = agenda.deskripsi;
                  waktuController.text = agenda.waktu;
                }
                return Column(
                  children: [
                    Spacer(),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 30),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextField(
                            controller: judulController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              hintText: "Judul",
                              labelText: "Judul",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          TextField(
                            controller: deskripsiController,
                            maxLength: 100,
                            decoration: InputDecoration(
                              hintText: "Deskripsi",
                              labelText: "Deskripsi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          TextField(
                            controller: waktuController,
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintText: "dd-MM-yyyy",
                              labelText: "Waktu",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      child: RaisedButton(
                          child: Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xFF42A5F5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          onPressed: () {
                            (text == "Add")
                                ? agendas.add(Agenda(
                                    judulController.text,
                                    deskripsiController.text,
                                    waktuController.text,
                                    false)
                                    )
                                : agendas.putAt(
                                    indexAgenda,
                                    Agenda(
                                        judulController.text,
                                        deskripsiController.text,
                                        waktuController.text,
                                        agenda.isDone));
                            if(text=="Add"){
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return HomePage(text :"OP");
                              }),
                            );
                          }),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      
    );
  }
}
