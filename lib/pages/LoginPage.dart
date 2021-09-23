import 'package:flutter/material.dart';
import 'package:leermanga_client/entity/Favorites.dart';
import 'package:leermanga_client/entity/UserLocal.dart';
import 'package:leermanga_client/pages/RegisterPage.dart';
import 'package:leermanga_client/supabase.dart';
import 'package:supabase/supabase.dart';

import '../repository.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late List<Favorites?> favorites;
  void getFavoritess() async {
    var fv = await getFavorites();
    if (fv != null) {
      setState(() {
        favorites = fv;
      });
    }
  }

  void getUser() async {
    UserLocal? users = await currentUser();

    if (users != null) {
      countFavorites(users);
    }
  }

  @override
  void initState() {
    super.initState();
    getFavoritess();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Leer Manga',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: Text(''),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await supabaseClient.auth.signIn(
                        email: nameController.text,
                        password: passwordController.text);

                    if (response.error != null) {
                      final snackBar = SnackBar(
                          content: Text('Usuario o contraseña incorrecta'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      String token = response.data!.accessToken;
                      User? user = response.data!.user;
                      await saveUser(new UserLocal(
                          id: user!.id,
                          email: user.email,
                          phone: user.phone,
                          role: user.role,
                          updatedAt: user.createdAt));
                      Navigator.pop(context);
                      int count = await countFavorites(new UserLocal(
                          id: user.id,
                          email: user.email,
                          phone: user.phone,
                          role: user.role,
                          updatedAt: user.createdAt));
                      if (count == 0) {
                        if (favorites.length > 0) {
                          saveFavorites(favorites, user);
                        }
                      }
                    }
                  } catch (e) {
                    print(e.toString());
                    final snackBar =
                        SnackBar(content: Text('Yay! A SnackBar!'));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
                child: Row(
              children: <Widget>[
                Text('No tienes cuenta?'),
                TextButton(
                  child: Text(
                    'Crear cuenta',
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
          ],
        ),
      ),
    );
  }
}

Future<void> saveUser(UserLocal user) async {
  final database = await dbInstance();
  final dao = database.userDao;

  await dao.insertUser(user);
}

Future<List<Favorites?>> getFavorites() async {
  final database = await dbInstance();
  final dao = database.favoriteDao;

  return await dao.findLocal();
}

Future<void> saveFavorites(List<Favorites?> favorites, User user) async {
  favorites.forEach((element) async {
    await supabaseClient.from("favorites").insert({
      'id': element!.id,
      'title': element.title,
      'userId': user.id,
      'cover': element.cover,
      'type': element.type,
      'url': element.url,
      'color': element.color,
      'next': element.next,
    }).execute();
  });
}

Future<int> countFavorites(UserLocal user) async {
  final selectResponse = await supabaseClient
      .from("favorites")
      .select()
      .eq('userId', user.id)
      .execute(count: CountOption.exact);
  if (selectResponse.error == null) {
    return selectResponse.data.length;
  } else {
    return 0;
  }
}

Future<UserLocal?> currentUser() async {
  final database = await dbInstance();
  final dao = database.userDao;

  return await dao.currentUser();
}
