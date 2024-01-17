// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
 final int id;
final String name;
final int	role;
final String place;
final int status;
final String	email;
  User({
    required this.id,
    required this.role,
    required this.name,
    required this.place,
    required this.status,
    required this.email,
  });

  User copyWith({
    int? id,
    String? name,
    String? place,
    int? status,
    String? email,
    int ?role,

  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      place: place ?? this.place,
      status: status ?? this.status,
role: role ?? this.role,
  email: email ?? this.email,
    );
  }
}

