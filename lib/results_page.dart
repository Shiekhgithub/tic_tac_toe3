import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import the WelcomePage

class ResultsPage extends StatelessWidget {
  final String result;
  final Function resetGame;

  const ResultsPage({super.key, required this.result, required this.resetGame});

  // Function to save result to Firebase Firestore
  Future<void> saveResultToFirestore(String result) async {
    // Reference to the Firestore collection
    CollectionReference results = FirebaseFirestore.instance.collection('game_results');

    try {
      // Add a new document to the collection
      await results.add({
        'result': result, // Store the result (win/loss/draw)
        'timestamp': FieldValue.serverTimestamp(), // Store the timestamp of when the result was recorded
      });
      print("Game result saved to Firestore");
    } catch (e) {
      print("Error saving game result to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Save result to Firestore as soon as the ResultsPage is loaded
    saveResultToFirestore(result);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Stylish app bar color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0), // Padding around the text
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Semi-transparent background
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  result,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // Text color
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  resetGame(); // Reset the game when button is pressed
                  Navigator.pop(context); // Go back to Tic Tac Toe screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Changed button color to green
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Play Again'),
              ),
              const SizedBox(height: 10), // Added spacing between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomePage()), // Navigate to WelcomePage
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Color for Exit button
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
