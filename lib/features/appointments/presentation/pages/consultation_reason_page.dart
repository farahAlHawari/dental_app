import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_date_time_page.dart';
import 'package:dental_app/features/appointments/presentation/widgets/assistant_prompt_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// الشاشة يلي بتطلع لما المريض يختار "استشارة أولية" — بيكتب فيها سبب
/// الزيارة، أو يحكي مع المساعد الذكي وياخد ملخص المحادثة يعبّي فيه
/// التيكست بوكس. الخطوة 2 من 3 (بعد اختيار نوع الزيارة، قبل اختيار
/// الوقت والتاريخ).
class ConsultationReasonPage extends StatefulWidget {
  const ConsultationReasonPage({super.key});

  @override
  State<ConsultationReasonPage> createState() => _ConsultationReasonPageState();
}

class _ConsultationReasonPageState extends State<ConsultationReasonPage> {
  final _reasonController = TextEditingController();
  String? _chatSummary;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _startChat() async {
    // TODO: لما تصير شاشة الشات بوت جاهزة، هون منعمل push إلها ومنستنى
    // نتيجة من نوع String؟ (ملخص المحادثة يلي المفروض تولّده):
    //
    // final summary = await Navigator.push<String>(
    //   context,
    //   MaterialPageRoute(builder: (_) => const ChatbotPage()),
    // );
    // if (summary != null) setState(() => _chatSummary = summary);
  }

  void _useChatSummary() {
    if (_chatSummary == null) return;
    _reasonController.text = _chatSummary!;
    _reasonController.selection = TextSelection.fromPosition(
      TextPosition(offset: _reasonController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: colors.surfaceContainerHighest,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward, color: colors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Book New Appointment'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background3.png',
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress header — نفس نمط شاشة اختيار نوع الزيارة، بس
                    // الخطوة هون 2 من 3.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Consultation Details'.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Step 2 of 3'.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 2 / 3),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: colors.primary.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    FadeSlideIn(
                      child: Text(
                        'What would you like to consult the doctor about?'.tr(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 60),
                      child: Text(
                        'Describe your symptoms or concern in your own words.'
                            .tr(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withOpacity(0.65),
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    FadeSlideIn(
                      delay: const Duration(milliseconds: 130),
                      child: AssistantPromptCard(
                        hasChatSummary: _chatSummary != null,
                        onStartChat: _startChat,
                        onUseSummary: _useChatSummary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // فاصل "or" حقيقي بدل نص عادي - بيفصل بصرياً بين
                    // مسار "المساعد" ومسار "الكتابة يدوياً" بشكل أوضح.
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: colors.onSurface.withOpacity(0.15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Or write it yourself'.tr(),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface.withOpacity(0.55),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: colors.onSurface.withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 250),
                      child: AppTextField(
                        controller: _reasonController,
                        hint:
                            'e.g. I have pain in my lower right molar for 3 days'
                                .tr(),
                        maxLines: 6,
                      ),
                    ),

                    const SizedBox(height: 28),

                    FadeSlideIn(
                      delay: const Duration(milliseconds: 300),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _reasonController,
                        builder: (context, value, _) {
                          final canContinue = value.text.trim().isNotEmpty;
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: canContinue
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectDateTimePage(),
                                        ),
                                      );
                                    }
                                  : null,
                              // icon: const Icon(
                              //   Icons.arrow_forward,
                              //   size: 18,
                              //   color: Colors.white,
                              // ),
                              label: Text(
                                'Continue'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                disabledBackgroundColor: colors.primary
                                    .withOpacity(0.35),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
