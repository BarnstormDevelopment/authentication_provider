import 'dart:async';

import 'package:flutter/material.dart';

import 'authentication_state.dart' as State;
import 'authentication_state.dart';

/// Manages the [AuthenticationProvider]
///
/// Contains the current [AuthenticationState] and streams for changes in data
class AuthenticationController<T extends Object> {
  late State.AuthenticationState _state;
  late BuildContext _context;

  /// Root build context of AuthenticationProvider
  ///
  /// This can be used to show dialogs even after the
  /// state has changed.
  BuildContext get context => _context;

  /// Called when [deauthenticate] is invoked with the root [BuildContext]
  late Function(BuildContext context, {dynamic data}) onDeauthenticate;

  /// Called when [authenticate] is invoked with the root [BuildContext]
  late Function(BuildContext context, {required T user, dynamic data}) onAuthenticate;

  /// Current [AuthenticationState] of the app
  State.AuthenticationState get state => _state;
  set state(State.AuthenticationState value) {
    _state = value;
    _stateStreamController.add(value);
  }

  late Future<State.AuthenticationState> Function() _initialize;

  late StreamController<AuthenticationState> _stateStreamController;

  late Stream _stateChanged;

  /// Streams a new [AuthenticationState] when the [state] is changed.
  Stream get stateChanged => _stateChanged;

  static Future<State.AuthenticationState> _di() async => State.Unauthenticated();
  static _doa(context, {dynamic user, dynamic data}) => null;
  static _dod(context, {dynamic data}) => null;

  AuthenticationController(BuildContext context,
      {Future<State.AuthenticationState> Function() initialize = _di,
      State.AuthenticationState? initialState,
      this.onAuthenticate = _doa,
      this.onDeauthenticate = _dod}) {
    _stateStreamController = StreamController();
    state = initialState ?? State.Uninitialized();
    _initialize = initialize;
    _context = context;
    _stateChanged = _stateStreamController.stream.asBroadcastStream();
  }

  /// Should be called whenever the widget that created this [AuthenticationController]
  /// instance is disposed of.
  void dispose() {
    _stateStreamController.close();
  }

  /// Called the first time the widget loads
  ///
  /// Allows for async calls, however the initialize function is not required
  /// and this functionality can be implemented in the builder passed to the
  /// [AuthenticationProvider] instead.
  void initialize() async {
    this.state = await _initialize();
  }

  /// Call to change state to [Authenticated]
  void authenticate({required T user, dynamic data}) {
    this.state = State.Authenticated<T>(user: user, data: data);
    onAuthenticate(context, user: user, data: data);
  }

  /// Call to change state to [Unauthenticated]
  void deauthenticate({dynamic data}) {
    this.state = State.Unauthenticated(data: data);
    onDeauthenticate(context, data: data);
  }

  /// Call to change state to [Loading]
  void loading({dynamic data}) {
    this.state = State.Loading(data: data);
  }
}
