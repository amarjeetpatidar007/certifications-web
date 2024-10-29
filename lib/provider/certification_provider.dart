import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/certification_model.dart';

class CertificationProvider extends ChangeNotifier {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Certification> _certifications = [];
  bool _isLoading = false;
  String? _error;

  CertificationProvider(this.userId) {
    _initializeCertifications();
  }

  List<Certification> get certifications => _certifications;

  bool get isLoading => _isLoading;

  String? get error => _error;

  void _initializeCertifications() {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('certifications')
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _certifications = snapshot.docs.map((doc) {
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
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> addCertification(Certification certification) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCertification(String certificationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('certifications')
          .doc(certificationId)
          .delete();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
