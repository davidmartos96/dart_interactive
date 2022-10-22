import 'dart:developer';

import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class VmServiceWrapper {
  final VmService vmService;

  VmServiceWrapper._(this.vmService);

  static Future<VmServiceWrapper> create() async {
    final serverUri = (await Service.getInfo()).serverUri;
    if (serverUri == null) {
      throw Exception('Cannot find serverUri for VmService. '
          'Ensure you run like `dart run --enable-vm-service path/to/your/file.dart`');
    }

    final vmService = await vmServiceConnectUri(
        convertToWebSocketUrl(serviceProtocolUrl: serverUri).toString(),
        log: _Log());
    return VmServiceWrapper._(vmService);
  }

  void dispose() {
    vmService.dispose();
  }
}

class _Log extends Log {
  @override
  void warning(String message) => print('VMService warning: $message');

  @override
  void severe(String message) => print('VMService severe: $message');
}
