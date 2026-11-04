import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/app_badge.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';

class LandingScreen extends StatelessWidget {
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const LandingScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isTablet = MediaQuery.of(context).size.width < 1024;
    final authService = context.watch<AuthService>();
    final isLoggedIn = authService.isLoggedIn;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Shimmer Announcement Banner
          _buildAnnouncementBanner(context),

          // Main Constrained Container for Sections
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppTokens.space3 : AppTokens.space6,
              vertical: AppTokens.space4,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Hero Section
                  _buildHeroSection(context, isMobile, isLoggedIn),

                  const SizedBox(height: AppTokens.space7),

                  // 3. How It Works Pipeline
                  _buildHowItWorksSection(context, isMobile),

                  const SizedBox(height: AppTokens.space7),

                  // 4. Feature Pillars Grid
                  _buildFeaturePillars(context, isMobile),

                  const SizedBox(height: AppTokens.space7),

                  // 5. Interactive Demo Banner
                  _buildInteractiveDemoBanner(context, isMobile),

                  const SizedBox(height: AppTokens.space7),

                  // 6. Research & SDGs Impact
                  _buildResearchAndImpactSection(context, isMobile, isTablet),

                  const SizedBox(height: AppTokens.space7),

                  // 7. Final CTA Section
                  _buildFinalCtaSection(context, isMobile, isLoggedIn),

                  const SizedBox(height: AppTokens.space7),

                  // 8. Footer Section
                  _buildFooter(context, isMobile),

