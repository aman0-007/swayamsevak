import 'package:flutter/material.dart';
import 'package:swayamsevak/components/enrollment_page/snackbar.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/services/po/adddepartment.dart';

class AddDepartmentPage extends StatefulWidget {
  const AddDepartmentPage({Key? key}) : super(key: key);

  @override
  _AddDepartmentPageState createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _departmentNameController = TextEditingController();
  final List<TextEditingController> _classControllers = [TextEditingController()];
  bool _isLoading = false;

  Future<void> _handleAddDepartment() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final classes = _classControllers.map((c) => c.text.trim()).toList();
        final message = await DepartmentService.addDepartment(
          _departmentNameController.text.trim(),
          classes,
        );

        SnackbarHelper.showSnackbar(context: context, message: message, backgroundColor: Colors.green);

        _departmentNameController.clear();
        _classControllers.forEach((controller) => controller.clear());
      } catch (e) {
        SnackbarHelper.showSnackbar(context: context, message: e.toString(), backgroundColor: Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _addClassField() {
    setState(() {
      _classControllers.add(TextEditingController());
    });
  }

  void _removeClassField(int index) {
    setState(() {
      _classControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Department"),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Department Details",
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextInputField(label: "Department Name",controller: _departmentNameController),
              // TextFormField(
              //   controller: _departmentNameController,
              //   decoration: const InputDecoration(
              //     labelText: "Department Name",
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return "Please enter a department name";
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 20),
              Text(
                "Add Classes",
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _classControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _classControllers[index],
                              decoration: InputDecoration(
                                labelText: "Class ${index + 1}",
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter a class name";
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () => _removeClassField(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _addClassField,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Class"),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAddDepartment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Add Department",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
