import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'certification_model.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CertificationTrackerApp());
}

class CertificationTrackerApp extends StatelessWidget {
  const CertificationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certification Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const CertificationListPage(),
    );
  }
}



class CertificationListPage extends StatefulWidget {
  const CertificationListPage({super.key});

  @override
  State<CertificationListPage> createState() => _CertificationListPageState();
}

class _CertificationListPageState extends State<CertificationListPage> {


  @override
  Widget build(BuildContext context) {
    final sortedCertifications = [...certifications]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){},
            tooltip: 'Add New Certification',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Professional Certifications & Courses',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: sortedCertifications
                      .map((cert) => _CertificationCard(certification: cert))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _CertificationCard extends StatelessWidget {
  final Certification certification;

  const _CertificationCard({required this.certification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              certification.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              certification.issuer,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDateRow(context),
            const SizedBox(height: 12),
            Text(
              certification.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (certification.certificateLink != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(certification.certificateLink!),
                  icon: const Icon(Icons.link),
                  label: const Text('View Certificate'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(BuildContext context) {
    final startDate = DateFormat('MMM yyyy').format(certification.startDate);
    final endDate = certification.endDate != null
        ? DateFormat('MMM yyyy').format(certification.endDate!)
        : 'Present';

    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$startDate - $endDate',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
