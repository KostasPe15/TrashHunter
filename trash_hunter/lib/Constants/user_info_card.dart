import 'package:flutter/material.dart';
import 'package:trash_hunter/Constants/TextsStyles/body_texts.dart';

class UserInfoCard extends StatelessWidget {
  final String fullName;
  final String email;

  const UserInfoCard({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            _buildProfileItem(Icons.person, "Full Name", fullName),
            const Divider(),
            _buildProfileItem(Icons.email, "Email", email),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyTexts(
                text: label,
                type: BodyTextType.s,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              BodyTexts(
                text: value,
                type: BodyTextType.l,
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }
}
