import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class MyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
          _buildSectionCard(
          title: 'General Information',
          content: Column(
            children: [
              _buildInfoRow('Client ID', '1'),
              _buildInfoRow('Client Name', 'Crisprays Eportal'),
              _buildInfoRow('User Name', 'Suresh'),
              _buildInfoRow('Full Name', 'Suresh'),
              _buildInfoRow('Position', 'NA'),
            ],
          ),
          ),
            SizedBox(height: 16),
            _buildSectionCard(
              title: 'Role Assignments',
              content: Column(
                children: [
                  _buildRoleAssignmentTable(),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              title: 'Contact Information',
              content: Column(
                children: [
                  _buildInfoRow('Email', 'Suresh@crisprsys.net'),
                  _buildInfoRow('Phone', '9963023494'),
                ],
              ),
            ),

            SizedBox(height: 16),
            _buildSectionCard(
              title: 'Other Information',
              content: Column(
                children: [
                  _buildInfoRow('Time Zone', 'India Standard Time'),
                  _buildInfoRow('Date Format', 'dd/MM/yyyy HH:mm:ss'),
                  _buildInfoRow('Number Format', 'ZZZ,ZZZ,ZZZ.DDDD'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  // Handle reset pin action
                  print('Reset PIN tapped');
                },
                child: Text(
                  'RESET PIN',
                  style: TextStyle(
                    color: ColorConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            _buildProfileCard(),
            SizedBox(height: 20),
            _buildCheckInCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: content,
          ),
        ),
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }


  Widget _buildRoleAssignmentTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey),
        ),
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            children: [
              _buildTableCell('Role', isHeader: true),
              _buildTableCell('ValidFrom', isHeader: true),
              _buildTableCell('ValidTo', isHeader: true),
            ],
          ),
          TableRow(
            children: [
              _buildTableCell('CALL - Crisprsys ALL'),
              _buildTableCell('31/12/2019'),
              _buildTableCell('30/12/2099'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'CheckIn Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Divider(thickness: 1, height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Partner Object', '1007'),
                      _buildInfoRow('Partner Type', 'Employee'),
                      _buildInfoRow('Partner Name', 'Norah\nNarakuduru'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CheckIn Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(thickness: 1, height: 24),
            _buildInfoRow1('Check Type', 'Check In'),
            _buildInfoRow1('CheckIn Date', '06/02/2025'),
            _buildInfoRow1('CheckIn Time', '10:41:00'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow1(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
