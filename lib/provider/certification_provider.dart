import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/certification_model.dart';

class CertificationProvider extends ChangeNotifier {
  final String userId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Certification> certifications = [];
  bool isLoading = false;
  String? error;

  // Preview-specific states
  bool isPreviewLoading = false;
  String? previewError;
  String? currentPreviewUrl;
  bool isPreviewVisible = false;

  CertificationProvider(this.userId) {
    initializeCertifications();
  }

  List<Certification> get certificationsList => certifications;

  String? get errorMessage => error;

  void initializeCertifications() {
    firestore
        .collection('users')
        .doc(userId)
        .collection('certifications')
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        certifications = snapshot.docs.map((doc) {
          final data = doc.data();
          return Certification(
            id: doc.id,
            name: data['name'],
            issuer: data['issuer'],
            startDate: (data['startDate'] as Timestamp).toDate(),
            endDate: data['endDate'] != null
                ? (data['endDate'] as Timestamp).toDate()
                : null,
            certificateLink: data['certificateLink'],
            description: data['description'],
          );
        }).toList();
        notifyListeners();
      },
      onError: (e) {
        error = e.toString();
        notifyListeners();
      },
    );
  }

  Future addCertification(Certification certification) async {
    try {
      isLoading = true;
      notifyListeners();

      await firestore
          .collection('users')
          .doc(userId)
          .collection('certifications')
          .add({
        'name': certification.name,
        'issuer': certification.issuer,
        'startDate': Timestamp.fromDate(certification.startDate),
        'endDate': certification.endDate != null
            ? Timestamp.fromDate(certification.endDate!)
            : null,
        'certificateLink': certification.certificateLink,
        'description': certification.description,
      });

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future deleteCertification(String certificationId) async {
    try {
      isLoading = true;
      notifyListeners();

      await firestore
          .collection('users')
          .doc(userId)
          .collection('certifications')
          .doc(certificationId)
          .delete();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}