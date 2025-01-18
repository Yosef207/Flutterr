import 'package:flutter/material.dart';

void main() {
  runApp(const BankApp());
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BankHomePage(),
    );
  }
}

class BankHomePage extends StatefulWidget {
  const BankHomePage({super.key});

  @override
  _BankHomePageState createState() => _BankHomePageState();
}

class _BankHomePageState extends State<BankHomePage> {
  final Map<String, double> accounts = {};
  final List<String> archives = [];
  String accountName = '';
  double amount = 0;
  String message = '';
  String toAccountName = '';
  String guarantor = '';

  // Function to create an account
  Future<void> createAccount() async {
    if (accounts.containsKey(accountName) || accountName.isEmpty) {
      setState(() {
        message =
            'There is an existing account with this name or the name is empty.';
      });
      return;
    }
    accounts[accountName] = 5;
    await deposit(5);
    setState(() {
      message =
          'Account created successfully. Initial deposit of 5 dollars has been made.';
    });
    archives.add('Account created: $accountName with 5 dollars');
  }

  // Function to deposit money
  Future<void> deposit(double amount) async {
    if (!accounts.containsKey(accountName)) {
      setState(() {
        message = 'No account found';
      });
      return;
    }
    accounts[accountName] = accounts[accountName]! + amount;
    setState(() {
      message = '${amount} deposited successfully.';
    });
    archives.add('Deposited ${amount} to $accountName');
  }

  // Function to withdraw money
  Future<void> withdraw() async {
    if (!accounts.containsKey(accountName)) {
      setState(() {
        message = 'No account found';
      });
      return;
    }
    if (accounts[accountName]! < amount) {
      setState(() {
        message = 'There is not enough balance';
      });
      return;
    }
    accounts[accountName] = accounts[accountName]! - amount;
    setState(() {
      message = '${amount} withdrawn successfully.';
    });
    archives.add('Withdrew ${amount} from $accountName');
  }

  // Function to transfer money
  Future<void> transfer() async {
    if (!accounts.containsKey(accountName) ||
        !accounts.containsKey(toAccountName)) {
      setState(() {
        message = 'Invalid account names';
      });
      return;
    }
    if (accounts[accountName]! < amount) {
      setState(() {
        message = 'There is not enough balance';
      });
      return;
    }
    accounts[accountName] = accounts[accountName]! - amount;
    accounts[toAccountName] = accounts[toAccountName]! + amount;

    setState(() {
      message = '${amount} transferred to $toAccountName successfully.';
    });
    archives.add('Transferred ${amount} from $accountName to $toAccountName');
  }

  // Function to request a loan
  Future<void> requestLoan() async {
    if (guarantor.isEmpty) {
      setState(() {
        message = 'Guarantor information is required.';
      });
      return;
    }
    setState(() {
      message = 'Loan granted to $accountName with guarantor $guarantor';
    });
    archives.add('Loan granted to $accountName with guarantor $guarantor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank System'),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.home,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Account name'),
              onChanged: (value) {
                accountName = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Transfer to (Account name)'),
              onChanged: (value) {
                toAccountName = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Guarantor'),
              onChanged: (value) {
                guarantor = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: createAccount,
                  child: const Text('Create Account'),
                ),
                ElevatedButton(
                  onPressed: () => deposit(amount),
                  child: const Text('Deposit'),
                ),
                ElevatedButton(
                  onPressed: withdraw,
                  child: const Text('Withdraw'),
                ),
                ElevatedButton(
                  onPressed: transfer,
                  child: const Text('Transfer'),
                ),
                ElevatedButton(
                  onPressed: requestLoan,
                  child: const Text('Request Loan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: archives.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(archives[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
