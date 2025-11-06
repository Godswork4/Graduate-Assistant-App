import 'dart:typed_data';
import '../config.dart' as app_config;
import 'supabase_service.dart' as local_backend;
import 'pb_service.dart';

class AppUser {
  final String id;
  final String email;
  const AppUser(this.id, this.email);
}

abstract class BackendApi {
  Future<void> initialize();
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
  });
  Future<bool> signIn({required String email, required String password});
  Future<void> signOut();
  AppUser? getCurrentUser();
  Future<Map<String, dynamic>?> getUserProfile(String userId);
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data);
  Future<String?> updateProfileImage(String userId, String imageUrl);
  Future<String?> uploadAvatarBytes(Uint8List data, String storagePath, {String contentType});

  // Messaging
  Future<List<Map<String, dynamic>>> fetchMessages();
  Future<void> sendMessage({required String toUserId, required String content});
  Future<List<Map<String, dynamic>>> fetchPosts();
  Future<bool> createPost({required String title, required String body, Uint8List? imageBytes, String imageName, String contentType});
  Future<List<Map<String, dynamic>>> fetchConversations();
  Future<String?> findUserIdByEmail(String email);
}

class Backend implements BackendApi {
  static final Backend instance = Backend._internal();
  late final BackendApi _impl;

  Backend._internal() {
    if (app_config.backend == app_config.Backend.pocketbase) {
      _impl = _PBBackendAdapter(PBService());
    } else {
      _impl = _LocalBackendAdapter(local_backend.SupabaseService());
    }
  }

  // Delegations
  @override
  Future<void> initialize() => _impl.initialize();
  @override
  Future<bool> signUp({required String email, required String password, required String name, required String phone, required String gender, required String university, required String graduationYear, required String course, String? profileImage})
    => _impl.signUp(email: email, password: password, name: name, phone: phone, gender: gender, university: university, graduationYear: graduationYear, course: course, profileImage: profileImage);
  @override
  Future<bool> signIn({required String email, required String password}) => _impl.signIn(email: email, password: password);
  @override
  Future<void> signOut() => _impl.signOut();
  @override
  AppUser? getCurrentUser() => _impl.getCurrentUser();
  @override
  Future<Map<String, dynamic>?> getUserProfile(String userId) => _impl.getUserProfile(userId);
  @override
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) => _impl.updateUserProfile(userId, data);
  @override
  Future<String?> updateProfileImage(String userId, String imageUrl) => _impl.updateProfileImage(userId, imageUrl);
  @override
  Future<String?> uploadAvatarBytes(Uint8List data, String storagePath, {String contentType = 'image/png'}) => _impl.uploadAvatarBytes(data, storagePath, contentType: contentType);
  @override
  Future<List<Map<String, dynamic>>> fetchMessages() => _impl.fetchMessages();
  @override
  Future<void> sendMessage({required String toUserId, required String content}) => _impl.sendMessage(toUserId: toUserId, content: content);
  @override
  Future<List<Map<String, dynamic>>> fetchPosts() => _impl.fetchPosts();
  @override
  Future<bool> createPost({required String title, required String body, Uint8List? imageBytes, String imageName = 'image.png', String contentType = 'image/png'})
    => _impl.createPost(title: title, body: body, imageBytes: imageBytes, imageName: imageName, contentType: contentType);
  @override
  Future<List<Map<String, dynamic>>> fetchConversations() => _impl.fetchConversations();
  @override
  Future<String?> findUserIdByEmail(String email) => _impl.findUserIdByEmail(email);
}

class _LocalBackendAdapter implements BackendApi {
  final local_backend.SupabaseService _local;
  _LocalBackendAdapter(this._local);

  @override
  Future<void> initialize() => _local.initialize();

  @override
  AppUser? getCurrentUser() {
    final u = _local.getCurrentUser();
    if (u == null) return null;
    return AppUser(u.id, u.email);
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String userId) => _local.getUserProfile(userId);

  @override
  Future<String?> updateProfileImage(String userId, String imageUrl) => _local.updateProfileImage(userId, imageUrl);

