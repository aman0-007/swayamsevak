class Student {
  final String studId;
  final String name;
  final String surname;
  final String email;

  Student({
    required this.studId,
    required this.name,
    required this.surname,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studId: json['stud_id'] ?? 'Unknown ID',
      name: json['name'] ?? 'Unknown Name',
      surname: json['surname'] ?? 'Unknown Surname',
      email: json['email'] ?? 'Unknown Email',
    );
  }
}
