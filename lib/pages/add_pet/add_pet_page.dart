import 'package:flutter/material.dart';
import 'package:petto_app/dependency_injection.dart';
import 'package:petto_app/models/requests/create_pet_request_model.dart';
import 'package:petto_app/models/responses/pet_type_response_model.dart';
import 'package:petto_app/pages/add_pet/add_pet_view_model.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:petto_app/widgets/petto_loading.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final AddPetViewModel _viewModel = DependencyInjection.container.resolve();
  final _formKey = GlobalKey<FormState>();

  int? _selectedPetTypeId;
  final TextEditingController _petTypeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

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
    _viewModel.petTypesState.close();
    _petTypeController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _petTypeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Pet Type',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                onTap: () {
                  _viewModel.loadPetTypes();
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width,
                      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                    ),
                    isScrollControlled: true,
                    builder: (context) {
                      return StreamBuilder<
                          PageState<List<PetTypeResponseModel>>>(
                        stream: _viewModel.petTypesState,
                        builder: (context, snapshot) {
                          final state = snapshot.data;

                          if (state == null) {
                            return const SizedBox.shrink();
                          }

                          switch (state.getState()) {
                            case StateType.loading:
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              );
                            case StateType.error:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Error: ${state.getError()}'),
                                ],
                              );
                            case StateType.success:
                              final data = state.getData();
                              return GridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 3 / 4,
                                crossAxisCount: 2,
                                children: data
                                    .map((e) => _getPetTypeItem(e))
                                    .toList(),
                              );
                          }
                        },
                      );
                    },
                  );
                },
                validator: (value) {
                  return (value ?? '').isEmpty ? 'Required field' : null;
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
                  return (value ?? '').isEmpty ? 'Required field' : null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: const TextInputType.numberWithOptions(),
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
                        return (value ?? '').isEmpty ? 'Required field' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: const TextInputType.numberWithOptions(
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
                        return (value ?? '').isEmpty ? 'Required field' : null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              final petTypeId = _selectedPetTypeId;

              if (petTypeId == null) {
                return;
              }

              _viewModel.submitPet(
                CreatePetRequestModel(
                  typeId: petTypeId,
                  name: _nameController.text,
                  age: int.tryParse(_ageController.text) ?? 0,
                  weight: double.tryParse(_weightController.text) ?? 0.0,
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
          child: const Text('Add'),
        ),
      ),
    );
  }

  Widget _getPetTypeItem(PetTypeResponseModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(
          fit: BoxFit.cover,
          width: 185.0,
          height: 180.0,
          model.imageUrl,
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton(
            onPressed: () {
              _selectedPetTypeId = model.id;
              _petTypeController.text = model.type;
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ),
      ],
    );
  }
}
