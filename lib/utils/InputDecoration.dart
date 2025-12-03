// import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';

final InputDecoration inputDecorationStyle = InputDecoration(
  labelStyle: const TextStyle(color: primaryColor),
  prefixIconColor: primaryColor,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: primaryColor),
  ),
);

class InputDecorations {
  static InputDecoration email({String? label}) => InputDecoration(
        labelText: label ?? 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration phone({String? label}) => InputDecoration(
        labelText: label ?? 'Phone',
        hintText: 'Enter your phone number',
        prefixIcon: const Icon(Icons.phone, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration name({String? label}) => InputDecoration(
        labelText: label ?? 'Name',
        hintText: 'Enter your name',
        prefixIcon: const Icon(Icons.person, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration paragraph({String? label}) => InputDecoration(
        labelText: label ?? 'Paragraph',
        hintText: 'Enter text',
        prefixIcon: const Icon(Icons.text_fields, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration creditCard({String? label}) => InputDecoration(
        labelText: label ?? 'Credit Card Number',
        hintText: 'XXXX XXXX XXXX XXXX',
        prefixIcon: const Icon(Icons.credit_card, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration dateField({String? label}) => InputDecoration(
        labelText: label ?? 'Date',
        hintText: 'MM/DD/YYYY',
        prefixIcon: const Icon(Icons.calendar_today, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration timeField({String? label}) => InputDecoration(
        labelText: label ?? 'Time',
        hintText: 'HH:MM',
        prefixIcon: const Icon(Icons.access_time, color: primaryColor),
        border: _outlineBorder(primaryColor),
        focusedBorder: _outlineBorder(primaryColor),
        enabledBorder: _outlineBorder(primaryColor),
      );

  static InputDecoration password({
    String? label,
    bool isPasswordInvalid = false,
  }) =>
      InputDecoration(
        labelText: label ?? 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock, color: primaryColor),
        border: _outlineBorder(isPasswordInvalid ? Colors.red : primaryColor),
        focusedBorder:
            _outlineBorder(isPasswordInvalid ? Colors.red : primaryColor),
        enabledBorder:
            _outlineBorder(isPasswordInvalid ? Colors.red : primaryColor),
      );

  static OutlineInputBorder _outlineBorder(Color borderColor) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderColor),
      );

  // Validates the credit card number (basic Luhn algorithm can be added if required)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a card number';
    final cleanValue = value.replaceAll(' ', '');
    if (!RegExp(r'^\d{16,19}$').hasMatch(cleanValue)) {
      return 'Invalid card number';
    }
    return null;
  }

  static Widget dropdown<T>({
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? label,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString(),
              style: const TextStyle(color: primaryColor)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Validates the expiry date in MM/YY format
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) return 'Enter the expiry date';
    final parts = value.split('/');
    if (parts.length != 2) return 'Enter in MM/YY format';

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]) != null
        ? int.parse(parts[1]) + 2000
        : null; // Assuming YY format

    if (month == null || month < 1 || month > 12) {
      return 'Invalid month in expiry date';
    }

    final now = DateTime.now();
    final expiryDate = DateTime(year!, month);

    if (expiryDate.isBefore(DateTime(now.year, now.month))) {
      return 'Expired card';
    }
    return null;
  }

  // Validates the CVV (3 or 4 digit code)
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) return 'Please enter the CVV';
    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) return 'Invalid CVV';
    return null;
  }
}

class InputValidationUtil {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length > 50) {
      return 'Name cannot exceed 50 characters';
    }
    return null;
  }

  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    if (value.length != 16) {
      return 'Enter a valid 16-digit credit card number';
    }
    return null;
  }
}

class CustomWidgets {
  static Widget checkbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    String? label,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: label != null
          ? Text(label, style: const TextStyle(color: primaryColor))
          : null,
      activeColor: primaryColor,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  static Widget dropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? label,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        // border: InputDecorations._outlineBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString(),
                    style: const TextStyle(color: primaryColor)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  static Widget switchWidget({
    required bool value,
    required ValueChanged<bool> onChanged,
    String? label,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: label != null
          ? Text(label, style: const TextStyle(color: primaryColor))
          : null,
      activeColor: primaryColor,
    );
  }

  static Widget slider({
    required double value,
    required ValueChanged<double> onChanged,
    double min = 0.0,
    double max = 100.0,
    String? label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label, style: const TextStyle(color: primaryColor)),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
  // }

  static Widget segmentedButton({
    required List<Widget> options,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return ToggleButtons(
      isSelected:
          List.generate(options.length, (index) => index == selectedIndex),
      onPressed: onSelected,
      color: primaryColor,
      children: options,
    );
  }

  static Widget rangeSlider({
    required RangeValues values,
    required ValueChanged<RangeValues> onChanged,
    double min = 0.0,
    double max = 100.0,
    String? label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label, style: const TextStyle(color: primaryColor)),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          activeColor: primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  static Widget radioGroup<T>({
    required T groupValue,
    required List<T> items,
    required ValueChanged<T> onChanged,
    String? label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label, style: const TextStyle(color: primaryColor)),
        ...items.map((item) => RadioListTile<T>(
              value: item,
              groupValue: groupValue,
              onChanged: (T? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              title: Text(item.toString(),
                  style: const TextStyle(color: primaryColor)),
              activeColor: primaryColor,
            )),
      ],
    );
  }

  static Widget dateRangePicker({
    required BuildContext context,
    required DateTimeRange initialRange,
    required ValueChanged<DateTimeRange?> onSelected,
    String? label,
  }) {
    return ElevatedButton(
      onPressed: () async {
        DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDateRange: initialRange,
        );
        onSelected(picked);
      },
      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
      child: Text(label ?? "Select Date Range"),
    );
  }

  static Widget datePicker({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime?> onSelected,
    String? label,
  }) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onSelected(picked);
      },
      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
      child: Text(label ?? "Select Date"),
    );
  }

  static Widget chipsInput({
    required List<String> items,
    required List<String> selectedItems,
    required ValueChanged<List<String>> onSelected,
    String? label,
  }) {
    return Wrap(
      spacing: 8.0,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onSelected([...selectedItems, item]);
            } else {
              onSelected(selectedItems..remove(item));
            }
          },
          selectedColor: primaryColor,
        );
      }).toList(),
    );
  }

  static Widget calendar({
    required ValueChanged<DateTime> onDateSelected,
    DateTime? initialDate,
    String? label,
  }) {
    return CalendarDatePicker(
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      onDateChanged: onDateSelected,
    );
  }

  static Widget choiceChips({
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8.0,
      children: options.map((option) {
        return ChoiceChip(
          label: Text(option),
          selected: selectedOption == option,
          onSelected: (selected) {
            if (selected) onSelected(option);
          },
          selectedColor: primaryColor,
        );
      }).toList(),
    );
  }

  static Widget autocomplete({
    required List<String> options,
    required ValueChanged<String> onSelected,
    String? hint,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return options
            .where((option) => option.contains(textEditingValue.text))
            .toList();
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            hintText: hint ?? 'Search...',
            // border: InputDecorations._outlineBorder(),
          ),
        );
      },
    );
  }
}
