import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:eviks_mobile/models/metro_station.dart';
import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../models/filters.dart';
import '../models/pagination.dart';
import '../models/post.dart';
import '../models/post_location.dart';

class Posts with ChangeNotifier {
  String token;
  String? user;
  List<Post> _posts;
  Post? _postData;
  Filters _filters;
  Pagination _pagination;
  List<PostLocation> _postsLocations;

  Posts(
    this.token,
    this.user,
    this._posts,
    this._postData,
    this._filters,
    this._pagination,
    this._postsLocations,
  );

  List<Post> get posts {
    return [..._posts];
  }

  Post? get postData {
    return _postData;
  }

  Filters get filters {
    return _filters;
  }

  Pagination get pagination {
    return _pagination;
  }

  String get url {
    final data = _filters.toQueryParameters();
    data.removeWhere((key, value) => value == null);
    return Uri(queryParameters: data).query;
  }

  List<PostLocation> get postsLocations {
    return [..._postsLocations];
  }

  Future<void> initNewPost(Post? loadedPost) async {
    if (loadedPost != null) {
      _postData = loadedPost;
    } else {
      final capital = getCapitalCity();
      _postData = Post(
        id: 0,
        userType: UserType.owner,
        estateType: EstateType.house,
        dealType: DealType.sale,
        location: [],
        city: capital,
        district: capital.children![0],
        address: '',
        sqm: 0,
        renovation: Renovation.cosmetic,
        price: 0,
        rooms: 0,
        images: [],
        description: '',
        phoneNumber: '',
        username: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        user: user!,
        originalImages: [],
        reviewHistory: [],
      );
    }
  }

  void setPostData(Post? value) {
    _postData = value;
    notifyListeners();
  }

  void setFilters(Filters value) {
    _filters = value;
    notifyListeners();
  }

  List<List<double>> parseSearchAreaUrl(String url) {
    final List<List<double>> searchArea = [];
    final List<List<dynamic>> listOfDynamic = [];
    final coordinates = url.split('],');

    for (var i = 0; i < coordinates.length; i++) {
      final source = coordinates[i];
      listOfDynamic.add(
        jsonDecode('$source${i == coordinates.length - 1 ? '' : ']'}')
            as List<dynamic>,
      );
    }

    for (final item in listOfDynamic) {
      if (item.length == 2) {
        final double lat = item[0] as double;
        final double lon = item[1] as double;
        searchArea.add([lat, lon]);
      }
    }

