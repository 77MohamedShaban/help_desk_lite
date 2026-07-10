// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:help_desk_lite/core/di/register_module.dart' as _i977;
import 'package:help_desk_lite/features/authentication/data/repositories/firebase_auth_repository.dart'
    as _i200;
import 'package:help_desk_lite/features/authentication/data/repositories/firebase_user_repository.dart'
    as _i552;
import 'package:help_desk_lite/features/authentication/domain/repositories/auth_repository.dart'
    as _i930;
import 'package:help_desk_lite/features/authentication/domain/repositories/user_repository.dart'
    as _i265;
import 'package:help_desk_lite/features/authentication/presentation/cubit/auth_cubit.dart'
    as _i467;
import 'package:help_desk_lite/features/notifications/presentation/cubit/notification_cubit.dart'
    as _i46;
import 'package:help_desk_lite/features/tickets/data/repositories/firebase_comment_repository.dart'
    as _i982;
import 'package:help_desk_lite/features/tickets/data/repositories/firebase_ticket_repository.dart'
    as _i521;
import 'package:help_desk_lite/features/tickets/domain/repositories/comment_repository.dart'
    as _i199;
import 'package:help_desk_lite/features/tickets/domain/repositories/ticket_repository.dart'
    as _i202;
import 'package:help_desk_lite/features/tickets/presentation/cubit/comment_cubit.dart'
    as _i6;
import 'package:help_desk_lite/features/tickets/presentation/cubit/ticket_details_cubit.dart'
    as _i262;
import 'package:help_desk_lite/features/tickets/presentation/cubit/ticket_list_cubit.dart'
    as _i332;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => registerModule.firebaseMessaging,
    );
    gh.lazySingleton<_i930.AuthRepository>(
      () => _i200.FirebaseAuthRepository(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i202.TicketRepository>(
      () => _i521.FirebaseTicketRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i265.UserRepository>(
      () => _i552.FirebaseUserRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i46.NotificationCubit>(
      () => _i46.NotificationCubit(gh<_i892.FirebaseMessaging>()),
    );
    gh.lazySingleton<_i199.CommentRepository>(
      () => _i982.FirebaseCommentRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i6.CommentCubit>(
      () => _i6.CommentCubit(gh<_i199.CommentRepository>()),
    );
    gh.factory<_i262.TicketDetailsCubit>(
      () => _i262.TicketDetailsCubit(gh<_i202.TicketRepository>()),
    );
    gh.factory<_i332.TicketListCubit>(
      () => _i332.TicketListCubit(gh<_i202.TicketRepository>()),
    );
    gh.factory<_i467.AuthCubit>(
      () => _i467.AuthCubit(gh<_i930.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i977.RegisterModule {}
