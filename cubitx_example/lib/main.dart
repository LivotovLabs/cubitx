import 'package:cubitx/cubitx.dart';
import 'package:flutter/material.dart';

final statsCubit = GlobalCubit();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class GlobalCubit extends Cubit<int> {
  GlobalCubit(): super(0);

  updateStats() {
    update(state()+1);
  }

}

class HomeViewCubit extends Cubit<int> {
  HomeViewCubit() : super(0, dependencies: [statsCubit]);

  increment() {
    update(state()+1);
    statsCubit.updateStats();
  }

  reset() {
    update(0);
  }

}

class HomeView extends CubitView<HomeViewCubit, int> {
  HomeView() : super(HomeViewCubit());

  @override
  Widget onComposeWidget(context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SSM Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this session: $state',
            ),
            Text(
              'You have pushed the button in total: ${statsCubit.state()}',
            ),
            const SizedBox(height: 20,),
            MaterialButton(onPressed: () => controller.reset(), child: const Text("Reset Session"),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
