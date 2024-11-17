import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/data/firebase_auth_repo.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/features/auth/presentation/cubits/auth_state.dart';
import 'package:social/features/auth/presentation/pages/auth_page.dart';
import 'package:social/core/presentation/pages/root.dart';
import 'package:social/features/chat/data/firebase_chat_repo.dart';
import 'package:social/features/chat/presentation/cubits/chatmessage_cubit.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_cubit.dart';
import 'package:social/features/post/data/firebase_post_repo.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/profile_post_cubit.dart';
import 'package:social/features/profile/data/firebase_profile_repo.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social/features/storage/data/supabase_storage_repo.dart';
import 'package:social/core/theme/my_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // repos
    final authRepo = FirebaseAuthRepo();
    final profileRepo = FirebaseProfileRepo();
    final storageRepo = SupabaseStorageRepo();
    final postRepo = FirebasePostRepo();
    final chatRepo = FirebaseChatRepo();

    // bloc provider
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: profileRepo,
            storageRepo: storageRepo,
          ),
        ),

        // post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: postRepo,
            storageRepo: storageRepo,
          ),
        ),

        // profile post cubit
        BlocProvider<ProfilePostCubit>(
          create: (context) => ProfilePostCubit(
            postRepo: postRepo,
          ),
        ),

        // chatroom cubit
        BlocProvider<ChatroomCubit>(
          create: (context) => ChatroomCubit(
            chatRepo: chatRepo,
            authRepo: authRepo,
          ),
        ),

        // chatmessage cubit
        BlocProvider<ChatmessageCubit>(
          create: (context) => ChatmessageCubit(
            chatRepo: chatRepo,
            authRepo: authRepo,
          ),
        ),
      ],
      child: MaterialApp(
        // device preview
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        // device preview
        debugShowCheckedModeBanner: false,
        title: 'social',
        theme: myTheme,
        // theme: ThemeData(
        //   scaffoldBackgroundColor: Colors.white,
        // ),
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              context.read<ChatroomCubit>().loadChatRooms();
              return const Root();
            } else if (state is Unauthenticated) {
              return const AuthPage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ),
    );
  }
}
