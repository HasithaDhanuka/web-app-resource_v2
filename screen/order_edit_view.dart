import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/firebase/firebase_userOrder.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/model/user_order.dart';
import 'package:web_app/widgets/order_item_picker_sheet.dart';

class OrderEditScreen extends StatefulWidget {
  const OrderEditScreen({super.key, required this.order});

  final UserOrder order;

  @override
  State<OrderEditScreen> createState() => _OrderEditScreenState();
}

class _OrderEditScreenState extends State<OrderEditScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _addressController;
  late final TextEditingController _deliveryChargeController;
  late final List<_EditableOrderLine> _orderLines;
  final _customerFormKey = GlobalKey<FormState>();
  int _selectedTab = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _nameController = TextEditingController(text: widget.order.userName);
    _phoneController =
        TextEditingController(text: widget.order.userPhoneNumber.toString());
    _postalCodeController =
        TextEditingController(text: widget.order.userPostalCode.toString());
    _addressController =
        TextEditingController(text: widget.order.userAddruss);
    _deliveryChargeController =
        TextEditingController(text: widget.order.deliveryCharge.toString());

    // The stored order repeats one FoodItem per purchased unit. Group matching
    // products here so the editor can show one row with an adjustable quantity.
    final linesByProduct = <String, _EditableOrderLine>{};
    for (final item in widget.order.userOrders) {
      final productKey = _productKey(item);
      final existingLine = linesByProduct[productKey];
      if (existingLine == null) {
        linesByProduct[productKey] = _EditableOrderLine(item: item);
      } else {
        existingLine.quantity++;
      }
    }
    _orderLines = linesByProduct.values.toList();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _addressController.dispose();
    _deliveryChargeController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (_customerFormKey.currentState?.validate() != true) return;

    // Save customer and delivery-charge fields in place, then keep the editor open.
    setState(() => _isSaving = true);
    final saved = await updateOrderCustomerDetails(
      orderID: widget.order.userid,
      userName: _nameController.text.trim(),
      userPhoneNumber: int.parse(_phoneController.text.trim()),
      userPostalCode: int.parse(_postalCodeController.text.trim()),
      userAddress: _addressController.text.trim(),
      deliveryCharge: int.parse(_deliveryChargeController.text.trim()),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (saved) {
      _showMessage('Customer and delivery details saved.');
    } else {
      _showMessage('Customer and delivery details could not be saved.');
    }
  }

  Future<void> _saveOrder() async {
    if (_orderLines.isEmpty) {
      _showMessage('Keep at least one item in the order.');
      return;
    }

    setState(() => _isSaving = true);
    // Firestore stores each purchased unit as a separate FoodItem, so expand
    // the editor's quantity rows back into that format before saving.
    final updatedItems = <FoodItem>[];
    for (final line in _orderLines) {
      for (var copy = 0; copy < line.quantity; copy++) {
        updatedItems.add(line.item);
      }
    }
    final saved = await updateOrderItems(
      orderID: widget.order.userid,
      orders: updatedItems,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (saved) {
      _showMessage('Order information saved.');
    } else {
      _showMessage('Order information could not be saved.');
    }
  }

  Future<void> _addItemFromCatalog() async {
    // The picker reports selections through a callback and stays open, allowing
    // staff to add several products before returning to this screen.
    await showOrderItemPickerSheet(
      context,
      onItemSelected: _addSelectedItem,
    );
  }

  void _addSelectedItem(FoodItem selectedItem) {
    if (!mounted) return;

    // Increase the existing row for the same catalog product; otherwise add a
    // new row so products from different catalog collections remain distinct.
    final selectedKey = _productKey(selectedItem);
    final existingLineIndex =
        _orderLines.indexWhere((line) => _productKey(line.item) == selectedKey);

    setState(() {
      if (existingLineIndex >= 0) {
        _orderLines[existingLineIndex].quantity++;
      } else {
        _orderLines.add(_EditableOrderLine(item: selectedItem));
      }
    });
  }

  String _productKey(FoodItem item) {
    // Include collection and price to avoid merging unrelated products or
    // separate price snapshots; older items without IDs use their visible data.
    final collectionPath = item.collectionPath ?? '';
    if (item.id.isNotEmpty) {
      return '$collectionPath|${item.id}|${item.itemPrice}';
    }
    return '$collectionPath|${item.itemName}|${item.itemPrice}|${item.itemUrl}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleTabChange() {
    if (_selectedTab != _tabController.index) {
      setState(() => _selectedTab = _tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCustomerTab = _selectedTab == 0;

    return Scaffold(
      backgroundColor: MyColor.myBlack,
      appBar: AppBar(
        backgroundColor: MyColor.myBlack,
        foregroundColor: MyColor.myWhite,
        title: const Text('Order Edit'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: MyColor.myOrange.withOpacity(0.45), height: 1),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          // Keep customer details and order items in separate swipeable tabs.
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCustomerInformation(),
              _buildOrderInformation(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      // Back exits the editor; Save only writes data and stays here.
                      onPressed:
                          _isSaving ? null : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyColor.myOrange,
                        side: BorderSide(color: MyColor.myOrange),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : (isCustomerTab ? _saveCustomer : _saveOrder),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(isCustomerTab ? 'Save Customer' : 'Save Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.myRed,
                        foregroundColor: MyColor.onPrimary,
                        
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: MyColor.myBlack,
              child: TabBar(
                controller: _tabController,
                indicatorColor: MyColor.myRed,
                labelColor: MyColor.myRed,
                unselectedLabelColor: MyColor.myWhite70,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.person),
                    text: 'Update Customer Information',
                  ),
                  Tab(
                    icon: Icon(Icons.receipt_long),
                    text: 'Update Order Information',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInformation() {
    return Form(
      key: _customerFormKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _editField(
            controller: _nameController,
            label: 'Customer Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _editField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            digitsOnly: true,
          ),
          const SizedBox(height: 16),
          _editField(
            controller: _postalCodeController,
            label: 'Postal Code',
            icon: Icons.markunread_mailbox_outlined,
            keyboardType: TextInputType.number,
            digitsOnly: true,
          ),
          const SizedBox(height: 16),
          _editField(
            controller: _addressController,
            label: 'Address',
            icon: Icons.location_on_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          // Store the fee per order so it can be changed from the former fixed rate.
          _editField(
            controller: _deliveryChargeController,
            label: 'Delivery Charges',
            icon: Icons.local_shipping_outlined,
            keyboardType: TextInputType.number,
            digitsOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInformation() {
    // Show the item subtotal and add the saved fee for the final order total.
    final itemSubtotal = _orderLines.fold<int>(
      0,
      (sum, line) => sum + line.item.itemPrice * line.quantity,
    );
    final deliveryCharge = int.tryParse(_deliveryChargeController.text) ?? 0;
    final total = itemSubtotal + deliveryCharge;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: _isSaving ? null : _addItemFromCatalog,
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
            style: OutlinedButton.styleFrom(
              foregroundColor: MyColor.myWhite,
              side: BorderSide(color: MyColor.myGreen),
            ),
          ),
        ),
        if (_orderLines.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Center(
              child: Text(
                'There are no items in this order. Add an item to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: MyColor.myWhite),
              ),
            ),
          ),
        ...List<Widget>.generate(_orderLines.length, (index) {
          final line = _orderLines[index];
          final item = line.item;
          return Card(
            color: MyColor.myWhite.withOpacity(0.06),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  _buildItemThumbnail(item.itemUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemName,
                          style: TextStyle(
                            color: MyColor.myWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '¥${item.itemPrice} each',
                          style: const TextStyle(color: MyColor.myWhite70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: line.quantity > 1
                        ? () => setState(() => line.quantity--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: MyColor.myOrange,
                  ),
                  Text(
                    '${line.quantity}',
                    style: TextStyle(color: MyColor.myWhite, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () => setState(() => line.quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: MyColor.myGreen,
                  ),
                  IconButton(
                    onPressed: () => setState(() => _orderLines.removeAt(index)),
                    icon: const Icon(Icons.delete_outline),
                    color: MyColor.myRed,
                    tooltip: 'Remove item',
                  ),
                ],
              ),
            ),
          );
        }),
        if (_orderLines.isNotEmpty) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Items: ¥$itemSubtotal',
                    style: const TextStyle(color: MyColor.myWhite70)),
                Text('Delivery Charges: ¥$deliveryCharge',
                    style: const TextStyle(color: MyColor.myWhite70)),
                Text(
                  'Total: ¥$total',
                  style: TextStyle(
                    color: MyColor.myWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildItemThumbnail(String imageUrl) {
    // Show the catalog image when available and a food icon if it is missing
    // or cannot be loaded.
    final fallback = Container(
      width: 68,
      height: 68,
      color: MyColor.myWhite12,
      alignment: Alignment.center,
      child: Icon(Icons.restaurant, color: MyColor.myOrange, size: 30),
    );

    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: fallback,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: 68,
        height: 68,
        fit: BoxFit.cover,
        // Fall back to an HTML image when browser byte access is blocked.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (context, error, stackTrace) => fallback,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 68,
            height: 68,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: MyColor.myOrange,
                value: loadingProgress.expectedTotalBytes == null
                    ? null
                    : loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool digitsOnly = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: TextStyle(color: MyColor.myWhite),
      cursorColor: MyColor.myRed,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: MyColor.myWhite70),
        prefixIcon: Icon(icon, color: MyColor.myOrange),
        filled: true,
        fillColor: MyColor.myWhite.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColor.myOrange.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColor.myRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColor.myRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColor.myRed, width: 2),
        ),
      ),
    );
  }
}

class _EditableOrderLine {
  _EditableOrderLine({required this.item, this.quantity = 1});

  final FoodItem item;
  int quantity;
}
