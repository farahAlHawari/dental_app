import 'dart:async';

import 'package:dental_app/core/services/whatsapp_service.dart';
import 'package:dental_app/core/utils/clinic_contact.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/widgets/custom_confirmation_dialog.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  /// يطابق شكل كود العيادة في الباك: `clinic-checkin.` + 32 hex.
  static final RegExp _clinicCodePattern = RegExp(
    r'^clinic-checkin\.[a-fA-F0-9]{32}$',
  );

  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
    autoStart: true,
  );

  late final AnimationController _scanLineController;
  Future<Position?>? _warmLocationFuture;

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
    // تجهيز الموقع أثناء ما المريض يوجّه الكاميرا.
    _warmLocationFuture = _resolvePosition();
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isValidClinicCode(String raw) => _clinicCodePattern.hasMatch(raw);

  void _onDetect(BarcodeCapture capture) {
    if (_handled || _checkingIn || capture.barcodes.isEmpty) return;

    final raw = capture.barcodes
        .map((b) => b.rawValue?.trim())
        .whereType<String>()
        .firstWhere(
          (value) => value.isNotEmpty,
          orElse: () => '',
        );
    if (raw.isEmpty) return;

    // قفل فوري قبل أي await حتى ما يتكرر الكشف.
    _lockScanner();

    if (!_isValidClinicCode(raw)) {
      _unlockScanner();
      _showMessage(
        'Invalid check-in code. Please scan the clinic QR again.'.tr(),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    unawaited(_performCheckIn(raw));
  }

  void _lockScanner() {
    _checkingIn = true;
    unawaited(_controller.stop());
    if (mounted) setState(() {});
  }

  void _unlockScanner() {
    if (_handled) return;
    _checkingIn = false;
    if (mounted) {
      setState(() {});
      unawaited(_controller.start());
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Position?> _resolvePosition() async {
    try {
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

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Position?> _ensurePosition() async {
    final warmed = await (_warmLocationFuture ?? _resolvePosition());
    if (warmed != null) return warmed;

    // محاولة ثانية لو التجهيز المسبق فشل أو انتهت صلاحيته.
    _warmLocationFuture = _resolvePosition();
    return _warmLocationFuture;
  }

  Future<void> _performCheckIn(String clinicCheckInCode) async {
    if (_handled) return;

    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      _unlockScanner();
      return;
    }
    if (!mounted) return;

    if (!_checkingIn) {
      _lockScanner();
    }

    final position = await _ensurePosition();
    if (!mounted) return;

    if (position == null) {
      _unlockScanner();
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      var permission = await Geolocator.checkPermission();
      final needsPermission = permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          !serviceEnabled;
      _showMessage(
        needsPermission
            ? 'Location permission is required for check-in.'.tr()
            : 'Could not determine your location. Please try again.'.tr(),
      );
      return;
    }

    context.read<AppointmentsBloc>().add(
          CheckInAppointmentRequested(
            patientId: widget.patientId,
            clinicCheckInCode: clinicCheckInCode,
            latitude: position.latitude,
            longitude: position.longitude,
            appointmentId: widget.appointmentId,
          ),
        );
  }

  void _showSuccessDialog() {
    _handled = true;
    _checkingIn = true;
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

    final colors = Theme.of(context).colorScheme;

    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => const _ManualCodeSheet(),
    );

    if (code == null || code.isEmpty) return;

    if (!_isValidClinicCode(code)) {
      _showMessage(
        'Invalid check-in code. Please scan the clinic QR again.'.tr(),
      );
      return;
    }

    _lockScanner();
    await _performCheckIn(code);
  }

  void _contactHelp() {
    WhatsAppService.openWhatsApp(
      phone: ClinicContact.whatsAppNumber,
      message: 'مرحبا، عندي مشكلة بتأكيد الوصول عبر رمز QR بالعيادة.',
    );
  }

  Rect _frameRectFor(Size size) {
    final frameSize = size.width * 0.68;
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.38),
      width: frameSize,
      height: frameSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final frameRect = _frameRectFor(size);
    const topRowHeight = 52.0;
    final spacerHeight =
        (frameRect.bottom - mediaQuery.padding.top - topRowHeight).clamp(
          0.0,
          double.infinity,
        );

    return BlocListener<AppointmentsBloc, AppointmentsState>(
      listener: (context, state) {
        if (state is CheckInAppointmentLoading) {
          if (!_checkingIn) {
            setState(() => _checkingIn = true);
          }
        } else if (state is CheckInAppointmentSuccess) {
          _showSuccessDialog();
        } else if (state is CheckInAppointmentFailure) {
          _unlockScanner();
          // إعادة تجهيز الموقع لمحاولة لاحقة.
          _warmLocationFuture = _resolvePosition();
          _showMessage(state.errMessage);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              scanWindow: frameRect,
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
                          onTap:
                              _checkingIn ? null : () => Navigator.pop(context),
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
                        Container(
                          width: 1,
                          height: 16,
                          color: Colors.white24,
                        ),
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

class _ManualCodeSheet extends StatefulWidget {
  const _ManualCodeSheet();

  @override
  State<_ManualCodeSheet> createState() => _ManualCodeSheetState();
}

class _ManualCodeSheetState extends State<_ManualCodeSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter code manually'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Reception code'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'.tr()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    _controller.text.trim(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Confirm'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
