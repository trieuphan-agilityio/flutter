abstract class AuthServiceLocator {
  HelloApi get helloApi;
}

class AuthService {
  HelloApi helloApi() => new HelloApi();
}

class HelloApi {}
