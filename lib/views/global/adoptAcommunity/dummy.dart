import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/global/payment_method/PaymentMethodScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdoptCommunityScreen extends StatefulWidget {
  const AdoptCommunityScreen({super.key});

  @override
  _AdoptCommunityScreenState createState() => _AdoptCommunityScreenState();
}

class _AdoptCommunityScreenState extends State<AdoptCommunityScreen> {
  String? selectedCommunity = "Meadowlands";
  String? _selectedPaymentMethodId;
  double contributions = 0.0;
  List<Map<String, dynamic>> communities = [];
  final TextEditingController eftRefController = TextEditingController();

  final Map<String, dynamic> communityDetails = {
    "Ward": "41 & 42",
    "Households": 15378,
    "Population": 53590,
    "WasteGenerated": "7016.21 tonnes per year",
    "IllegalDumpsites": 13,
    "Activities": ["Events", "Meetings"],
  };
  void _openPaymentMethodScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          onSelect: (String paymentMethodId, String cardHolderName,
              String last4Digits) {
            setState(() {
              _selectedPaymentMethodId = '$cardHolderName - $last4Digits';
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('communities').get();
      setState(() {
        communities = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'communityID': data['communityID'],
            'name': data['name'],
            'description': data['description'],
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching communities: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveReceipt(
      String reference, String communityName, double amount) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('receipts')
          .add({
        'reference': reference,
        'communityName': communityName,
        'amount': amount,
        'date': DateTime.now(),
      });
    }
  }

  void _showReceiptModal(
      String reference, String communityName, double amount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.receipt, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text("Payment Receipt",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailRow("Reference", reference),
              _buildDetailRow("Community", communityName),
              _buildDetailRow("Amount", "R$amount"),
              _buildDetailRow("Date", DateTime.now().toString()),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Please keep this receipt for your records.",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void showDonationDialog() {
    double donationAmount = 10.0;
    String selectedPaymentMethod = "Card Payment";
    String? selectedCommunityID = communities.isNotEmpty
        ? communities.firstWhere((c) => c['name'] == "Meadowlands",
            orElse: () => communities.first)['communityID']
        : null;

    String? reference = "ADOPT-${DateTime.now().millisecondsSinceEpoch}";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Donate to a Community"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCommunityID,
                    decoration: const InputDecoration(
                      labelText: "Select Community",
                      border: OutlineInputBorder(),
                    ),
                    items: communities
                        .map((community) => DropdownMenuItem<String>(
                              value: community['communityID'],
                              child: Text(community['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCommunityID = value;
                        selectedCommunity = communities.firstWhere(
                            (c) => c['communityID'] == value)['name'];
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount (R10 and up)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      donationAmount = double.tryParse(value) ?? 10.0;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    decoration: const InputDecoration(
                      labelText: "Payment Method",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Card Payment", "EFT"]
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  if (selectedPaymentMethod == "Card Payment")
                    const SizedBox(height: 16),
                  if (selectedPaymentMethod == "Card Payment")
                    GestureDetector(
                      onTap: _openPaymentMethodScreen,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.payment, color: primaryColor),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                _selectedPaymentMethodId ??
                                    "Select Payment Method",
                                style: const TextStyle(color: primaryColor),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                color: primaryColor, size: 16),
                          ],
                        ),
                      ),
                    ),
                  if (selectedPaymentMethod == "EFT") ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Banking Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text("Account Name: BinpackR"),
                    const Text("Account Number: 123456789"),
                    const Text("Reference: ADOPT-12345"),
                    const SizedBox(height: 16),
                    TextField(
                      controller: eftRefController,
                      decoration: const InputDecoration(
                        labelText: "Enter EFT Payment Reference",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (donationAmount >= 10 &&
                        (selectedCommunityID?.isNotEmpty ?? false)) {
                      if (selectedPaymentMethod == "PayPal" &&
                          _selectedPaymentMethodId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a payment method."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (selectedPaymentMethod == "EFT" &&
                          eftRefController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Please enter a valid EFT reference."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      _saveReceipt(
                          reference, selectedCommunity!, donationAmount);
                      _showReceiptModal(
                          reference, selectedCommunity!, donationAmount);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please enter a valid amount and select a community."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Donate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adopt a Community"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Adopt a Community",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Support your community by contributing towards waste management and environmental activities. Select a community to learn more and adopt.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    "Community Details ($selectedCommunity)",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Ward: ${communityDetails['Ward']}"),
                  Text(
                      "Number of Households: ${communityDetails['Households']}"),
                  Text("Population: ${communityDetails['Population']}"),
                  Text(
                      "Waste Generated: ${communityDetails['WasteGenerated']}"),
                  Text(
                      "Illegal Dumpsites: ${communityDetails['IllegalDumpsites']}"),
                  const SizedBox(height: 16),
                  const Text(
                    "Adopt A Community Statistics",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Contributions: R${contributions.toStringAsFixed(2)}"),
                  const Text("Waste Diverted Per Month: 0 tonnes"),
                  const SizedBox(height: 8),
                  const Text(
                    "Current Environmental Activities:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...communityDetails['Activities'].map<Widget>(
                    (activity) => Text("- $activity"),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReceiptListScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              primaryColor, // Use your utility's primary color
                          side:
                              const BorderSide(color: primaryColor, width: 2.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                        ),
                        child: const Text(
                          "View Receipts",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: showDonationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryColor, // Replace with your utility's primary color
                          foregroundColor: Colors.white,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                        ),
                        child: const Text("Adopt"),
                      ),
                    ],
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

class ReceiptListScreen extends StatelessWidget {
  const ReceiptListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('receipts')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No receipts available.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          final receipts = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  title: Text(
                    "Reference: ${receipt['reference']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Community: ${receipt['communityName']}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Amount: R${receipt['amount']}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Date: ${receipt['date'].toDate()}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () => _viewReceiptDetails(context, receipt),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _viewReceiptDetails(BuildContext context, Map<String, dynamic> receipt) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.receipt, color: primaryColor, size: 24),
              SizedBox(width: 8),
              Text("Receipt Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailRow("Reference", receipt['reference']),
              _buildDetailRow("Community", receipt['communityName']),
              _buildDetailRow("Amount", "R${receipt['amount']}"),
              _buildDetailRow("Date", receipt['date'].toDate().toString()),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Use utility primary color
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                ),
                child:
                    const Text("Close", style: TextStyle(color: Colors.white))),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
