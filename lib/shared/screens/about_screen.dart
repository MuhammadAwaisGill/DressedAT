import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // App Icon placeholder
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.checkroom, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 16),

            const Text(
              'DressedAT',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'DressedAT helps you track your outfits so you never repeat the same look in front of the same people. Log what you wore, where you wore it, and who saw it — and let the app do the rest.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
              ),
            ),

            const SizedBox(height: 16),

            // LinkedIn
            _InfoTile(
              icon: Icons.person,
              title: 'Connect with the Developer',
              subtitle: 'View LinkedIn Profile',
              onTap: () => launchUrl(
                Uri.parse('https://www.linkedin.com/in/-muhammad--awais/'),
                mode: LaunchMode.externalApplication,
              ),
            ),

            const SizedBox(height: 8),

            // Privacy Policy
            _InfoTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'View our privacy policy',
              onTap: () => launchUrl(
                Uri.parse('https://your-privacy-policy-url.com'), // replace later
                mode: LaunchMode.externalApplication,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              '© 2025 DressedAT',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.open_in_new, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}