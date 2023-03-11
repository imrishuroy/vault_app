import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();

    ///context.read<ProfileCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    //final profileCubit = context.read<ProfileCubit>();
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20.0),
          // SizedBox(
          //   height: 200.0,
          //   child: Center(
          //     child: CircleAvatar(
          //       radius: 55.0,
          //       child: profileCubit.state.photoFile == null
          //           ? const Icon(Icons.image)
          //           : ClipOval(
          //               child: Image.memory(
          //                 profileCubit.state.photoFile!,
          //                 height: 105.0,
          //                 width: 105.0,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //     ),
          //   ),
          // ),
          const Divider(),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
