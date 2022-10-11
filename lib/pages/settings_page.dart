import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../utils/constants.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Consumer<OrderProvider>(
            builder: (context, provider, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Settings',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const Divider(
                      height: 1.5,
                      color: Colors.black,
                    ),
                    Text(
                        'Delivery Charge: $currencySymbol ${provider.orderConstantsModel.deliveryCharge}'),
                    Text('Discount: ${provider.orderConstantsModel.discount}%'),
                    Text('VAT: ${provider.orderConstantsModel.vat}%'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
