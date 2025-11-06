import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight local backend replacement to avoid external costs.
/// Stores data in SharedPreferences on web and mobile.
class User {
  final String id;
  final String email;
  User(this.id, this.email);
}

class SupabaseService {
  static const _kUsersKey = 'gg_users'; // list of {id,email,password}
  static const _kProfilesKey = 'gg_profiles'; // map: id -> profile map
  static const _kSessionKey = 'gg_session_user_id';

  User? _currentUser;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_kSessionKey);
    if (uid != null) {
      final users = _readUsers(prefs);
      final u = users.firstWhere((e) => e['id'] == uid, orElse: () => {});
      if (u.isNotEmpty) {
        _currentUser = User(u['id'] as String, u['email'] as String);
      }
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String gender,
    required String university,
    required String graduationYear,
    required String course,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _readUsers(prefs);
    if (users.any((u) => (u['email'] as String).toLowerCase() == email.toLowerCase())) {
      return false; // email exists
    }
    final id = _genId();
    users.add({'id': id, 'email': email, 'password': password});
    await prefs.setString(_kUsersKey, jsonEncode(users));

    final profiles = _readProfiles(prefs);
    profiles[id] = {
      'id': id,
      'name': name,
      'phone': phone,
      'gender': gender,
      'university': university,
      'graduation_year': graduationYear,
      'course': course,
      'profile_image_url': profileImage,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_kProfilesKey, jsonEncode(profiles));

    _currentUser = User(id, email);
    await prefs.setString(_kSessionKey, id);
    return true;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _readUsers(prefs);
    final match = users.firstWhere(
      (u) => (u['email'] as String).toLowerCase() == email.toLowerCase() && u['password'] == password,
      orElse: () => {},
    );
    if (match.isEmpty) return false;
    _currentUser = User(match['id'] as String, match['email'] as String);
    await prefs.setString(_kSessionKey, _currentUser!.id);
    return true;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionKey);
    _currentUser = null;
  }

  User? getCurrentUser() => _currentUser;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = _readProfiles(prefs);
    return profiles[userId] as Map<String, dynamic>?;
  }

  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = _readProfiles(prefs);
    final current = Map<String, dynamic>.from(profiles[userId] ?? {});
    current.addAll(data);
    current['updated_at'] = DateTime.now().toIso8601String();
    profiles[userId] = current;
    await prefs.setString(_kProfilesKey, jsonEncode(profiles));
    return true;
  }

  Future<String?> updateProfileImage(String userId, String imageUrl) async {
    await updateUserProfile(userId, {'profile_image_url': imageUrl});
    return imageUrl;
  }

  Future<String?> uploadAvatarBytes(Uint8List data, String storagePath, {String contentType = 'image/png'}) async {
    // Return a data URI so Image.network can render it on web
    final base64Data = base64Encode(data);
    return 'data:$contentType;base64,$base64Data';
  }

  // Stub to keep API compatibility; not used by UI
  Stream<String> authStateChanges() async* {
    yield _currentUser?.id ?? '';
  }

  // Helpers
  List<Map<String, dynamic>> _readUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_kUsersKey);
    if (raw == null || raw.isEmpty) return [];
    final List list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> _readProfiles(SharedPreferences prefs) {
    final raw = prefs.getString(_kProfilesKey);
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  String _genId() {
    final rnd = Random();
    return DateTime.now().millisecondsSinceEpoch.toString() + '_' + rnd.nextInt(1 << 32).toString();
  }
}
