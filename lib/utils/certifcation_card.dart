import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/certification_model.dart';

class CertificationCard extends StatelessWidget {
  final Certification certification;
  final bool isEditable;
  final Future<void> Function() onDelete;
  final Function() onPreview;

  const CertificationCard({
    super.key,
    required this.certification,
    required this.isEditable,
    required this.onDelete,
    required this.onPreview,
  });

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
                  onPressed: () => onPreview(),
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

}
