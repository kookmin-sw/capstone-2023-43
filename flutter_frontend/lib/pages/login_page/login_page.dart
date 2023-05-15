import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../amplifyconfiguration.dart';
import '../../service/http_response_service.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  Future<bool> Login() async {
    SignInResult res;

    var _isSignedIn = false;
    try {
      res = await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
      _isSignedIn = res.isSignedIn;
    } on AmplifyException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        print('problem ocurred! sign out');
      }
      print(e.message);
      print(e.recoverySuggestion);
    }

    return _isSignedIn;
  }

  Future<String> getToken() async {
    late final CognitoAuthSession session;
    late final String? cognitoAuthSessionToken;
    try {
      session = await Amplify.Auth.fetchAuthSession(
              options: CognitoSessionOptions(getAWSCredentials: true))
          as CognitoAuthSession;
      cognitoAuthSessionToken = session.userPoolTokens?.idToken;
    } catch (e) {
      print(e);
    }
    return cognitoAuthSessionToken!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isLoading = useState(false);
    return BaseWidget(
      body: Center(
        child: isLoading.value
            ? CircularProgressIndicator()
            : BaseButton(
                text: 'click me! to google login this app!',
                onTap: () {
                  Login().then((isSignedIn) {
                    if (isSignedIn) {
                      getToken().then((token) {
                        ref.read(HttpResponseServiceProvider).setToken(token);
                        ref
                            .read(HttpResponseServiceProvider)
                            .initResponse()
                            .then((_) {
                          if (ref.read(HttpResponseServiceProvider).stage ==
                              ResposeStage.newUser) {
                            ref
                                .read(HttpResponseServiceProvider)
                                .postNewUser("김재하", "M",
                                    DateTime.utc(1999, 6, 26), 0, false, false)
                                .then((value) {
                              if (ref.read(HttpResponseServiceProvider).stage ==
                                  ResposeStage.ready) {
                                Navigator.pushReplacementNamed(
                                    context, '/main');
                              }
                            });
                          } else if (ref
                                  .read(HttpResponseServiceProvider)
                                  .stage ==
                              ResposeStage.ready) {
                            Navigator.pushReplacementNamed(context, '/main');
                          }
                        });
                      });
                    }
                  });
                  isLoading.value = true;
                },
              ),
      ),
    );
  }
}
