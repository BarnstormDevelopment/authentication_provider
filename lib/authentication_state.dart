class AuthenticationState {
  const AuthenticationState();
}

class Authenticated<T extends Object> extends AuthenticationState {
  T user;
  dynamic data;
  Authenticated({required this.user, this.data});
}

class Unauthenticated extends AuthenticationState {
  dynamic data;
  Unauthenticated({this.data});
}

class Loading extends AuthenticationState {
  dynamic data;
  Loading({this.data});
}

class Uninitialized extends AuthenticationState {
  const Uninitialized();
}