                  const SizedBox(height: AppTokens.space5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Announcement Banner
  Widget _buildAnnouncementBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: AppTokens.space4),
      decoration: BoxDecoration(
        color: AppTokens.colorAccentPrimary.withValues(alpha: 0.08),
        border: const Border(
          bottom: BorderSide(color: AppTokens.colorBorderDefault, width: 1.0),
        ),
      ),
      child: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          spacing: AppTokens.space2,
          runSpacing: 4,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTokens.colorAccentPrimary,
                borderRadius: AppTokens.borderRadiusPill,
              ),
              child: const Text(
                'RESEARCH INITIATIVE',
                style: TextStyle(
                  color: AppTokens.colorTextInverse,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Text(
              'A KSCST Sponsored Project — AI for Inclusive Education & Accessible Reading',
              style: TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeSm,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: AppTokens.colorAccentPrimary,
            ),
          ],
        ),
      ),
    );
  }

  // 2. Hero Section
  Widget _buildHeroSection(BuildContext context, bool isMobile, bool isLoggedIn) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showTwoColumns = constraints.maxWidth >= 860;

        return showTwoColumns
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildHeroTextContent(context, isMobile, isLoggedIn),
                  ),
                  const SizedBox(width: AppTokens.space6),
                  Expanded(
                    flex: 5,
                    child: _buildHeroMockup(context),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroTextContent(context, isMobile, isLoggedIn),
                  const SizedBox(height: AppTokens.space6),
                  Center(child: _buildHeroMockup(context)),
                ],
              );
      },
    );
  }

  Widget _buildHeroTextContent(BuildContext context, bool isMobile, bool isLoggedIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTokens.colorAccentPrimary.withValues(alpha: 0.12),
            borderRadius: AppTokens.borderRadiusPill,
            border: Border.all(
              color: AppTokens.colorAccentPrimary.withValues(alpha: 0.35),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 14, color: AppTokens.colorAccentPrimary),
              SizedBox(width: 6),
              Text(
                'ASSISTIVE READING PLATFORM',
                style: TextStyle(
                  color: AppTokens.colorAccentPrimary,
                  fontSize: AppTokens.fontSizeXs,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTokens.space4),

        // Main Headline
        Text(
          'Read without barriers.\nPowered by AI.',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: isMobile ? AppTokens.fontSize3xl : AppTokens.fontSize4xl,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppTokens.space3),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: const Text(
            'LexiLens transforms captured photos of printed text into a calm, fully adjustable visual and auditory experience tailored for dyslexic readers. Built for students, parents, and educators.',
            style: TextStyle(
              color: AppTokens.colorTextSecondary,
              fontSize: AppTokens.fontSizeMd,
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: AppTokens.space5),

        // CTA Buttons
        Wrap(
          spacing: AppTokens.space3,
          runSpacing: AppTokens.space3,
          children: [
            AppButton(
              text: 'Start exploring',
              icon: Icons.arrow_forward_rounded,
              variant: AppButtonVariant.primary,
              onPressed: () => onNavigate('/app'),
              semanticLabel: 'Start exploring Lexi Lens reader',
            ),
            if (!isLoggedIn) ...[
              AppButton(
                text: 'Sign in',
                icon: Icons.login_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('/login'),
                semanticLabel: 'Sign in to existing account',
              ),
              AppButton(
                text: 'Create account',
                icon: Icons.person_add_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('/signup'),
                semanticLabel: 'Create a new free account',
              ),
            ] else ...[
              AppButton(
                text: 'Go to Library',
                icon: Icons.bookmarks_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('/library'),
                semanticLabel: 'View your saved documents',
              ),
            ],
          ],
        ),

        const SizedBox(height: AppTokens.space4),

        // Reassurance badges
        const Wrap(
          spacing: AppTokens.space4,
          runSpacing: AppTokens.space2,
          children: [
            _ReassuranceItem(text: 'Open Source'),
            _ReassuranceItem(text: 'Offline-Ready Pipeline'),
            _ReassuranceItem(text: 'Zero Cloud Tracking'),
          ],
        ),
      ],
    );
  }

  // Hero Preview Mockup
  Widget _buildHeroMockup(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(AppTokens.space4),
      decoration: BoxDecoration(
        color: AppTokens.colorBgSurface,
        borderRadius: AppTokens.borderRadiusLg,
        border: Border.all(color: AppTokens.colorBorderDefault, width: 1.5),
        boxShadow: AppTokens.shadow3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Device Screen Top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTokens.colorAccentPrimary.withValues(alpha: 0.1),
                  borderRadius: AppTokens.borderRadiusPill,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.camera_rounded, size: 12, color: AppTokens.colorAccentPrimary),
                    SizedBox(width: 4),
                    Text(
                      'OCR ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.colorAccentPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Page 14 · Biology',
                style: TextStyle(
                  fontSize: AppTokens.fontSizeXs,
                  color: AppTokens.colorTextSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTokens.space3),

          // Raw Extracted Scan Card
          Container(
            padding: const EdgeInsets.all(AppTokens.space3),
            decoration: BoxDecoration(
              color: AppTokens.colorBgSurfaceMuted,
              borderRadius: AppTokens.borderRadiusSm,
              border: Border.all(color: AppTokens.colorBorderDefault),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Original Complex Print:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.colorTextSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Photosynthesis represents the biological synthesis through which phototrophic autotrophs convert solar radiation...',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppTokens.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTokens.space3),

          // Arrow Down Icon
          const Center(
            child: Icon(
              Icons.arrow_downward_rounded,
              size: 20,
              color: AppTokens.colorAccentWarm,
            ),
          ),

          const SizedBox(height: AppTokens.space3),

          // Dyslexia Formatted Card with Active TTS Highlight
          Container(
            padding: const EdgeInsets.all(AppTokens.space4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6D9), // Calm Cream overlay
              borderRadius: AppTokens.borderRadiusMd,
              border: Border.all(color: AppTokens.colorAccentWarm.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTokens.colorAccentWarm.withValues(alpha: 0.2),
                        borderRadius: AppTokens.borderRadiusPill,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded, size: 12, color: AppTokens.colorAccentWarm),
                          SizedBox(width: 4),
                          Text(
                            'BIMODAL SPEECH ACTIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTokens.colorAccentWarm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'OpenDyslexic 20px',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTokens.colorTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space3),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'OpenDyslexic',
                      fontSize: 16,
                      color: AppTokens.colorTextPrimary,
                      height: 1.7,
                    ),
                    children: [
                      TextSpan(text: 'Plants use '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppTokens.colorAccentWarm,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            child: Text(
                              'sunlight',
                              style: TextStyle(
                                fontFamily: 'OpenDyslexic',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTokens.colorTextInverse,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: ' to make food. Inside their leaves, green cells produce oxygen.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. How It Works Pipeline
  Widget _buildHowItWorksSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                '// HOW IT WORKS',
                style: TextStyle(
                  color: AppTokens.colorAccentPrimary,
                  fontSize: AppTokens.fontSizeXs,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: AppTokens.space2),
              Text(
                'From printed page to effortless comprehension',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTokens.colorTextPrimary,
                  fontSize: AppTokens.fontSize2xl,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppTokens.space2),
              Text(
                'A unified three-stage pipeline engineered to eliminate cognitive fatigue and visual crowding.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeMd,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTokens.space6),

        LayoutBuilder(
          builder: (context, constraints) {
            final isRow = constraints.maxWidth >= 768;

            final stages = [
              const _StageCard(
                stepNumber: '01',
                tag: '[ Scan ]',
                title: 'Optical OCR Extraction',
                description:
                    'Take a picture with your phone camera or upload an image. Advanced OCR extracts all characters cleanly.',
                icon: Icons.camera_alt_outlined,
              ),
              const _StageCard(
                stepNumber: '02',
                tag: '[ Simplify ]',
                title: 'Syntactic Clarification',
                description:
                    'Complex compound clauses are restructured into clear, direct subject-verb sentences without losing key definitions.',
                icon: Icons.auto_fix_high_rounded,
              ),
              const _StageCard(
                stepNumber: '03',
                tag: '[ Listen ]',
                title: 'Bimodal Speech Sync',
                description:
                    'Listen aloud while real-time highlighting synchronizes phonemes with visual text, reducing reading fatigue.',
                icon: Icons.record_voice_over_outlined,
              ),
            ];

            return isRow
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: stages[0]),
                      const SizedBox(width: AppTokens.space4),
                      Expanded(child: stages[1]),
                      const SizedBox(width: AppTokens.space4),
                      Expanded(child: stages[2]),
                    ],
                  )
                : Column(
                    children: [
                      stages[0],
                      const SizedBox(height: AppTokens.space3),
                      stages[1],
                      const SizedBox(height: AppTokens.space3),
                      stages[2],
                    ],
                  );
          },
        ),
      ],
    );
  }

  // 4. Feature Pillars Grid
  Widget _buildFeaturePillars(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '// ACCESSIBLE CAPABILITIES',
          style: TextStyle(
            color: AppTokens.colorAccentPrimary,
            fontSize: AppTokens.fontSizeXs,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: AppTokens.space2),
        const Text(
          'Engineered for cognitive calm and legibility',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: AppTokens.fontSize2xl,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppTokens.space5),

        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCols = constraints.maxWidth >= 700;

            final features = [
              const _FeatureTile(
                icon: Icons.document_scanner_outlined,
                tag: '// SCAN',
                title: 'Snap & Upload Ingestion',
                description:
                    'Camera shutter captures with instant sample presets for effortless classroom and home evaluation.',
              ),
              const _FeatureTile(
                icon: Icons.format_shapes_rounded,
                tag: '// READ',
                title: 'Weighted Dyslexia Typography',
                description:
                    'OpenDyslexic and Atkinson Hyperlegible fonts with custom line spacing and letter tracking prevents visual letter flipping.',
              ),
              const _FeatureTile(
                icon: Icons.hearing_rounded,
                tag: '// LISTEN',
                title: 'Bimodal Audio Narration',
                description:
                    'Synchronized speech engine highlights active words as they are spoken, reducing working-memory load.',
              ),
              const _FeatureTile(
                icon: Icons.palette_outlined,
                tag: '// OVERLAY',
                title: 'Glare-Reducing Color Tints',
                description:
                    'Warm Ivory, Calm Cream, Soft Blue, Pastel Rose, and Muted Sage backgrounds reduce high-contrast glare.',
              ),
            ];

            return isTwoCols
                ? Wrap(
                    spacing: AppTokens.space4,
                    runSpacing: AppTokens.space4,
                    children: features
                        .map(
                          (f) => SizedBox(
                            width: (constraints.maxWidth - AppTokens.space4) / 2,
                            child: f,
                          ),
                        )
                        .toList(),
                  )
                : Column(
                    children: features
                        .map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: AppTokens.space3),
                            child: f,
                          ),
                        )
                        .toList(),
                  );
          },
        ),
      ],
    );
  }

  // 5. Interactive Demo Banner
  Widget _buildInteractiveDemoBanner(BuildContext context, bool isMobile) {
    return AppCard(
      padding: const EdgeInsets.all(AppTokens.space5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppTokens.borderRadiusMd,
          gradient: LinearGradient(
            colors: [
              AppTokens.colorBgSurfaceMuted,
              AppTokens.colorBgSurface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(AppTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppBadge(
                  text: 'INTERACTIVE SCANNER',
                  backgroundColor: Color(0xFFE6F0EB),
                  textColor: AppTokens.colorAccentPrimary,
                  borderColor: AppTokens.colorAccentPrimary,
                ),
                const Spacer(),
                Text(
                  'Instant Evaluation',
                  style: TextStyle(
                    fontSize: AppTokens.fontSizeXs,
                    color: AppTokens.colorTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space3),
            const Text(
              'Try scanning text right now in the app workspace',
              style: TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeXl,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.space2),
            const Text(
              'No account required. Jump straight into the camera snapshot or upload picker to experience bimodal reading and customized text.',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeMd,
              ),
            ),
            const SizedBox(height: AppTokens.space4),
            AppButton(
              text: 'Start exploring',
              icon: Icons.launch_rounded,
              variant: AppButtonVariant.primary,
              onPressed: () => onNavigate('/app'),
              semanticLabel: 'Start exploring reader app workspace',
            ),
          ],
        ),
      ),
    );
  }

  // 6. Research & SDGs Impact
  Widget _buildResearchAndImpactSection(BuildContext context, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '// RESEARCH-BACKED & SOCIAL IMPACT',
          style: TextStyle(
            color: AppTokens.colorAccentPrimary,
            fontSize: AppTokens.fontSizeXs,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: AppTokens.space2),
        const Text(
          'Designed to support UN Sustainable Development Goals',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: AppTokens.fontSize2xl,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppTokens.space4),

        Wrap(
          spacing: AppTokens.space3,
          runSpacing: AppTokens.space3,
          children: const [
            _SdgChip(number: 'SDG 4', label: 'Quality Inclusive Education'),
            _SdgChip(number: 'SDG 9', label: 'Industry, Innovation & AI'),
            _SdgChip(number: 'SDG 10', label: 'Reduced Inequalities'),
            _SdgChip(number: 'SDG 17', label: 'Partnerships for the Goals'),
          ],
        ),

        const SizedBox(height: AppTokens.space5),

        // Institutional Sponsorship Card
        Container(
          padding: const EdgeInsets.all(AppTokens.space4),
          decoration: BoxDecoration(
            color: AppTokens.colorBgSurface,
            borderRadius: AppTokens.borderRadiusMd,
            border: Border.all(color: AppTokens.colorBorderDefault),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTokens.colorAccentPrimary.withValues(alpha: 0.12),
                  borderRadius: AppTokens.borderRadiusSm,
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppTokens.colorAccentPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppTokens.space3),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NMAM Institute of Technology, Nitte · KSCST Karnataka',
                      style: TextStyle(
                        color: AppTokens.colorTextPrimary,
                        fontSize: AppTokens.fontSizeSm,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Project Title: LexiLens — AI-Powered Optical Text Extraction & Accessible Reading Assistance.',
                      style: TextStyle(
                        color: AppTokens.colorTextSecondary,
                        fontSize: AppTokens.fontSizeXs,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 7. Final CTA Section
  Widget _buildFinalCtaSection(BuildContext context, bool isMobile, bool isLoggedIn) {
    return AppCard(
      padding: EdgeInsets.all(isMobile ? AppTokens.space4 : AppTokens.space6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              const Text(
                '// INCLUSIVE READING FOR ALL',
                style: TextStyle(
                  color: AppTokens.colorAccentWarm,
                  fontSize: AppTokens.fontSizeXs,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: AppTokens.space2),
              const Text(
                'Ready to read without barriers?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTokens.colorTextPrimary,
                  fontSize: AppTokens.fontSize3xl,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.space3),
              const Text(
                'Experience how LexiLens transforms difficult text into crystal-clear understanding with personalized typography and synchronized audio.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeMd,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppTokens.space5),
              Wrap(
                spacing: AppTokens.space3,
                runSpacing: AppTokens.space3,
                alignment: WrapAlignment.center,
                children: [
                  AppButton(
                    text: 'Start exploring',
                    icon: Icons.rocket_launch_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: () => onNavigate('/app'),
                  ),
                  if (!isLoggedIn)
                    AppButton(
                      text: 'Create Account',
                      icon: Icons.person_add_rounded,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => onNavigate('/signup'),
                    ),
                ],
              ),
              const SizedBox(height: AppTokens.space3),
              const Text(
                'Free to use · Zero account walls · Built for all learners',
                style: TextStyle(
                  color: AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeXs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 8. Footer Section
  Widget _buildFooter(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.only(top: AppTokens.space5),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTokens.colorBorderDefault)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppTokens.space6,
            runSpacing: AppTokens.space4,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              // Col 1: Brand
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTokens.colorAccentPrimary,
                            borderRadius: AppTokens.borderRadiusSm,
                          ),
                          child: const Icon(
                            Icons.visibility_rounded,
                            color: AppTokens.colorTextInverse,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppTokens.space2),
                        const Text(
                          'Lexi Lens',
                          style: TextStyle(
                            color: AppTokens.colorTextPrimary,
                            fontSize: AppTokens.fontSizeLg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTokens.space2),
                    const Text(
                      'AI-powered assistive technology platform designed for readers with dyslexia and visual crowding challenges.',
                      style: TextStyle(
                        color: AppTokens.colorTextSecondary,
                        fontSize: AppTokens.fontSizeXs,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Col 2: Navigation Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PAGES',
                    style: TextStyle(
                      fontSize: AppTokens.fontSizeXs,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTokens.space2),
                  _FooterNavLink(label: 'Scan text', onTap: () => onNavigate('/app')),
                  _FooterNavLink(label: 'My Library', onTap: () => onNavigate('/library')),
                  _FooterNavLink(label: 'Display settings', onTap: () => onNavigate('/settings')),
                ],
              ),

              // Col 3: Authentication Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACCOUNT',
                    style: TextStyle(
                      fontSize: AppTokens.fontSizeXs,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTokens.space2),
                  _FooterNavLink(label: 'Sign in', onTap: () => onNavigate('/login')),
                  _FooterNavLink(label: 'Sign up', onTap: () => onNavigate('/signup')),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppTokens.space5),
          const Divider(color: AppTokens.colorBorderDefault),
          const SizedBox(height: AppTokens.space3),

          // Copyright
          const Center(
            child: Text(
              '© 2026 Lexi Lens · Built with care by LexiLens Team · NMAMIT Nitte & KSCST Sponsored Project',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReassuranceItem extends StatelessWidget {
  final String text;

  const _ReassuranceItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppTokens.colorStateSuccess,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppTokens.colorTextSecondary,
            fontSize: AppTokens.fontSizeXs,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  final String stepNumber;
  final String tag;
  final String title;
  final String description;
  final IconData icon;

  const _StageCard({
    required this.stepNumber,
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tag,
                style: const TextStyle(
                  color: AppTokens.colorAccentPrimary,
                  fontSize: AppTokens.fontSizeXs,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                stepNumber,
                style: const TextStyle(
                  color: AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeSm,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space3),
          Icon(icon, size: 28, color: AppTokens.colorAccentPrimary),
          const SizedBox(height: AppTokens.space2),
          Text(
            title,
            style: const TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSizeLg,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTokens.space2),
          Text(
            description,
            style: const TextStyle(
              color: AppTokens.colorTextSecondary,
              fontSize: AppTokens.fontSizeSm,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String tag;
  final String title;
  final String description;

  const _FeatureTile({
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTokens.colorAccentPrimary.withValues(alpha: 0.1),
              borderRadius: AppTokens.borderRadiusSm,
            ),
            child: Icon(icon, color: AppTokens.colorAccentPrimary, size: 22),
          ),
          const SizedBox(width: AppTokens.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag,
                  style: const TextStyle(
                    color: AppTokens.colorAccentWarm,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTokens.colorTextPrimary,
                    fontSize: AppTokens.fontSizeMd,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeXs,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SdgChip extends StatelessWidget {
  final String number;
  final String label;

  const _SdgChip({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTokens.colorBgSurface,
        borderRadius: AppTokens.borderRadiusSm,
        border: Border.all(color: AppTokens.colorBorderDefault),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTokens.colorAccentWarm,
              borderRadius: AppTokens.borderRadiusPill,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: AppTokens.colorTextInverse,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSizeXs,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterNavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTokens.colorTextSecondary,
            fontSize: AppTokens.fontSizeXs,
          ),
        ),
      ),
    );
  }
}
