import 'models/appointment_model.dart';
import 'models/appointment_status.dart';

/// TODO: بيانات تجريبية لحد ما توصل الشاشة مع الـ backend الحقيقي - كل
/// مواعيد المريض المفروض تجي من الـ API (نفس نمط باقي الشاشات بالتطبيق).
/// القائمة هون بتغطي كل حالة من حالات دورة حياة الموعد السبعة، حتى نتأكد
/// الديزاين والشارات صح بكل حالة.
///
/// العيادة فيها طبيب واحد بس، فكل المواعيد إلها نفس الطبيب.
const String _doctorName = 'د. سمير إبراهيم';
const String _doctorSpecialty = 'طبيب أسنان عام';

List<Appointment> buildMockAppointments() {
  final now = DateTime.now();

  return [
    // قيد الانتظار - بانتظار تأكيد العيادة (auto confirmation = off).
    Appointment(
      id: 'apt-1',
      visitTypeLabel: 'استشارة ألم',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.add(const Duration(days: 3, hours: 2)),
      status: AppointmentStatus.pendingConfirmation,
    ),

    // مؤكد - جاهز، بيقدر المريض يلغيه أو يعدله.
    Appointment(
      id: 'apt-2',
      visitTypeLabel: 'تنظيف وتلميع',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.add(const Duration(days: 6, hours: 5)),
      status: AppointmentStatus.confirmed,
      treatmentSessionId: 'session-9',
    ),

    // وصل العيادة (Check-In) - بانتظار دوره لعند الطبيب.
    Appointment(
      id: 'apt-3',
      visitTypeLabel: 'متابعة تقويم الأسنان',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.add(const Duration(hours: 1)),
      status: AppointmentStatus.checkedIn,
      treatmentSessionId: 'session-14',
    ),

    // فات لعند الطبيب وجاري تنفيذ الجلسة حالياً.
    Appointment(
      id: 'apt-4',
      visitTypeLabel: 'حشوة ضرس',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.subtract(const Duration(minutes: 20)),
      status: AppointmentStatus.inTreatment,
    ),

    // مواعيد سابقة - مكتمل.
    Appointment(
      id: 'apt-5',
      visitTypeLabel: 'فحص وتنظيف دوري',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.subtract(const Duration(days: 10)),
      status: AppointmentStatus.completed,
    ),
    Appointment(
      id: 'apt-6',
      visitTypeLabel: 'خلع ضرس العقل',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.subtract(const Duration(days: 45)),
      status: AppointmentStatus.completed,
    ),

    // ملغى - المريض ألغاه بنفسه قبل المهلة المسموحة.
    Appointment(
      id: 'apt-7',
      visitTypeLabel: 'استشارة تجميل أسنان',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.subtract(const Duration(days: 5)),
      status: AppointmentStatus.cancelled,
    ),

    // لم يحضر - الجلسة العلاجية المرتبطة لسا جاهزة لإعادة الحجز.
    Appointment(
      id: 'apt-8',
      visitTypeLabel: 'جلسة متابعة علاج العصب',
      doctorName: _doctorName,
      doctorSpecialty: _doctorSpecialty,
      scheduledAt: now.subtract(const Duration(days: 2)),
      status: AppointmentStatus.noShow,
      treatmentSessionId: 'session-21',
    ),
  ];
}
