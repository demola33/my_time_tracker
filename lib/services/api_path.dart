class APIPath {
  static String job(String uid, String jobID) => '/users/$uid/jobs/$jobID';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  static String userProfile(String uid) => 'users/$uid';
  static String getUser() => 'users';
}
