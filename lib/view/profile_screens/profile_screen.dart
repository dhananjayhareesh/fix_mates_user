import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Privacy Policy',
              'Read our Privacy Policy',
              () {
                // Navigate to Privacy Policy page
              },
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Terms and Conditions',
              'Read our Terms and Conditions',
              () {
                // Navigate to Terms and Conditions page
              },
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Become a Service Provider',
              'Apply Now',
              () {
                // Navigate to Become a Service Provider page
              },
              isButton: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isButton = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isButton ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isButton ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isButton ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isButton ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (isButton) ...[
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ] else ...[
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueAccent,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
