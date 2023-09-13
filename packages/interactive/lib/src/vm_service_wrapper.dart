import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class VmServiceWrapper {
  final VmService vmService;

  VmServiceWrapper._({
    required this.vmService,
  });

  static Future<VmServiceWrapper> create() async {
    print("Getting service info");
    final serverUri = (await Service.getInfo()).serverUri;
    print("Got service info: $serverUri");
    if (serverUri == null) {
      throw Exception('Cannot find serverUri for VmService. '
          'Ensure you run like `dart run --enable-vm-service path/to/your/file.dart`');
    }

    print("connecting to service");
    final vmService = await vmServiceConnectUri(
        convertToWebSocketUrl(serviceProtocolUrl: serverUri).toString(),
        log: _Log());
    print("connected to service");

    return VmServiceWrapper._(vmService: vmService);
  }

  void dispose() {
    vmService.dispose();
  }
}

class _Log extends Log {
  final log = Logger('VmServiceLogger');

  @override
  void warning(String message) => log.warning(message);

  @override
  void severe(String message) => log.warning(message);
}
