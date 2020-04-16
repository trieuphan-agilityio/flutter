import 'dart:convert';

import 'package:bloc_post/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({@required this.httpClient});

  @override
  PostState get initialState => PostUninitialized();

  @override
  Stream<PostState> transformEvents(
      Stream<PostEvent> events, Function transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;

    if (event is Fetch && !_hasReachMax(currentState)) {
      List<Post> posts;

      if (currentState is PostUninitialized) {
        try {
          posts = await _fetchPosts(0, 20);
        } catch (_) {
          yield PostError();
        }
        yield PostLoaded(posts: posts, hasReachedMax: false);
        return;
      }

      if (currentState is PostLoaded) {
        try {
          posts = await _fetchPosts(currentState.posts.length, 20);
        } catch (_) {
          yield PostError();
        }
        yield posts.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : PostLoaded(
                posts: currentState.posts + posts,
                hasReachedMax: false,
              );
      }
    }
  }

  bool _hasReachMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