  @override
  Future<String?> uploadAvatarBytes(Uint8List data, String storagePath, {String contentType = 'image/png'})
    => _local.uploadAvatarBytes(data, storagePath, contentType: contentType);

  @override
  Future<bool> signIn({required String email, required String password}) => _local.signIn(email: email, password: password);

  @override
  Future<bool> signUp({required String email, required String password, required String name, required String phone, required String gender, required String university, required String graduationYear, required String course, String? profileImage})
    => _local.signUp(email: email, password: password, name: name, phone: phone, gender: gender, university: university, graduationYear: graduationYear, course: course, profileImage: profileImage);

  @override
  Future<void> signOut() => _local.signOut();

  @override
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) => _local.updateUserProfile(userId, data);

  // Local stub messaging
  @override
  Future<List<Map<String, dynamic>>> fetchMessages() async => [];
  @override
  Future<void> sendMessage({required String toUserId, required String content}) async {}
  @override
  Future<List<Map<String, dynamic>>> fetchPosts() async => [];
  @override
  Future<bool> createPost({required String title, required String body, Uint8List? imageBytes, String imageName = 'image.png', String contentType = 'image/png'}) async => true;
  @override
  Future<List<Map<String, dynamic>>> fetchConversations() async => [];
  @override
  Future<String?> findUserIdByEmail(String email) async => null;
}

class _PBBackendAdapter implements BackendApi {
  final PBService _pb;
  _PBBackendAdapter(this._pb);

  @override
  Future<void> initialize() => _pb.initialize();

  @override
  AppUser? getCurrentUser() {
    final id = _pb.currentUserId();
    final email = _pb.currentUserEmail();
    if (id == null || email == null) return null;
    return AppUser(id, email);
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String userId) => _pb.getUserProfile(userId);

  @override
  Future<String?> updateProfileImage(String userId, String imageUrl) => _pb.updateProfileImage(imageUrl);

  @override
  Future<String?> uploadAvatarBytes(Uint8List data, String storagePath, {String contentType = 'image/png'})
    => _pb.uploadAvatarBytes(data, fileName: storagePath.split('/').last, contentType: contentType);

  @override
  Future<bool> signIn({required String email, required String password}) => _pb.signIn(email: email, password: password);

  @override
  Future<bool> signUp({required String email, required String password, required String name, required String phone, required String gender, required String university, required String graduationYear, required String course, String? profileImage})
    => _pb.signUp(email: email, password: password, name: name, phone: phone, gender: gender, university: university, graduationYear: graduationYear, course: course, profileImage: profileImage);

  @override
  Future<void> signOut() => _pb.signOut();

  @override
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) => _pb.updateUserProfile(userId, data);

  @override
  Future<List<Map<String, dynamic>>> fetchMessages() => _pb.fetchMessages();
  @override
  Future<void> sendMessage({required String toUserId, required String content}) => _pb.sendMessage(toUserId: toUserId, content: content);
  @override
  Future<List<Map<String, dynamic>>> fetchPosts() => _pb.fetchPosts();
  @override
  Future<bool> createPost({required String title, required String body, Uint8List? imageBytes, String imageName = 'image.png', String contentType = 'image/png'})
    => _pb.createPost(title: title, body: body, imageBytes: imageBytes, imageName: imageName, contentType: contentType);
  @override
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    final uid = getCurrentUser()?.id;
    if (uid == null) return [];
    final msgs = await _pb.fetchMessages();
    final Map<String, String> peers = {};
    for (final m in msgs) {
      final from = (m['from'] ?? '').toString();
      final to = (m['to'] ?? '').toString();
      final peer = from == uid ? to : from;
      if (peer.isEmpty || peer == uid) continue;
      // Email requires extra query; leave as ID for now
      peers.putIfAbsent(peer, () => peer);
    }
    return peers.entries.map((e) => {'id': e.key, 'label': e.value}).toList();
  }

  @override
  Future<String?> findUserIdByEmail(String email) => _pb.findUserIdByEmail(email);
}
