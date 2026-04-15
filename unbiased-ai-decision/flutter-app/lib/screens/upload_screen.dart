import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'report_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? _datasetFile;
  PlatformFile? _modelFile;
  final TextEditingController _modelNameController = TextEditingController();
  bool _loading = false;

  Future<void> _pickDataset() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['csv'],
    );
    if (result != null && mounted) {
      setState(() => _datasetFile = result.files.single);
    }
  }

  Future<void> _pickModel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['pkl', 'h5'],
    );
    if (result != null && mounted) {
      setState(() => _modelFile = result.files.single);
    }
  }

  Future<void> _runAudit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (_datasetFile == null || user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a CSV and sign in first.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final response = await ApiService.instance.runAudit(
        datasetFile: _datasetFile!,
        modelFile: _modelFile,
        modelName: _modelNameController.text.trim().isEmpty
            ? 'Uploaded Decision Model'
            : _modelNameController.text.trim(),
        userId: user.uid,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ReportScreen(initialAudit: response),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Audit Inputs')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton.icon(
            onPressed: _pickDataset,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(
              _datasetFile == null
                  ? 'Upload Dataset (CSV)'
                  : 'Dataset: ${_datasetFile!.name}',
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickModel,
            icon: const Icon(Icons.memory_rounded),
            label: Text(
              _modelFile == null
                  ? 'Upload Model (optional)'
                  : 'Model: ${_modelFile!.name}',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _modelNameController,
            decoration: const InputDecoration(
              labelText: 'Model Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _loading ? null : _runAudit,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: const Text('Run Bias Audit'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
