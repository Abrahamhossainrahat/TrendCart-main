// models/fingerprint_model.dart
class FingerprintModel {
  final String userId;
  final String fingerprintTemplate;

  FingerprintModel({required this.userId, required this.fingerprintTemplate});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fingerprintTemplate': fingerprintTemplate,
    };
  }

  factory FingerprintModel.fromMap(Map<String, dynamic> map) {
    return FingerprintModel(
      userId: map['userId'],
      fingerprintTemplate: map['fingerprintTemplate'],
    );
  }
}
