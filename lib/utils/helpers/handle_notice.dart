class HandleNotiInApp {
  static HandleNotiInApp? _instance;

  HandleNotiInApp._();

  static HandleNotiInApp get instance => _instance ??= HandleNotiInApp._();

  void handle(dynamic data) {}
}

final handleNoti = HandleNotiInApp.instance;
