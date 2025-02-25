import './chapter_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Évangiles en Latin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        elevation: 10,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey[50]!, Colors.blueGrey[100]!],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildBookTile(
              context,
              title: 'Évangile de Jean',
              book: "John",
              livre: 'Joannes',
              icon: Icons.book,
              color: Colors.blueGrey[700]!,
            ),
            const SizedBox(height: 16),
            _buildBookTile(
              context,
              title: 'Évangile de Matthieu',
              book: "Matthew",
              livre: 'Matthaeus',
              icon: Icons.book,
              color: Colors.blueGrey[700]!,
            ),
            const SizedBox(height: 16),
            _buildBookTile(
              context,
              title: 'Évangile de Marc',
              book: "Mark",
              livre: 'Marcus',
              icon: Icons.book,
              color: Colors.blueGrey[700]!,
            ),
            const SizedBox(height: 16),
            _buildBookTile(
              context,
              title: 'Évangile de Luc',
              book: "Luke",
              livre: 'Lucas',
              icon: Icons.book,
              color: Colors.blueGrey[700]!,
            ),
             const SizedBox(height: 16),
            _buildBookTile(
              context,
              title: 'Actes des Apotres',
              book: "Acts",
              livre: 'Actus',
              icon: Icons.book,
              color: Colors.blueGrey[700]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookTile(
    BuildContext context, {
    required String title,
    required String book,
    required String livre,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 32,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text(
          'Cliquez pour lire',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueGrey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: color,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChapterScreen(book: book, livre: livre, chapter: 1),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}