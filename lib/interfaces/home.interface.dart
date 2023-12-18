abstract class HomeInterface {
  Future<String?> getHomeAndGroup();
  Future<void> saveHomeId(String homeId);
  Future<String?> getHomeId();
}