import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launch(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir : $url')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir : $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  'Luc Misaki Makelele',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('Développeur Android'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _contactTile(
          context,
          icon: Icons.phone,
          title: 'Téléphone',
          subtitle: '+243 970 123 456',
          url: 'tel:+243970123456',
        ),
        _contactTile(
          context,
          icon: Icons.email,
          title: 'E-mail',
          subtitle: 'misakidebugged@gmail.com',
          url: 'mailto:misakidebugged@gmail.com',
        ),
        _contactTile(
          context,
          icon: Icons.location_on,
          title: 'Adresse',
          subtitle: 'Goma, Nord-Kivu, RD Congo',
          url: 'https://www.google.com/maps/search/?api=1&query=Goma',
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Réseaux sociaux',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange.shade800),
          ),
        ),
        _contactTile(
          context,
          icon: Icons.code,
          title: 'GitHub',
          subtitle: 'github.com/misakidebugged',
          url: 'https://github.com/misakidebugged',
        ),
        _contactTile(
          context,
          icon: Icons.work,
          title: 'LinkedIn',
          subtitle: 'linkedin.com/in/luc-misaki-makelele',
          url: 'https://www.linkedin.com/in/luc-misaki-makelele',
        ),
      ],
    );
  }

  Widget _contactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(icon, color: Colors.orange.shade800),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => _launch(context, url),
      ),
    );
  }
}