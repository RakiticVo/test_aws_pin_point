import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:test_aws_pin_point/app_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnalyticsEvent event = AnalyticsEvent('Sign In');

  void recordEvent() async {
    try {
      await AmplifyAnalyticsPinpoint().recordEvent(event: event);
      print('Event recorded successfully.');
    } catch (e) {
      print('Failed to record event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Recording'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            // AppConfig().testPinpoint();
          },
          child: Text('Record Event'),
        ),
      ),
    );
  }
}
