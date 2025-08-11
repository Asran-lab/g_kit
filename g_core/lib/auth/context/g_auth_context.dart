import 'dart:async';

import 'package:g_core/auth/auth.dart';
import 'package:g_core/auth/common/g_auth_state.dart';

typedef GAuthStateListener = void Function(GAuthState);

class GAuthContext {
  GAuthContext._();
  static final GAuthContext I = GAuthContext._();

  GAuthState _state = GAuthState.signedOut();
  final _ctrl = StreamController<GAuthState>.broadcast();

  GAuthState get state => _state;
  Stream<GAuthState> get stateStream => _ctrl.stream;

  void _emit(GAuthState state) {
    _state = state;
    _ctrl.add(state);
  }

  void setSigningIn() => _emit(GAuthState.signingIn());

  void setSignedIn(String userId) => _emit(GAuthState.signedIn(userId));

  void setSignedOut() => _emit(GAuthState.signedOut());

  void dispose() => _ctrl.close();
}
