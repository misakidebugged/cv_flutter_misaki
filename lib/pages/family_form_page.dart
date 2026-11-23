import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class FamilyFormPage extends StatefulWidget {
  /// Si `member` est non-null → mode édition, sinon mode création.
  final Map<String, dynamic>? member;

  const FamilyFormPage({super.key, this.member});

  @override
  State<FamilyFormPage> createState() => _FamilyFormPageState();
}

class _FamilyFormPageState extends State<FamilyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _postnom;
  late final TextEditingController _prenom;
  late final TextEditingController _lieu;
  late final TextEditingController _parente;
  DateTime? _date;
  String? _imagePath;
  bool _saving = false;

  bool get _isEdit => widget.member != null;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _nom = TextEditingController(text: m?['nom'] ?? '');
    _postnom = TextEditingController(text: m?['postnom'] ?? '');
    _prenom = TextEditingController(text: m?['prenom'] ?? '');
    _lieu = TextEditingController(text: m?['lieu_naissance'] ?? '');
    _parente = TextEditingController(text: m?['parente'] ?? '');
    if (m?['date_naissance'] != null) {
      _date = DateTime.tryParse(m!['date_naissance']);
    }
  }

  @override
  void dispose() {
    _nom.dispose();
    _postnom.dispose();
    _prenom.dispose();
    _lieu.dispose();
    _parente.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x != null) setState(() => _imagePath = x.path);
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez une date de naissance')),
      );
      return;
    }
    setState(() => _saving = true);

    final fields = {
      'nom': _nom.text.trim(),
      'postnom': _postnom.text.trim(),
      'prenom': _prenom.text.trim(),
      'lieu_naissance': _lieu.text.trim(),
      'date_naissance': _fmt(_date!),
      'parente': _parente.text.trim(),
    };

    try {
      if (!_isEdit) {
        await ApiService.createMember(fields: fields, imagePath: _imagePath);
      } else {
        final id = widget.member!['id'] as int;
        if (_imagePath != null) {
          await ApiService.updateMemberWithImage(
              id: id, fields: fields, imagePath: _imagePath!);
        } else {
          await ApiService.updateMember(id: id, fields: fields);
        }
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      final detail = e.errors != null && e.errors!.isNotEmpty
          ? '\n${e.errors!.entries.first.value}'
          : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e.message}$detail')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur réseau')),
      );
    }
  }

  Widget _field(TextEditingController c, String label,
      {int max = 50, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLength: max,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          counterText: '',
        ),
        validator: validator ??
            (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final existingImageUrl = widget.member?['image_url'] as String?;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Modifier le membre' : 'Nouveau membre'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.orange.shade100,
                  backgroundImage: _imagePath != null
                      ? FileImage(_imageFromPath(_imagePath!))
                      : (existingImageUrl != null
                          ? NetworkImage(existingImageUrl)
                          : null) as ImageProvider?,
                  child: (_imagePath == null && existingImageUrl == null)
                      ? Icon(Icons.add_a_photo,
                          size: 32, color: Colors.orange.shade800)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Appuyer pour choisir une image (facultatif)',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            _field(_nom, 'Nom'),
            _field(_postnom, 'Postnom'),
            _field(_prenom, 'Prénom'),
            _field(_lieu, 'Lieu de naissance', max: 100),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_date == null
                      ? 'Choisir une date'
                      : _fmt(_date!)),
                ),
              ),
            ),
            _field(_parente, 'Lien de parenté (Père, Mère, Frère…)'),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(_isEdit ? 'Enregistrer' : 'Créer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// image_picker ne renvoie que le path ; FileImage a besoin d'un File
// mais on garde ce helper pour éviter d'importer dart:io partout.
File _imageFromPath(String path) => File(path);