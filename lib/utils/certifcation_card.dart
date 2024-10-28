import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/certification_model.dart';

class CertificationCard extends StatelessWidget {
  final Certification certification;

  const CertificationCard(
      {super.key,
      required this.certification,
      required bool isEditable,
      required Future<void> Function() onDelete});

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
