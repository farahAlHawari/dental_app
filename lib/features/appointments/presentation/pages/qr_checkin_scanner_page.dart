import 'package:dental_app/core/services/whatsapp_service.dart';
import 'package:dental_app/core/utils/clinic_contact.dart';
import 'package:dental_app/core/widgets/custom_confirmation_dialog.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// شاشة مسح رمز QR لتأكيد وصول المريض للعيادة — POST appointments/check-in
class QrCheckinScannerPage extends StatefulWidget {
  final String patientId;
  final String? appointmentId;

  const QrCheckinScannerPage({
    super.key,
    required this.patientId,
    this.appointmentId,
  });

  @override
  State<QrCheckinScannerPage> createState() => _QrCheckinScannerPageState();
}

class _QrCheckinScannerPageState extends State<QrCheckinScannerPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  late final AnimationController _scanLineController;
  bool _handled = false;
  bool _checkingIn = false;

  static const _frameColor = Color(0xFF35D6C4);

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled || _checkingIn || capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue?.trim();
    if (raw == null || raw.length < 8) return;
    _performCheckIn(raw);
  }

  Future<Position?> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<void> _performCheckIn(String clinicCheckInCode) async {
    if (_handled || _checkingIn) return;

    setState(() => _checkingIn = true);
    _controller.stop();

    final result = await _getCurrentPosition();
    if (!mounted) return;

    if (result == null) {
      setState(() => _checkingIn = false);
      _controller.start();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required for check-in.'.tr())),
      );
      return;
    }

    context.read<AppointmentsBloc>().add(
          CheckInAppointmentRequested(
            patientId: widget.patientId,
            clinicCheckInCode: clinicCheckInCode,
            latitude: result.latitude,
            longitude: result.longitude,
            appointmentId: widget.appointmentId,
          ),
        );
  }

  void _showSuccessDialog() {
    _handled = true;
    CustomConfirmationDialog.show(
      context,
      title: 'Attendance Confirmed'.tr(),
      description:
          'Your arrival at the clinic has been confirmed successfully.'.tr(),
      confirmButtonText: 'Done'.tr(),
      onConfirm: () {
        Navigator.pop(context);
        Navigator.pop(context, true);
      },
    );
  }

  Future<void> _enterCodeManually() async {
    if (_handled || _checkingIn) return;

    final controller = TextEditingController();
    final colors = Theme.of(context).colorScheme;

    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Enter code manually'.tr()),
        content: TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Reception code'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            child: Text('Confirm'.tr()),
          ),
        ],
      ),
    );

    if (code != null && code.length >= 8) {
      await _performCheckIn(code);
    }
  }

  void _contactHelp() {
    WhatsAppService.openWhatsApp(
      phone: ClinicContact.whatsAppNumber,
      message: 'مرحبا، عندي مشكلة بتأكيد الوصول عبر رمز QR بالعيادة.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final frameSize = size.width * 0.68;
    final frameRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.38),
      width: frameSize,
      height: frameSize,
    );
    const topRowHeight = 52.0;
    final spacerHeight =
        (frameRect.bottom - mediaQuery.padding.top - topRowHeight).clamp(
          0.0,
          double.infinity,
        );

    return BlocListener<AppointmentsBloc, AppointmentsState>(
      listener: (context, state) {
        if (state is CheckInAppointmentLoading) {
          setState(() => _checkingIn = true);
        } else if (state is CheckInAppointmentSuccess) {
          _showSuccessDialog();
        } else if (state is CheckInAppointmentFailure) {
          setState(() => _checkingIn = false);
          _controller.start();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Container(
              color: Colors.black,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not access the camera. Please check camera permission.'
                    .tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
          if (_checkingIn)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: _frameColor),
                  const SizedBox(height: 16),
                  Text(
                    'Confirming your arrival...'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          CustomPaint(
            painter: _ScannerOverlayPainter(
              frameRect: frameRect,
              borderColor: _frameColor,
            ),
          ),
          AnimatedBuilder(
            animation: _scanLineController,
            builder: (context, child) {
              final top =
                  frameRect.top +
                  8 +
                  (frameRect.height - 16) * _scanLineController.value;
              return Positioned(
                left: frameRect.left + 12,
                right: size.width - frameRect.right + 12,
                top: top,
                child: Container(
                  height: 2.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        _frameColor.withOpacity(0),
                        _frameColor.withOpacity(0.9),
                        _frameColor.withOpacity(0),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _frameColor.withOpacity(0.7),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<MobileScannerState>(
                        valueListenable: _controller,
                        builder: (context, state, child) {
                          final torchOn = state.torchState == TorchState.on;
                          final torchAvailable =
                              state.torchState != TorchState.unavailable;
                          return _CircleIconButton(
                            icon: torchOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            onTap: torchAvailable && !_checkingIn
                                ? () => _controller.toggleTorch()
                                : null,
                          );
                        },
                      ),
                      _CircleIconButton(
                        icon: Icons.close_rounded,
                        onTap: _checkingIn ? null : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacerHeight),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        'Point your camera at the QR code at reception'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your arrival will be confirmed automatically'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _checkingIn ? null : _contactHelp,
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white70,
                          size: 18,
                        ),
                        label: Text(
                          'Need help?'.tr(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Container(width: 1, height: 16, color: Colors.white24),
                      TextButton(
                        onPressed: _checkingIn ? null : _enterCodeManually,
                        child: Text(
                          'Enter code manually'.tr(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onTap == null ? Colors.white30 : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Rect frameRect;
  final Color borderColor;

  _ScannerOverlayPainter({required this.frameRect, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(28);
    final cutoutRRect = RRect.fromRectAndRadius(frameRect, radius);

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(cutoutRRect);
    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    const cornerLength = 26.0;
    const r = 28.0;

    void drawCorner(Offset corner, double dx, double dy) {
      final path = Path()
        ..moveTo(corner.dx, corner.dy + dy * cornerLength)
        ..lineTo(corner.dx, corner.dy + dy * r)
        ..quadraticBezierTo(
          corner.dx,
          corner.dy,
          corner.dx + dx * r,
          corner.dy,
        )
        ..lineTo(corner.dx + dx * cornerLength, corner.dy);
      canvas.drawPath(path, cornerPaint);
    }

    drawCorner(frameRect.topLeft, 1, 1);
    drawCorner(frameRect.topRight, -1, 1);
    drawCorner(frameRect.bottomLeft, 1, -1);
    drawCorner(frameRect.bottomRight, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) =>
      oldDelegate.frameRect != frameRect ||
      oldDelegate.borderColor != borderColor;
}
