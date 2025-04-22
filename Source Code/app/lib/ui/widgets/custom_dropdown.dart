import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '/config/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String heading;
  final String title;
  final String label;
  final IconData icon;
  final List<T> items;
  final String Function(T element) itemAsString;
  final void Function(T?) onChanged;

  final void Function()? onAdd;
  final T? selectedItem;
  final String? error;

  const CustomDropdown({
    super.key,
    required this.heading,
    required this.title,
    required this.label,
    required this.icon,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.onAdd,
    this.selectedItem,
    this.error,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          DropdownSearch<T>(
            items: (item, color) => items,
            selectedItem: selectedItem,
            onChanged: onChanged,
            itemAsString: itemAsString,
            decoratorProps: DropDownDecoratorProps(
              baseStyle: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
                ),
                fillColor: const Color(0xFFA66E38).withValues(alpha: 0.3),
                hintText: "Role",
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3F2917).withValues(alpha: 0.8),
                ),
                prefixIcon: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            clickProps: const ClickProps(splashColor: Colors.white),
            popupProps: PopupProps.modalBottomSheet(
              modalBottomSheetProps: const ModalBottomSheetProps(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              title: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  if (onAdd != null)
                    IconButton(
                      onPressed: onAdd,
                      icon: const Icon(
                        Icons.add,
                        color: WoofCareColors.buttonColor,
                      ),
                    ),
                ],
              ),
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
                  ),
                  fillColor: const Color(0xFFA66E38).withValues(alpha: 0.3),
                  prefixIcon: const Icon(Icons.search),
                  label: Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xFF3F2917).withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, element, _, __) => Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    itemAsString(element),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              emptyBuilder: (_, __) => Center(
                child: Text(
                  "$heading Not Found",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.all(8),
          //   child: (error?.isNotEmpty ?? false) && error != null
          //       ? Row(
          //           children: [
          //             Icon(
          //               Icons.error_outline,
          //               color: theme.colorScheme.error,
          //               size: 20,
          //             ),
          //             const SizedBox(width: 4),
          //             Text(
          //               error!,
          //               style: TextStyle(color: theme.colorScheme.error),
          //             ),
          //           ],
          //         )
          //       : Container(),
          // ),
        ],
      );
}
