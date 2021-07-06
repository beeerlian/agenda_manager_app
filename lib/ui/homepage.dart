import 'package:agenda_manager_app/model/agenda.dart';
import 'package:agenda_manager_app/ui/addpage.dart';
import 'package:agenda_manager_app/ui/agenda_calendar.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class HomePage extends StatefulWidget {
  String text;

  HomePage({required this.text});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateTerm,
    );

    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage(text: "OP");
                }));
              }
              int sensi = 1;
              if (details.delta.dx < -sensi) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage(text: "Done");
                }));
              }
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Agendaku",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(Icons.lightbulb_outline,
                          color: Colors.yellow.shade700, size: 30),
                      onPressed: () async {
                        await popup.recolor(Colors.blue);
                        popup.show(
                          title: 'Get Started',
                          content:
                              '\nPetunjuk Penggunaan \n\n1. Untuk menambah agenda, klik tombol Add\n2. Klik agenda untuk edit\n3. Slide agenda ke arah kiri untuk menghapus\n4. Klik icon jam untuk menandai agenda telah selesai\nTerimakasih telah menggunakan aplikasi ini :) ',
                          actions: [
                            popup.button(
                              label: 'Close',
                              onPressed: Navigator.of(context).pop,
                            ),
                          ],
                          // bool barrierDismissible = false,
                          // Widget close,
                        );
                      })
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, __, ___) =>
                                HomePage(text: "Done"),
                            transitionDuration: Duration(seconds: 0),
                          ));
                    },
                    icon: Icon(Icons.access_time_filled,
                        color: (widget.text == "Done"
                            ? Colors.red
                            : Colors.black))),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, __, ___) =>
                                HomePage(text: "OP"),
                            transitionDuration: Duration(seconds: 0),
                          ));
                    },
                    icon: Icon(
                      Icons.done,
                      color:
                          (widget.text == "OP" ? Colors.green : Colors.black),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 600,
            child: FutureBuilder(
                future: Hive.openBox("agendas"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      var agendasBox = Hive.box("agendas");
                      if (agendasBox.isEmpty) {
                        agendasBox.add(Agenda("Rapat", "Rapat Karang Taruna",
                            "12/12/2021", false));
                      } 
                      // else if (agendasBox.length == 1) {
                      //   agendasBox.add(Agenda("Mager Time",
                      //       "Menonton Jujutsu No Kaisen", "15/12/2021", false));
                      // }
                      return WatchBoxBuilder(
                        box: agendasBox,
                        builder: (context, agendas) => Container(
                          child: (agendas.length != 0)
                              ? ListView.builder(
                                  itemCount: agendas.length,
                                  itemBuilder: (context, index) {
                                    bool x;
                                    (widget.text == "OP")
                                        ? x = false
                                        : x = true;
                                    Agenda agenda = agendas.getAt(index);
                                    if (agenda.isDone != x) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: SwipeActionCell(
                                          key: ObjectKey(agenda),

                                          ///this key is necessary
                                          trailingActions: <SwipeAction>[
                                            SwipeAction(
                                                icon: Icon(
                                                  Icons.delete_outline_outlined,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                                onTap: (CompletionHandler
                                                    handler) async {
                                                  await handler(true);
                                                  agendas.deleteAt(index);
                                                  setState(() {});
                                                },
                                                color: Colors.red),
                                          ],
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return Add("Edit", index);
                                                }),
                                              );
                                            },
                                            child: Card(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 7),
                                                            child: Text(
                                                              agenda.judul,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 7),
                                                            child: Text(
                                                              agenda.deskripsi,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 7),
                                                            child: Text(
                                                              agenda.waktu,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 11),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 7),
                                                            child: agenda.isDone
                                                                ? Text(
                                                                    "Done",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                : Text(
                                                                    "On Progress",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .yellow
                                                                            .shade900,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        IconButton(
                                                          icon: agenda.isDone
                                                              ? Icon(
                                                                  Icons.done,
                                                                  color: Colors
                                                                      .blue,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .access_time_filled,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                          onPressed: () {
                                                            agenda.isDone
                                                                ? agendas.putAt(
                                                                    index,
                                                                    Agenda(
                                                                      agenda
                                                                          .judul,
                                                                      agenda
                                                                          .deskripsi,
                                                                      agenda
                                                                          .waktu,
                                                                      false,
                                                                    ),
                                                                  )
                                                                : agendas.putAt(
                                                                    index,
                                                                    Agenda(
                                                                      agenda
                                                                          .judul,
                                                                      agenda
                                                                          .deskripsi,
                                                                      agenda
                                                                          .waktu,
                                                                      true,
                                                                    ),
                                                                  );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return Divider();
                                  },
                                )
                              : Container(
                                  padding: EdgeInsets.only(bottom: 200),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Anda tidak memiliki agenda apapun"),
                                        Text("Segera tambahkan"),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.list_alt_rounded, title: 'Agenda'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.date_range, title: 'Calendar'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) {
            if (i == 0) {
            } else if (i == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Add("Add");
              }));
            } else if (i == 2) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return CalendarScreen();
              }));
            }
          }),
    );
  }
}
