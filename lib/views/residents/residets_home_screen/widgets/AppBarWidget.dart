import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/residents/residets_profile_screen/resident_profile_screen.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Residents residents;

  const AppBarWidget({
    super.key,
    required this.residents,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Welcome, ${residents.name}',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Navigate to the profile edit page when the avatar is clicked
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditPage(resident: residents),
              ),
            );
          },
          child: CircleAvatar(
            radius: 20,
            backgroundImage: residents.profilePictureUrl.isNotEmpty
                ? NetworkImage(residents.profilePictureUrl)
                : const AssetImage('assets/images/Recycling-bro.png')
                    as ImageProvider,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