    return searchArea;
  }

  Filters getFiltersfromQueryParameters(
    Map<String, String> params,
    Settlement city,
    List<Settlement>? districts,
    List<Settlement>? subdistricts,
    List<MetroStation>? metroStations,
  ) {
    return Filters(
      city: city,
      districts: districts,
      subdistricts: subdistricts,
      metroStations: metroStations,
      dealType: DealType.values.firstWhere(
        (element) => element.toString() == 'DealType.${params['dealType']}',
      ),
      estateType: EstateType.values.firstWhere(
        (element) => element.toString() == 'EstateType.${params['estateType']}',
      ),
      apartmentType: params['apartmentType'] == null
          ? null
          : ApartmentType.values.firstWhere(
              (element) =>
                  element.toString() ==
                  'ApartmentType.${params['apartmentType']}',
            ),
      priceMin:
          params['priceMin'] == null ? null : int.parse(params['priceMin']!),
      priceMax:
          params['priceMax'] == null ? null : int.parse(params['priceMax']!),
      roomsMin:
          params['roomsMin'] == null ? null : int.parse(params['roomsMin']!),
      roomsMax:
          params['roomsMax'] == null ? null : int.parse(params['roomsMax']!),
      sqmMin: params['sqmMin'] == null ? null : int.parse(params['sqmMin']!),
      sqmMax: params['sqmMax'] == null ? null : int.parse(params['sqmMax']!),
      livingRoomsSqmMin: params['livingRoomsSqmMin'] == null
          ? null
          : int.parse(params['livingRoomsSqmMin']!),
      livingRoomsSqmMax: params['livingRoomsSqmMax'] == null
          ? null
          : int.parse(params['livingRoomsSqmMax']!),
      kitchenSqmMin: params['kitchenSqmMin'] == null
          ? null
          : int.parse(params['kitchenSqmMin']!),
      kitchenSqmMax: params['kitchenSqmMax'] == null
          ? null
          : int.parse(params['kitchenSqmMax']!),
      lotSqmMin:
          params['lotSqmMin'] == null ? null : int.parse(params['lotSqmMin']!),
      lotSqmMax:
          params['lotSqmMax'] == null ? null : int.parse(params['lotSqmMax']!),
      floorMin:
          params['floorMin'] == null ? null : int.parse(params['floorMin']!),
      floorMax:
          params['floorMax'] == null ? null : int.parse(params['floorMax']!),
      totalFloorsMin: params['totalFloorsMin'] == null
          ? null
          : int.parse(params['totalFloorsMin']!),
      totalFloorsMax: params['totalFloorsMax'] == null
          ? null
          : int.parse(params['totalFloorsMax']!),
      searchArea: params['searchArea'] == null
          ? null
          : parseSearchAreaUrl(params['searchArea']!),
      hasVideo: params['hasVideo']?.toLowerCase() == 'true',
      documented: params['documented']?.toLowerCase() == 'true',
      fromOwner: params['fromOwner']?.toLowerCase() == 'true',
      withoutRedevelopment:
          params['withoutRedevelopment']?.toLowerCase() == 'true',
      sort: params['sort'] == null
          ? SortType.dateDsc
          : SortType.values.firstWhere(
              (element) => element.toString() == 'SortType.${params['sort']}',
            ),
    );
  }

  void updateFilters(Map<String, dynamic> newValues) {
    newValues.forEach((key, value) {
      switch (key) {
        case 'city':
          _filters.city = value as Settlement;
          break;
        case 'districts':
          _filters.districts = value as List<Settlement>?;
          break;
        case 'subdistricts':
          _filters.subdistricts = value as List<Settlement>?;
          break;
        case 'metroStations':
          _filters.metroStations = value as List<MetroStation>?;
          break;
        case 'dealType':
          _filters.dealType = value as DealType;
          break;
        case 'estateType':
          _filters.estateType = value as EstateType;
          break;
        case 'apartmentType':
          _filters.apartmentType = value as ApartmentType?;
          break;
        case 'priceMin':
          _filters.priceMin = value as int?;
          break;
        case 'priceMax':
          _filters.priceMax = value as int?;
          break;
        case 'roomsMin':
          _filters.roomsMin = value as int?;
          break;
        case 'roomsMax':
          _filters.roomsMax = value as int?;
          break;
        case 'sqmMin':
          _filters.sqmMin = value as int?;
          break;
        case 'sqmMax':
          _filters.sqmMax = value as int?;
          break;
        case 'livingRoomsSqmMin':
          _filters.livingRoomsSqmMin = value as int?;
          break;
        case 'livingRoomsSqmMax':
          _filters.livingRoomsSqmMax = value as int?;
          break;
        case 'kitchenSqmMin':
          _filters.kitchenSqmMin = value as int?;
          break;
        case 'kitchenSqmMax':
          _filters.kitchenSqmMax = value as int?;
          break;
        case 'lotSqmMin':
          _filters.lotSqmMin = value as int?;
          break;
        case 'lotSqmMax':
          _filters.lotSqmMax = value as int?;
          break;
        case 'floorMin':
          _filters.floorMin = value as int?;
          break;
        case 'floorMax':
          _filters.floorMax = value as int?;
          break;
        case 'totalFloorsMin':
          _filters.totalFloorsMin = value as int?;
          break;
        case 'totalFloorsMax':
          _filters.totalFloorsMax = value as int?;
          break;
        case 'searchArea':
          _filters.searchArea = value as List<List<double>>?;
          break;
        case 'hasVideo':
          _filters.hasVideo = value as bool?;
          break;
        case 'documented':
          _filters.documented = value as bool?;
          break;
        case 'fromOwner':
          _filters.fromOwner = value as bool?;
          break;
        case 'withoutRedevelopment':
          _filters.withoutRedevelopment = value as bool?;
          break;
        case 'sort':
          _filters.sort = value as SortType;
          break;
        default:
      }
    });
    notifyListeners();
  }

  void clearPosts() {
    _posts = [];
    _pagination = Pagination(
      current: 0,
    );
  }

  Future<void> fetchAndSetPosts({
    Map<String, dynamic>? queryParameters,
    int page = 1,
    bool updatePosts = false,
    PostType postType = PostType.confirmed,
  }) async {
    Map<String, dynamic> parameters;

    if (queryParameters == null) {
      parameters = _filters.toQueryParameters();
    } else {
      parameters = queryParameters;
    }

    parameters.removeWhere((key, value) => value == null);

    parameters['page'] = page.toString();
    parameters['limit'] = '20';

    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path:
          'api/posts${postType == PostType.unreviewed ? '/unreviewed_posts' : ''}',
      queryParameters: parameters,
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'JWT $token'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      final List<Post> loadedPosts = [];
      data['result'].forEach((element) {
        loadedPosts.add(Post.fromJson(json: element, postType: postType));
      });

      if (updatePosts) {
        _posts.addAll(loadedPosts);
      } else {
        _posts = loadedPosts;
      }

      _pagination = Pagination.fromJson(
        data['pagination'],
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSinglePost({
    required int id,
    PostType postType = PostType.confirmed,
  }) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/post/$id',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'JWT $token'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      final result = Post.fromJson(json: data, postType: postType);

      _postData = result;
      if (_posts.firstWhereOrNull((element) => element.id == result.id) ==
          null) {
        _posts.add(result);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetPostsLocations() async {
    final Map<String, dynamic> parameters = _filters.toQueryParameters();
    parameters.removeWhere((key, value) => value == null);

    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/locations',
      queryParameters: parameters,
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'JWT $token'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      final List<PostLocation> loadedLocations = [];
      data.forEach((element) {
        loadedLocations.add(
          PostLocation.fromJson(
            json: element,
          ),
        );
      });

      _postsLocations = loadedLocations;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createPost(Post post) async {
    final data = post.toJson();
    data.removeWhere((key, value) => value == null);
    try {
      final url = Uri.parse('$baseUrl/api/posts');
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
        },
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updatePost(Post post) async {
    final data = post.toJson();
    data.removeWhere((key, value) => value == null);
    try {
      final url = Uri.parse('$baseUrl/api/posts/${post.id}');
      final response = await http.put(
        url,
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
        },
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deletePost({
    required int postId,
    required PostType postType,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/posts${postType == PostType.unreviewed ? '/unreviewed_posts' : ''}/$postId',
      );
      final response =
          await http.delete(url, headers: {'Authorization': 'JWT $token'});

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getImageUploadId() async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/generate_upload_id',
    );

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'JWT $token'});

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      return data['id'] as String;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> uploadImage(XFile file, String id) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/upload_image',
    );

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'JWT $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['id'] = id;
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          await file.readAsBytes(),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteImage(String id) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/delete_image/$id',
    );

    try {
      final response =
          await http.delete(url, headers: {'Authorization': 'JWT $token'});

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }

  Post findById(int id) {
    return _posts.firstWhere((element) => element.id == id);
  }

  Future<String> fetchPostPhoneNumber(int id) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/phone_number/$id',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      return data['phoneNumber'] as String;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> blockPostForModeration(
    int postId,
  ) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/block_for_moderation/$postId',
    );

    var result = false;

    try {
      final response = await http.put(
        url,
        headers: {'Authorization': 'JWT $token'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      result = true;

      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return result;
  }

  Future<void> unblockPostFromModeration(
    int postId,
  ) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/unblock_from_moderation/$postId',
    );

    try {
      final response = await http.put(
        url,
        headers: {'Authorization': 'JWT $token'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> confirmPost(
    int postId,
  ) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/confirm/$postId',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
        },
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rejectPost(int postId, String comment) async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/posts/reject/$postId',
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'comment': comment,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
        },
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
