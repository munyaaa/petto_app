import 'package:flutter/material.dart';
import 'package:petto_app/dependency_injection.dart';
import 'package:petto_app/models/requests/update_pet_request_model.dart';
import 'package:petto_app/models/responses/pet_detail_response_model.dart';
import 'package:petto_app/pages/pet_detail/pet_detail_view_model.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:petto_app/widgets/petto_loading.dart';

class PetDetailPage extends StatefulWidget {
  final int id;

  const PetDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final PetDetailViewModel _viewModel = DependencyInjection.container.resolve();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel.loadPetDetail(widget.id);

    _viewModel.petDetailState.listen(
      (state) {
        if (state.getState() == StateType.success) {
          final data = state.getData();
          _nameController.text = data.name;
          _ageController.text = data.age.toString();
          _weightController.text = data.weight.toString();
        }
      },
    );

    _viewModel.submissionState.listen(
      (state) {
        switch (state.getState()) {
          case StateType.loading:
            return PettoLoading.show(context);
          case StateType.success:
            PettoLoading.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Success!'),
              ),
            );
            Navigator.pop(context);
            return;
          case StateType.error:
            PettoLoading.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.getError(),
                ),
              ),
            );
            return;
        }
      },
    );
  }

  @override
  void dispose() {
    _viewModel.petDetailState.close();
    _viewModel.submissionState.close();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<PageState<PetDetailResponseModel>>(
            stream: _viewModel.petDetailState,
            builder: (context, snapshot) {
              final state = snapshot.data;

              if (state == null) {
                return const SizedBox.shrink();
              }

              switch (state.getState()) {
                case StateType.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case StateType.error:
                  return Center(
                    child: Text('Error: ${state.getError()}'),
                  );
                case StateType.success:
                  final data = state.getData();
                  return Column(
                    children: [
                      TextFormField(
                        initialValue: data.type,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Pet Type',
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          return (value ?? '').isEmpty
                              ? 'Required field'
                              : null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Pet Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          return (value ?? '').isEmpty
                              ? 'Required field'
                              : null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                hintText: 'Age',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              validator: (value) {
                                return (value ?? '').isEmpty
                                    ? 'Required field'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              controller: _weightController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Weight',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              validator: (value) {
                                return (value ?? '').isEmpty
                                    ? 'Required field'
                                    : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _viewModel.deletePet(widget.id);
                },
                child: const Text('Delete'),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _viewModel.updatePet(
                      widget.id,
                      request: UpdatePetRequestModel(
                        name: _nameController.text,
                        age: int.tryParse(_ageController.text) ?? 0,
                        weight: double.tryParse(_weightController.text) ?? 0,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please fill the form!'),
                      ),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
