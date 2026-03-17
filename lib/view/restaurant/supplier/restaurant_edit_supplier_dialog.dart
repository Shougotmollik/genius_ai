import 'package:flutter/material.dart';
import 'package:genius_ai/controller/supplier_controller.dart';
import 'package:genius_ai/model/supplier.dart';
import 'package:get/get.dart';

class RestaurantEditSupplierDialog extends StatefulWidget {
  const RestaurantEditSupplierDialog({super.key, required this.supplier});
  final Supplier supplier;

  @override
  State<RestaurantEditSupplierDialog> createState() =>
      _RestaurantEditSupplierDialogState();
}

class _RestaurantEditSupplierDialogState
    extends State<RestaurantEditSupplierDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _startController;
  late TextEditingController _endController;
  late TextEditingController _notesController;

  final SupplierController controller = Get.find<SupplierController>();

  @override
  void initState() {
    super.initState();
    // Initialize with existing data
    _nameController = TextEditingController(text: widget.supplier.name);
    _phoneController = TextEditingController(text: widget.supplier.phone);
    _emailController = TextEditingController(text: widget.supplier.email);
    _addressController = TextEditingController(text: widget.supplier.address);
    _startController = TextEditingController(
      text: widget.supplier.contractStartDate?.toString().split(' ')[0] ?? '',
    );
    _endController = TextEditingController(
      text: widget.supplier.contractEndDate?.toString().split(' ')[0] ?? '',
    );
    _notesController = TextEditingController(text: widget.supplier.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                color: const Color(0xFF0091FF),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.business_center,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Edit Supplier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Supplier Name *"),
                        _buildTextField(_nameController, "Enter name"),

                        _buildLabel("Phone *"),
                        _buildTextField(
                          _phoneController,
                          "Enter phone",
                          icon: Icons.phone_outlined,
                        ),

                        _buildLabel("Email *"),
                        _buildTextField(
                          _emailController,
                          "Enter email",
                          icon: Icons.email_outlined,
                        ),

                        _buildLabel("Address *"),
                        _buildTextField(
                          _addressController,
                          "Enter address",
                          icon: Icons.location_on_outlined,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("Contract Start"),
                                  _buildTextField(
                                    _startController,
                                    "Select date",
                                    icon: Icons.calendar_today_outlined,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000),
                                          );
                                      if (pickedDate != null) {
                                        setState(() {
                                          String formattedDate =
                                              "${pickedDate.day.toString().padLeft(2, '0')}-"
                                              "${pickedDate.month.toString().padLeft(2, '0')}-"
                                              "${pickedDate.year}";

                                          _startController.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("Contract End"),
                                  _buildTextField(
                                    _endController,
                                    "Select date",
                                    icon: Icons.calendar_today_outlined,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000),
                                          );
                                      if (pickedDate != null) {
                                        setState(() {
                                          String formattedDate =
                                              "${pickedDate.day.toString().padLeft(2, '0')}-"
                                              "${pickedDate.month.toString().padLeft(2, '0')}-"
                                              "${pickedDate.year}";
                                          _endController.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        _buildLabel("Notes & Comments"),
                        _buildTextField(
                          _notesController,
                          "Add any additional notes or comments about this supplier...",
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var payload = {
                                "name": _nameController.text,
                                "phone": _phoneController.text
                                    .replaceAll("(", "")
                                    .replaceAll(")", "")
                                    .replaceAll("-", "")
                                    .replaceAll(" ", ""),
                                "email": _emailController.text.trim(),
                                "address": _addressController.text,
                                "contract_start_date": _startController.text,
                                "contract_end_date": _endController.text,
                                "notes": _notesController.text,
                                "rating": 4.5,
                                "is_active": true,
                              };
                              final bool success = await controller
                                  .editSupplier(
                                    id: widget.supplier.id.toString(),
                                    body: payload,
                                  );
                              if (success) {
                                Get.back();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0091FF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Update",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF4A4A4A),
          fontSize: 14,
        ),
      ),
    );
  }

  // Helper widget for TextFields
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? icon,
    int maxLines = 1,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.grey, size: 20)
            : null,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0091FF)),
        ),
      ),
    );
  }
}
