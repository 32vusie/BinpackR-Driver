import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/views/residents/residets_support_screen/functions/support_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedSupportType = 'App Support';

  static const List<String> supportOptions = [
    'App Support',
    'Sales',
    'Dispatch',
    'Ward',
    'Business',
    'Report Behaviour',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('You must be logged in to submit a support request.')),
      );
      return;
    }

    try {
      await SupportService.createSupportTicket(
        userId: userId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        message: _messageController.text.trim(),
        relatedSupport: _selectedSupportType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your message has been sent!')),
        );
      }

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() {
        _selectedSupportType = 'App Support';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to send message. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Form Section
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecorations.name(label: 'Name'),
                    validator: InputValidationUtil.validateName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecorations.email(label: 'Email'),
                    validator: InputValidationUtil.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecorations.paragraph(label: 'Message'),
                    maxLines: 4,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your message'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Support related to:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedSupportType,
                    items: supportOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSupportType = newValue!;
                      });
                    },
                    decoration: inputDecorationStyle.copyWith(
                        labelText: 'Select Support Type'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: elevatedButtonStyle,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Support Tickets Section
            const Text('Your Support Tickets:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (userId != null)
              StreamBuilder<QuerySnapshot>(
                stream: SupportService.getSupportTickets(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No support tickets found.');
                  }

                  final tickets = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return SupportTicketCard(ticket: ticket);
                    },
                  );
                },
              )
            else
              const Text(
                  'You need to be logged in to view your support tickets.'),
          ],
        ),
      ),
    );
  }
}

class SupportTicketCard extends StatelessWidget {
  final QueryDocumentSnapshot ticket;

  const SupportTicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final ticketData = ticket.data() as Map<String, dynamic>;
    debugPrint("Rendering SupportTicketCard with data: $ticketData");

    final isClosed = ticketData['status'] == 'closed';
    final assignedTo = ticketData['assignedTo'] ?? 'Unassigned';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(ticketData['relatedSupport'] ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${isClosed ? 'Closed' : 'Open'}'),
            Text('Assigned To: $assignedTo'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportTicketDetails(ticket: ticketData),
            ),
          );
        },
      ),
    );
  }
}

class SupportTicketDetails extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const SupportTicketDetails({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isClosed = ticket['status'] == 'closed';
    final assignedTo = ticket['assignedTo'] ?? 'Unassigned';

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Support Type: ${ticket['relatedSupport']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: ${isClosed ? 'Closed' : 'Open'}'),
            const SizedBox(height: 8),
            Text('Assigned To: $assignedTo'),
            const SizedBox(height: 8),
            const Text('Message:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(ticket['message'] ?? 'No message provided.'),
          ],
        ),
      ),
    );
  }
}
