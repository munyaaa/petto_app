import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:petto_app/dependency_injection.dart';
import 'package:petto_app/models/responses/pet_response_model.dart';
import 'package:petto_app/pages/authentication/authentication_page.dart';
import 'package:petto_app/pages/add_pet/add_pet_page.dart';
import 'package:petto_app/pages/home/home_view_model.dart';
import 'package:petto_app/pages/pet_detail/pet_detail_page.dart';
import 'package:petto_app/utils/page_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = DependencyInjection.container.resolve();

  @override
  void initState() {
    super.initState();
    _viewModel.logoutState.listen(
      (value) {
        if (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AuthenticationPage();
              },
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _viewModel.logoutState.close();
    _viewModel.petListState.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewModel.loadPetList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                _viewModel.logout();
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: StreamBuilder<PageState<List<PetResponseModel>>>(
          stream: _viewModel.petListState,
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
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PetDetailPage(
                                id: data[index].id,
                              );
                            },
                          ),
                        );
                      },
                      leading: Image.network(
                        data[index].imageUrl,
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].type,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          Text(data[index].name),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16.0);
                  },
                  itemCount: data.length,
                );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AddPetPage();
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
