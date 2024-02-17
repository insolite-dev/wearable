import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_kit/pulse_kit.dart';
import 'package:pulse_kit/pulse_kit_platform_interface.dart';
import 'package:pulse_kit/pulse_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPulseKitPlatform
    with MockPlatformInterfaceMixin
    implements PulseKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PulseKitPlatform initialPlatform = PulseKitPlatform.instance;

  test('$MethodChannelPulseKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPulseKit>());
  });

  test('getPlatformVersion', () async {
    PulseKit pulseKitPlugin = PulseKit();
    MockPulseKitPlatform fakePlatform = MockPulseKitPlatform();
    PulseKitPlatform.instance = fakePlatform;

    expect(await pulseKitPlugin.getPlatformVersion(), '42');
  });
}
