import 'dart:convert';
import 'dart:typed_data';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config.dart';

class PBService {
  late final PocketBase _pb;

  PocketBase get client => _pb;

  Future<void> initialize() async {
    _pb = PocketBase(pbBaseUrl);
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
    await _pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
    final auth = await _pb.collection('users').authWithPassword(email, password);
    final userId = auth.record!.id;
    await _pb.collection('profiles').create(body: {
      'user': userId,
      'name': name,
      'phone': phone,
      'gender': gender,
      'university': university,
      'graduation_year': graduationYear,
      'course': course,
    });
    return true;
  }

  Future<bool> signIn({required String email, required String password}) async {
    await _pb.collection('users').authWithPassword(email, password);
    return _pb.authStore.isValid;
  }

  Future<void> signOut() async {
    _pb.authStore.clear();
  }

  String? currentUserId() => _pb.authStore.model?.id;
  String? currentUserEmail() => _pb.authStore.model?.data['email'] as String?;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final res = await _pb.collection('profiles').getFirstListItem('user = "$userId"');
    return res.data;
  }

  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final profile = await _pb.collection('profiles').getFirstListItem('user = "$userId"');
    await _pb.collection('profiles').update(profile.id, body: data);
    return true;
  }

  Future<String?> uploadAvatarBytes(Uint8List data, {String fileName = 'avatar.png', String contentType = 'image/png'}) async {
    final userId = currentUserId();
    if (userId == null) return null;
    final profile = await _pb.collection('profiles').getFirstListItem('user = "$userId"');
final updated = await _pb.collection('profiles').update(profile.id, body: {
      'avatar': http.MultipartFile.fromBytes(
        'avatar',
        data,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ),
    });
    final file = updated.data['avatar'] as String?;
    if (file == null || file.isEmpty) return null;
    return '${pbBaseUrl}/api/files/${updated.collectionId}/${updated.id}/$file';
  }

  Future<String?> updateProfileImage(String imageUrl) async {
    // Profile already holds the file; we just return URL here to match app expectation
    return imageUrl;
  }

  // Messaging
  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final uid = currentUserId();
    if (uid == null) return [];
    final result = await _pb.collection('messages').getList(
      filter: 'from = "$uid" || to = "$uid"',
      sort: '-created',
      perPage: 50,
    );
    return result.items.map((r) => r.data).toList();
  }

  Future<void> sendMessage({required String toUserId, required String content}) async {
    final uid = currentUserId();
    if (uid == null) throw Exception('Not authenticated');
    await _pb.collection('messages').create(body: {
      'from': uid,
      'to': toUserId,
      'content': content,
    });
  }

  Future<String?> findUserIdByEmail(String email) async {
    try {
      final rec = await _pb.collection('users').getFirstListItem('email = "${email}"');
      return rec.id;
    } catch (_) {
      return null;
    }
  }

  // Posts
  Future<bool> createPost({required String title, required String body, Uint8List? imageBytes, String imageName = 'image.png', String contentType = 'image/png'}) async {
    final uid = currentUserId();
    if (uid == null) throw Exception('Not authenticated');
    RecordModel created;
    if (imageBytes != null) {
created = await _pb.collection('posts').create(body: {
        'title': title,
        'body': body,
        'author': uid,
        'published': true,
        'image': http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType.parse(contentType),
        ),
      });
    } else {
      created = await _pb.collection('posts').create(body: {
        'title': title,
        'body': body,
        'author': uid,
        'published': true,
      });
    }
    return created.id.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final result = await _pb.collection('posts').getList(filter: 'published = true', sort: '-created', perPage: 20);
    return result.items.map((r) {
      final data = r.data;
      final img = (data['image'] as String?);
      final imageUrl = (img != null && img.isNotEmpty)
          ? '${pbBaseUrl}/api/files/${r.collectionId}/${r.id}/$img'
          : null;
      return {
        'id': r.id,
        'title': data['title'] ?? '',
        'body': data['body'] ?? '',
        'imageUrl': imageUrl,
        'date': r.created,
      };
    }).toList();
  }
}
