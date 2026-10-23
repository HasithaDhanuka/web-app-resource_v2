import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/firebase/firebase_food.dart';
import 'package:web_app/model/food.dart';

Future<void> showOrderItemPickerSheet(
  BuildContext context, {
  required ValueChanged<FoodItem> onItemSelected,
}) async {
  // Keep the catalog in a modal sheet so a selection can update the order
  // without navigating away; the user closes the sheet when finished.
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: MyColor.myBlack,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => OrderItemPickerSheet(onItemSelected: onItemSelected),
  );
}

class OrderItemPickerSheet extends StatefulWidget {
  const OrderItemPickerSheet({
    super.key,
    required this.onItemSelected,
  });

  final ValueChanged<FoodItem> onItemSelected;

  @override
  State<OrderItemPickerSheet> createState() => _OrderItemPickerSheetState();
}

class _OrderItemPickerSheetState extends State<OrderItemPickerSheet> {
  static const _categories = [
    'Cooking Items',
    'Other Items',
    'Grains Items',
    'Powder Items',
  ];

  int _selectedCategory = 0;
  String _searchText = '';
  late Stream<List<FoodItem>> _itemsStream;

  @override
  void initState() {
    super.initState();
    _itemsStream = _streamForCategory(_selectedCategory);
  }

  Stream<List<FoodItem>> _streamForCategory(int index) {
    // Reuse the app's existing Firestore streams for each product category.
    switch (index) {
      case 0:
        return ReadCookingItems();
      case 1:
        return ReadOtherItems();
      case 2:
        return ReadGrainsItems();
      default:
        return ReadPowderItems();
    }
  }

  void _selectCategory(int index) {
    if (_selectedCategory == index) return;
    setState(() {
      _selectedCategory = index;
      _itemsStream = _streamForCategory(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.82;

    return SizedBox(
      height: sheetHeight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Item To Order',
                    style: TextStyle(
                      color: MyColor.myWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: MyColor.myWhite),
                ),
              ],
            ),
            TextField(
              onChanged: (value) => setState(() => _searchText = value.trim()),
              style: TextStyle(color: MyColor.myWhite),
              decoration: InputDecoration(
                hintText: 'Search items',
                hintStyle: const TextStyle(color: MyColor.myWhite60),
                prefixIcon: Icon(Icons.search, color: MyColor.myOrange),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: MyColor.myOrange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: MyColor.myRed, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ChoiceChip(
                  label: Text(_categories[index]),
                  selected: _selectedCategory == index,
                  onSelected: (_) => _selectCategory(index),
                  selectedColor: const Color.fromARGB(234, 218, 32, 25),
                  backgroundColor: const Color.fromARGB(220, 8, 0, 0),
                  labelStyle: TextStyle(
                    color: _selectedCategory == index
                        ? MyColor.myWhite
                        : const Color.fromARGB(218, 241, 233, 233),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<FoodItem>>(
                stream: _itemsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: MyColor.myRed),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Could not load items: ${snapshot.error}',
                        style: TextStyle(color: MyColor.myRed),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final items = (snapshot.data ?? <FoodItem>[]).where((item) {
                    final query = _searchText.toLowerCase();
                    return query.isEmpty ||
                        item.itemName.toLowerCase().contains(query) ||
                        (item.description?.toLowerCase().contains(query) ??
                            false);
                  }).toList();

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No items found.',
                        style: TextStyle(color: MyColor.myWhite),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isOutOfStock = item.itemCount == 0;
                      return Card(
                        color: MyColor.myWhite.withOpacity(0.06),
                        child: ListTile(
                          enabled: !isOutOfStock,
                          onTap: isOutOfStock
                              ? null
                              : () {
                                  // Notify the order editor without closing this
                                  // sheet, so multiple items can be selected.
                                  widget.onItemSelected(item);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${item.itemName} added to order.',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                          leading: _itemImage(item.itemUrl),
                          title: Text(
                            item.itemName,
                            style: TextStyle(color: MyColor.myWhite),
                          ),
                          subtitle: Text(
                            '¥${item.itemPrice}  •  Stock: ${item.itemCount ?? '—'}',
                            style: TextStyle(
                              color: isOutOfStock
                                  ? MyColor.myRed
                                  : MyColor.myWhite70,
                            ),
                          ),
                          trailing: Icon(
                            isOutOfStock ? Icons.block : Icons.add_circle,
                            color: isOutOfStock
                                ? MyColor.myRed
                                : MyColor.myGreen,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemImage(String imageUrl) {
    final fallback = Container(
      width: 52,
      height: 52,
      color: MyColor.myWhite12,
      alignment: Alignment.center,
      child: Icon(Icons.restaurant, color: MyColor.myOrange),
    );

    if (imageUrl.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        // Fall back to an HTML image when browser byte access is blocked.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}
