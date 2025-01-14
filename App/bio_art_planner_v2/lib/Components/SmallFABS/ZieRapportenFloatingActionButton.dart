import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Views/Admin/Rapport_Screen.dart';
import '../../models/globalProvider.dart';

class RapportsFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;
  final DateTime selectedDate;

  const RapportsFloatingActionButton({
    super.key,
    required this.keyFab,
    required this.selectedDate
  });

  @override
  State<RapportsFloatingActionButton> createState() => _RapportsFloatingActionButtonState();
}

class _RapportsFloatingActionButtonState extends State<RapportsFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "RapportFab",
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            final rapports = context.watch<GlobalProvider>().rapportsForToday;
            return rapports.isEmpty
                ? const Center(child: Text("No rapports available"))
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: rapports.length,
              itemBuilder: (context, index) {
                final rapport = rapports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(rapport.title),
                    trailing: GestureDetector(
                      onTap: (){
                        context.read<GlobalProvider>().deleteRapport(rapport.rapportId!, widget.selectedDate );
                      },
                      child: FaIcon(FontAwesomeIcons.deleteLeft, color: Colors.redAccent.shade700,),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RapportScreen(rapport: rapport),
                        ),
                      ).then((__){

                      });
                    },
                  ),
                );
              },
            );
          },
        ).whenComplete(() => widget.keyFab.currentState?.toggle());
      },
      child: Icon(Icons.file_copy),
    );
  }
}
