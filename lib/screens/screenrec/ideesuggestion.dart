import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/screenrec/AddReclamation%20.dart';



class IdeeSuggestion extends StatelessWidget {
  final String type;

  IdeeSuggestion({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ideas and suggestions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildEtatCircle('In progress', Colors.orange),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddReclamation()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text(
                'Add reclamation',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEtatCircle(String etat, Color couleur) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: couleur,
          radius: 8.0,
        ),
        SizedBox(width: 8.0),
        Text(
          etat,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}