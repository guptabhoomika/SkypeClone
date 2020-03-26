

class Utils
{
  String getUsername(String email)
  {
    return "live: " + email.split("@")[0];
  }
}