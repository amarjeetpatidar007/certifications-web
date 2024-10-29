

class Certification {
  final String? id;
  final String name;
  final String issuer;
  final DateTime startDate;
  final DateTime? endDate;
  final String? certificateLink;
  final String description;

  Certification({
    this.id,
    required this.name,
    required this.issuer,
    required this.startDate,
    this.endDate,
    this.certificateLink,
    required this.description,
  });
}

final List<Certification> certifications = [
  Certification(
    id: "1",
    name: 'Google Play Store Listing Certificate',
    issuer: 'Google Play Academy',
    startDate: DateTime(2022, 1),
    endDate: DateTime(2024, 4),
    description: 'Google Play Store Listing Certificate by Google Play Academy',
  ),
  Certification(
    id: "2",
    name: 'Foundations of Project Management',
    issuer: 'Google & Coursera',
    startDate: DateTime(2022, 1),
    endDate: DateTime(2022, 3),
    description:
        'Learned about the basics of project management, Course authorized by Google and offered through Coursera.',
  ),
  Certification(
    id: "3",
    name: 'Google Cloud Badges',
    issuer: 'Google Cloud',
    startDate: DateTime(2021, 5),
    description: 'Completed 24 Quests And 12 Skill Badges+',
  ),
  Certification(
    id: "4",
    name: 'Problem Solving Using Computational Thinking',
    issuer: 'University of Michigan | Coursera',
    startDate: DateTime(2021, 4),
    endDate: DateTime(2021, 5),
    description:
        'Problem Solving Using Computational Thinking - University of Michigan | Coursera',
  ),
  Certification(
    id: "5",
    name: 'MongoDB For SQL Pros',
    issuer: 'MongoDB',
    startDate: DateTime(2021, 2),
    endDate: DateTime(2021, 3),
    description:
        'This course helped me to build a solid understanding of how MongoDB differs from relational databases.',
  ),
];