import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/certification_model.dart';
import '../provider/auth_provider.dart';
import '../provider/certification_provider.dart';
import '../utils/certifcation_card.dart';

class CertificationListPage extends StatelessWidget {
  const CertificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    void showAddCertificationDialog(BuildContext context) {
      final certProvider =
          Provider.of<CertificationProvider>(context, listen: false);

      final formKey = GlobalKey<FormState>();
      String name = '';
      String issuer = '';
      String description = '';
      DateTime? startDate;
      DateTime? endDate;
      String? certificateLink;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          // Use dialogContext for dialog-specific operations
          title: const Text('Add New Certification'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Certification Name *',
                        hintText: 'e.g., AWS Solutions Architect'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Certification name is required'
                        : null,
                    onSaved: (value) => name = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Issuer *',
                        hintText: 'e.g., Amazon Web Services'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Issuer is required' : null,
                    onSaved: (value) => issuer = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Brief description of the certification'),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Description is required'
                        : null,
                    onSaved: (value) => description = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: dialogContext,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              startDate = date;
                            }
                          },
                          label: const Text('Start Date *'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: dialogContext,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              endDate = date;
                            }
                          },
                          label: const Text('End Date'),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Certificate Link',
                      hintText: 'URL to verify the certification',
                      prefixIcon: Icon(Icons.link),
                    ),
                    onSaved: (value) => certificateLink = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  if (startDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Start date is required')),
                    );
                    return;
                  }

                  final certification = Certification(
                    name: name,
                    issuer: issuer,
                    description: description,
                    startDate: startDate!,
                    endDate: endDate,
                    certificateLink: certificateLink,
                  );

                  // Use the provider instance we got earlier
                  certProvider.addCertification(certification);
                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Certification added successfully')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    return Consumer2<AuthProvider, CertificationProvider>(
      builder: (context, authProvider, certProvider, _) {
        print("${Uri.base}profile/${authProvider.user?.uid}");

        if (certProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (certProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${certProvider.error}'),
                ElevatedButton(
                  onPressed: certProvider.clearError,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Certifications'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  // TODO
                },
                tooltip: 'Share Profile',
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => showAddCertificationDialog(context),
                tooltip: 'Add New Certification',
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authProvider.signOut(),
                tooltip: 'Sign Out',
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
                      'Welcome, ${authProvider.user?.displayName}',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: certProvider.certifications
                          .map((cert) => CertificationCard(
                                certification: cert,
                                isEditable: true,
                                onDelete: () =>
                                    certProvider.deleteCertification(cert.id!),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
