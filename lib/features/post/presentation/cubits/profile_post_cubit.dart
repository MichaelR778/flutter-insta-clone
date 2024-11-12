import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/domain/repos/post_repo.dart';
import 'package:social/features/post/presentation/cubits/post_state.dart';

class ProfilePostCubit extends Cubit<PostState> {
  final PostRepo postRepo;

  ProfilePostCubit({required this.postRepo}) : super(PostsLoading());

  Future<void> fetchProfilePosts(String userId) async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchUserPosts(userId);
      emit(PostsLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
