import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const _sections = {
    'Help & information': ['Help', 'Track order', 'Delivery & returns', 'Sitemap'],
    'About': ['About us', 'Corporate responsibility', 'Careers at Hair Haven'],
    'More from Hair Haven': ['Hair Haven App', 'Gift vouchers', 'Black Friday'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // Socials (swap for brand icons, e.g. font_awesome_flutter)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.facebook, size: 20, color: Color(0xFF1877F2)),
            SizedBox(width: 12),
            Icon(Icons.alternate_email, size: 20, color: Color(0xFF1DA1F2)),
            SizedBox(width: 12),
            Icon(Icons.business_center, size: 20, color: Color(0xFF0A66C2)),
            SizedBox(width: 12),
            Icon(Icons.push_pin, size: 20, color: Color(0xFFE60023)),
            SizedBox(width: 12),
            Icon(Icons.camera_alt_outlined, size: 20, color: Color(0xFFC13584)),
          ],
        ),

        const SizedBox(height: 12),

        // Payment methods (swap for real logos)
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: ['Visa', 'Mastercard', 'PayPal', 'Apple Pay', 'G Pay']
              .map(
                (p) => Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(p, style: const TextStyle(fontSize: 8)),
            ),
          )
              .toList(),
        ),

        const SizedBox(height: 20),

        // Dark footer
        Container(
          width: double.infinity,
          color: const Color(0xFF654039),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.white24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.eco_outlined, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Hair Haven',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.star_border, color: Colors.white54, size: 12),
                    Icon(Icons.star_border, color: Colors.white54, size: 12),
                    Icon(Icons.star_border, color: Colors.white54, size: 12),
                  ],
                ),
                const SizedBox(height: 14),

                for (final entry in _sections.entries)
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: entry.value
                        .map(
                          (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                const Divider(height: 1),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'SHOPPING FROM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "You're in 🇳🇬  CHANGE",
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'DOWNLOAD THE APP',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}