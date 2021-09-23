import 'package:flutter/material.dart';
import 'package:leermanga_client/entity/UserLocal.dart';
import 'package:leermanga_client/pages/FavoritesPage.dart';
import 'package:leermanga_client/pages/HistoryPage.dart';
import 'package:leermanga_client/pages/HomePage.dart';
import 'package:leermanga_client/pages/LoginPage.dart';
import 'package:leermanga_client/pages/MangasPage.dart';
import 'package:leermanga_client/supabase.dart';
import 'package:supabase/supabase.dart';

import '../repository.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool login = false;
  late UserLocal? user;
  void getUser() async {
    UserLocal? users = await currentUser();

    if (users != null) {
      print(users.email);
      setState(() {
        user = users;
        login = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(login == true ? user!.email ?? "" : "Menu")
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              /*
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))*/
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Nuevos'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Listar todos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MangasPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favoritos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            },
          ),
          login
              ? ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    await supabaseClient.auth.signOut();
                    await deleteUser();
                    setState(() {
                      login = false;
                    });
                  },
                )
              : ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
        ],
      ),
    );
  }
}

Future<UserLocal?> currentUser() async {
  final database = await dbInstance();
  final dao = database.userDao;

  return await dao.currentUser();
}

Future<void> deleteUser() async {
  final database = await dbInstance();
  final dao = database.userDao;

  return await dao.deleteUser();
}
