// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documented_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DocumentedUser _$_$_DocumentedUserFromJson(Map<String, dynamic> json) {
  return _$_DocumentedUser(
    id: json['id'] as String,
    idBook: json['idBook'] == null
        ? null
        : IdBook.fromJson(json['idBook'] as Map<String, dynamic>),
    idCard: json['idCard'] == null
        ? null
        : IdCard.fromJson(json['idCard'] as Map<String, dynamic>),
    driversLicense: json['driversLicense'] == null
        ? null
        : DriversLicense.fromJson(
            json['driversLicense'] as Map<String, dynamic>),
    passport: json['passport'] == null
        ? null
        : Passport.fromJson(json['passport'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_DocumentedUserToJson(_$_DocumentedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idBook': instance.idBook,
      'idCard': instance.idCard,
      'driversLicense': instance.driversLicense,
      'passport': instance.passport,
    };