import 'package:flutter/material.dart';

class _FamilyMember {
  final String name;
  final String relation;
  final String profession;
  final IconData icon;

  const _FamilyMember({
    required this.name,
    required this.relation,
    required this.profession,
    required this.icon,
  });
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const _members = [
    _FamilyMember(
      name: 'Joseph Makelele',
      relation: 'Père',
      profession: 'Ingénieur civil',
      icon: Icons.man,
    ),
    _FamilyMember(
      name: 'Marie Makelele',
      relation: 'Mère',
      profession: 'Enseignante',
      icon: Icons.woman,
    ),
    _FamilyMember(
      name: 'Grâce Makelele',
      relation: 'Sœur',
      profession: 'Étudiante en médecine',
      icon: Icons.face_3,
    ),
    _FamilyMember(
      name: 'David Makelele',
      relation: 'Frère',
      profession: 'Élève',
      icon: Icons.face_6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final m = _members[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.orange.shade100,
                  child: Icon(m.icon, size: 40, color: Colors.orange.shade800),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(m.relation),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.orange.shade50,
                        side: BorderSide(color: Colors.orange.shade200),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.profession,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}