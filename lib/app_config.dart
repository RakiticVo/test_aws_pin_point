import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';

import 'amplifyconfiguration.dart';

class AppConfig {

  Future<bool> setAccessToken() async {
    final userPool = CognitoUserPool('ap-southeast-2_7i2LkcoFZ', '1100l1vgeefrsrud1d7iev2pol');
    final cognitoUser = CognitoUser('rakitic@voltarocks.com', userPool);
    final authDetails = AuthenticationDetails(username: 'rakitic@voltarocks.com', password: 'Test@123');
    // final credentials = CognitoCredentials('ap-southeast-2:b5476d7a-203d-4eae-a6a8-44b403d05370', userPool);

    // final result = await Amplify.Auth.fetchAuthSession(
    //     options: const FetchAuthSessionOptions(forceRefresh: true));
    // final cognitoAuthSession = (result as CognitoAuthSession);
    try {
      CognitoUserSession? session = await cognitoUser.authenticateUser(authDetails);

      // await credentials.getAwsCredentials(cognitoAuthSession.userPoolTokensResult.value);
      print('accessToken: ${session?.accessToken.jwtToken ?? 'null'}');
      String? jwtToken = session?.getAccessToken().getJwtToken();
      String token = (jwtToken == null) ? '' : jwtToken;

      var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String currentDate = dateFormatter.format(DateTime.now());
      return true;
    }
    catch(e) {
      print('error: ${e.toString()}');
      return false;
    }
  }

  Future<void> configAmplify() async {
    await Amplify.addPlugins([AmplifyAnalyticsPinpoint(), AmplifyAuthCognito(),]);
    try {
      await Amplify.configure(amplifyconfig);
      print('Success Configure');
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  Future<void> getIdToken() async {
    String idToken = '';
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
          options: const FetchAuthSessionOptions());
      idToken = (res as CognitoAuthSession).userPoolTokensResult.value.accessToken.toString();
      print('idToken = ${idToken}');
    } on AuthException catch (e) {
      print('Error in getting Token \n Error Details: $e');
    }
  }

  Future<void> signIn() async {
    try {
      SignInResult signInResult = await Amplify.Auth.signIn(
        username: 'rakitic@voltarocks.com',
        password: 'Test@123',
      );

      if (signInResult.isSignedIn) {
        // MFA setup is complete
        print('Sign In');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('Sign Out');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> testPinpoint() async {
    try {
      await AmplifyAnalyticsPinpoint().enable();
      await AmplifyAnalyticsPinpoint().addPlugin(authProviderRepo: AmplifyAuthProviderRepository());
      await AmplifyAnalyticsPinpoint().recordEvent(event: AnalyticsEvent('Test Notification'));
      print('Success');
      print('event: ${PinpointEventSource.campaign.name}');
      await AmplifyAnalyticsPinpoint().disable();
    } catch (e) {
      print('Failed: ${e.toString()}');
    }
  }
}
