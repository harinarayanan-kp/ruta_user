import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruta_user/services/auth_services.dart'; // Import for SystemNavigator

class WidgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _buildTile(
                icon: Icons.help_outline,
                title: 'HELP',
                description: 'Contact, FAQs, Manuals, Privacy',
                onPressed: () {
                  // Add your help action here
                },
              ),
              const SizedBox(height: 16),
              _buildTile(
                icon: Icons.info_outline,
                title: 'ABOUT',
                description: '', // No description for ABOUT
                onPressed: () {
                  // Add your about action here
                },
              ),
              const SizedBox(height: 32), // Space between tiles and sign out button
              _logout(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text("Sign Out"),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 80, // Fixed height for a more compact tile
          width: 280, // Adjust width if needed
          padding: const EdgeInsets.all(8), // Reduced padding
          child: Row(
            children: [
              Icon(icon, size: 30), // Smaller icon size
              const SizedBox(width: 8), // Space between icon and text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow:
                            TextOverflow.ellipsis, // Ellipsis if text overflows
                        maxLines:
                            2, // Limit the number of lines for description
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
