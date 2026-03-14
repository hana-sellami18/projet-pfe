// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    SubjectDetailRoute.name: (routeData) {
      final args = routeData.argsAs<SubjectDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SubjectDetailPage(
          key: args.key,
          sujet: args.sujet,
        ),
      );
    },
    SubjectListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SubjectListPage(),
      );
    },
    UploadCvRoute.name: (routeData) {
      final args = routeData.argsAs<UploadCvRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UploadCvPage(
          key: args.key,
          sujetId: args.sujetId,
        ),
      );
    },
  };
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SubjectDetailPage]
class SubjectDetailRoute extends PageRouteInfo<SubjectDetailRouteArgs> {
  SubjectDetailRoute({
    Key? key,
    required SujetModel sujet,
    List<PageRouteInfo>? children,
  }) : super(
          SubjectDetailRoute.name,
          args: SubjectDetailRouteArgs(
            key: key,
            sujet: sujet,
          ),
          initialChildren: children,
        );

  static const String name = 'SubjectDetailRoute';

  static const PageInfo<SubjectDetailRouteArgs> page =
      PageInfo<SubjectDetailRouteArgs>(name);
}

class SubjectDetailRouteArgs {
  const SubjectDetailRouteArgs({
    this.key,
    required this.sujet,
  });

  final Key? key;

  final SujetModel sujet;

  @override
  String toString() {
    return 'SubjectDetailRouteArgs{key: $key, sujet: $sujet}';
  }
}

/// generated route for
/// [SubjectListPage]
class SubjectListRoute extends PageRouteInfo<void> {
  const SubjectListRoute({List<PageRouteInfo>? children})
      : super(
          SubjectListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SubjectListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UploadCvPage]
class UploadCvRoute extends PageRouteInfo<UploadCvRouteArgs> {
  UploadCvRoute({
    Key? key,
    required int sujetId,
    List<PageRouteInfo>? children,
  }) : super(
          UploadCvRoute.name,
          args: UploadCvRouteArgs(
            key: key,
            sujetId: sujetId,
          ),
          initialChildren: children,
        );

  static const String name = 'UploadCvRoute';

  static const PageInfo<UploadCvRouteArgs> page =
      PageInfo<UploadCvRouteArgs>(name);
}

class UploadCvRouteArgs {
  const UploadCvRouteArgs({
    this.key,
    required this.sujetId,
  });

  final Key? key;

  final int sujetId;

  @override
  String toString() {
    return 'UploadCvRouteArgs{key: $key, sujetId: $sujetId}';
  }
}
