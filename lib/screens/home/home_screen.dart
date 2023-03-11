import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/category_data.dart';
import '/screens/backup/backup_screen.dart';
import '/screens/home/cubit/home_cubit.dart';
import '/widgets/app_drawer.dart';
import 'widgets/category_title.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider<HomeCubit>(
        create: (context) => HomeCubit(),
        child: const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final homeCubit = context.read<HomeCubit>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const Text('Your Vault'),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(BackupScreen.routeName),
              icon: const Icon(
                Icons.cloud_upload,
              ),
            ),
            const SizedBox(width: 10.0)
          ],
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            print('Print picked image path -- ${state.pickedImage?.path}');
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryTile(category: category);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
