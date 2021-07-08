// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      url: json['url'] as String,
      token: json['token'] as String,
      setcookie: json['setcookie']);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'url': instance.url,
      'token': instance.token,
      'setcookie': instance.setcookie
    };
