import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _sectionTitle(context, 'Profil'),
          _card(
            child: Text(
              'Développeur Android passionné, spécialisé dans la création '
              'd\'applications mobiles modernes avec Kotlin et Flutter. '
              'Également développeur de jeux indépendant avec Godot. '
              'Basé à Goma, RD Congo.',
              style: TextStyle(color: Colors.grey.shade800, height: 1.4),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Formation'),
          _card(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.school, color: Colors.white),
              ),
              title: const Text('Développeur Android',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Formation spécialisée en développement mobile'),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Expériences'),
          _experienceCard(
            title: 'Développeur Flutter Freelance',
            subtitle: 'Projets mobiles pour clients locaux',
            date: '2022 — Présent',
          ),
          _experienceCard(
            title: 'Stage Développeur Android',
            subtitle: 'TechInnov SARL · Goma',
            date: '2023',
          ),
          _experienceCard(
            title: 'Développeur de jeux indépendant',
            subtitle: 'Projets personnels avec Godot Engine',
            date: '2021 — Présent',
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Compétences techniques'),
          _card(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                Chip(label: Text('Kotlin')),
                Chip(label: Text('Flutter')),
                Chip(label: Text('Godot')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Langues'),
          _card(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                Chip(label: Text('Français')),
                Chip(label: Text('Swahili')),
                Chip(label: Text('Lingala')),
                Chip(label: Text('Anglais')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Centres d\'intérêt'),
          _card(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                Chip(label: Text('Développement de jeux vidéo')),
                Chip(label: Text('Nouvelles technologies')),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 56,
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, size: 72, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'Luc Misaki Makelele',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Développeur Android',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange.shade800),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }

  Widget _experienceCard({
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.work_outline, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$subtitle\n$date'),
        isThreeLine: true,
      ),
    );
  }
}