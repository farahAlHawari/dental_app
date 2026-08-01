import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// شريط تنقل سفلي عائم بخمس أيقونات، بنفس أسلوب باقي التطبيق (زوايا
/// دائرية، ظل خفيف، تلوين العنصر المختار بالـ primary). عنصر "الرئيسية"
/// (بالنص) أكبر حجماً دايماً حتى يبرز عن الباقي، وبيرتفع شوي لفوق لما
/// يكون هو المختار.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// أيقونات مؤقتة - TODO: بدّلي أي عنصر هون بأنميشن Lottie لما تجهزيه،
  /// عنصر عنصر، بلا ما تحتاجي تلمسي بنية الملف أو باقي الكود. أيقونة
  /// "الرئيسية" تحديداً صارت أنميشن Lottie (شوفي [_homeAnimationAsset]).
  /// الترتيب بيطابق شكل الناف بار من اليمين لليسار: مواعيدي، ملفي
  /// الشخصي، الرئيسية (بالنص)، خططي العلاجية، المعرض التسويقي.
  static const List<IconData> icons = [
    Icons.person_rounded, // ملفي الشخصي
    Icons.calendar_month_rounded, // مواعيدي

    Icons.home_rounded, // الرئيسية (احتياطي - بيظهر بس لو فشل تحميل الأنميشن)
    Icons.medical_information_rounded, // خططي العلاجية
    Icons.campaign_rounded, // المعرض التسويقي
  ];

  static const String _homeAnimationAsset =
      'assets/animations/Home_Icon_Animation.json';

  /// index العنصر يلي بدنا نبرزه بصرياً (الرئيسية، بالنص).
  static const int emphasizedIndex = 2;

  static const double _normalSize = 44;
  static const double _emphasizedSize = 44;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = index == currentIndex;
          final isEmphasized = index == emphasizedIndex;
          final size = isEmphasized ? _emphasizedSize : _normalSize;

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              offset: isSelected && isEmphasized ? Offset.zero : Offset.zero,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: index == emphasizedIndex
                    ? _AnimatedHomeIcon(
                        isSelected: isSelected,
                        size: 26,
                        selectedColor: Colors.white,
                        // لون رمادي صريح (opaque) بدل رمادي شفاف، لأنه
                        // تلوين الأنميشن (تحت) بيحتاج لون صلب لضمان
                        // نتيجة موحدة بلا اختلاف تدرّج حسب الخلفية.
                        unselectedColor: Color.alphaBlend(
                          colors.onSurface.withOpacity(0.45),
                          colors.surface,
                        ),
                      )
                    : Icon(
                        icons[index],
                        size: isEmphasized ? 26 : 22,
                        color: isSelected
                            ? Colors.white
                            : colors.onSurface.withOpacity(0.45),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// أيقونة "الرئيسية" كأنميشن Lottie بدل أيقونة ثابتة. بتشتغل بحلقة
/// (loop) بس وإحنا واقفين فعلاً على تبويب "الرئيسية" (isSelected)،
/// وبتوقف وترجع لأول فريم لما نبعد عنه. التلوين عن طريق [ColorFiltered]
/// بـ [BlendMode.srcIn]: بيوخد قناع الشفافية (alpha) لكل بكسل مرسوم -
/// تعبئة كانت أو حافة (stroke) - وبيرسمه كامل بلون واحد فقط (رمادي لما
/// ما تكون محددة، أبيض لما تكون محددة)، بغض النظر عن ألوانه الأصلية
/// بالملف. جربنا قبل [LottieDelegates] بس طلعت بتلوّن بعض الأشكال
/// (Fill) وما بتغطي الحواف (Stroke) بنفس الوقت.
///
/// ملاحظة مهمة عن الحجم: الدائرة اللي لافّة الأيقونة ([AppBottomNavBar]
/// فوق) ثابتة الحجم (44×44) وبتفرض قيود Layout "صارمة" (tight) على أي
/// إشي جواها. أيقونة [Icon] العادية ما بتتأثر بهاي القيود لأنها بترسم
/// حرف بخط (font glyph) بحجم ثابت (fontSize) بغض النظر عن حجم الصندوق
/// اللي يحيط فيها، لكن [Lottie] بيكبّر/يصغّر محتواه ليملأ أي صندوق
/// يتحط فيه (BoxFit.contain) - فلو حطيناه مباشرة جوا هيك دائرة، رح
/// يتمدد ليصير 44×44 دايماً بغض النظر عن أي حجم نطلبه منه! لهيك لازم
/// نلفّه بـ [Center]: بيمتص هو القيود الصارمة (بيصير حجمه 44×44
/// إرضاءً للأب)، بس بيدي لابنه (Lottie) قيود "مرنة" (loose) فبيقدر
/// يصغر لحجمه الحقيقي المطلوب ويترسم بالنص.
class _AnimatedHomeIcon extends StatefulWidget {
  final bool isSelected;
  final double size;
  final Color selectedColor;
  final Color unselectedColor;

  const _AnimatedHomeIcon({
    required this.isSelected,
    required this.size,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  State<_AnimatedHomeIcon> createState() => _AnimatedHomeIconState();
}

class _AnimatedHomeIconState extends State<_AnimatedHomeIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant _AnimatedHomeIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller
        ..value = 0
        ..repeat();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      // بنوقف عالفريم الأخير (البيت مرسوم بالكامل) مش الأول، لأنه أول
      // فريم بالملف أصلاً شبه فاضي (الرسمة لسا ما بدأت تنكشف) فكانت
      // عم تبين بيضا/فاضية بدل رمادي.
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? widget.selectedColor
        : widget.unselectedColor;

    return Center(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: Lottie.asset(
          AppBottomNavBar._homeAnimationAsset,
          controller: _controller,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            if (widget.isSelected) {
              _controller.repeat();
            } else {
              // نفس ملاحظة didUpdateWidget: أول فريم فاضي تقريباً، فمنبلش
              // مباشرة من آخر فريم (البيت كامل) لما ما تكون محددة.
              _controller.value = 1;
            }
          },
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.home_rounded, size: widget.size, color: color),
        ),
      ),
    );
  }
}
