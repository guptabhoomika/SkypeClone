

class Utils
{
   String getUsername(String email)
  {
    return "live: " + email.split("@")[0];
  }
  static String getInitials(String uname)
  {
    List<String> nameSplit = uname.split(" ");
    String fini = nameSplit[0][0];
    String lini = nameSplit[1][0];
    String dname = fini + lini;
    return dname;
  }
}