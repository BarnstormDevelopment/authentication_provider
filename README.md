# Authentication Provider

This Widget is modeled after the provider package but specifically for the authentication workflow.

## Example
```
class _MyAppState extends State<MyApp> {
  AuthenticationController controller;

  @override
  void initState() {
    super.initState();
    controller = AuthenticationController<User>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AuthenticationProvider<User>(
            controller: controller,
            builder: (context) {
              var state = AuthenticationProvider.of<User>(context).state;
              if (state is AuthState.Loading) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Loading'),
                  ),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is AuthState.Unauthenticated) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Unauthenticated'),
                  ),
                  body: Center(
                    child: Column(children: [
                      Text('Woops, you are not authenticated.'),
                      FlatButton(
                        child: Text('Sign In'),
                        onPressed: () => controller.authenticate(user: User()),
                      )
                    ]),
                  ),
                );
              } else if (state is AuthState.Authenticated<User>) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Authenticated'),
                  ),
                  body: Center(
                    child: Column(children: [
                      Text(
                          'Congratulations, you (${state.user.name}) are authenticated.'),
                      FlatButton(
                        child: Text('Log Out'),
                        onPressed: () => controller.deauthenticate(),
                      )
                    ]),
                  ),
                );
              }
              Future.delayed(Duration(seconds: 1), () {
                controller.initialize();
              });
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Uninitialized'),
                ),
                body: Center(
                  child: Text(''),
                ),
              );
            }));
  }
}

class User {
  String name = 'Nathaniel';
}
```

## Usage

For most users the only classes of concern are `AuthenticationState` and `AuthenticationProvider`.

`AuthenticationProvider` should be placed at the top of the widget tree in order to redraw the widget tree if a user is de-authenticated. You will need to pass an `AuthenticationController` to the provider, which has many optional parameters.
