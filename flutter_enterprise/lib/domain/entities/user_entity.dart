import 'package:equatable/equatable.dart';

/// 用户实体 - 领域层
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, avatar];
}


