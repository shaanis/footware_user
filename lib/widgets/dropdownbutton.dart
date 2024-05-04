import 'package:flutter/material.dart';

class CustomDropButton extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onSelected;

  const CustomDropButton({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Center(
            child: Text(
              'Select Item',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          items: items
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              )
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            onSelected(value); // pass the selected value here
          },
        ),
      ),
    );
  }
}
