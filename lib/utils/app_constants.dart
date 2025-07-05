class AppConstants {
  //App related
  static const String appName = 'Crysprsys';
  static const int appVersion = 1;

  static const String fontFamily = 'Inter';

  //API related
  static const String baseUrl = 'https://apis.crisprsys.net/';

  static const String loginApi = 'api/ClientAuthorization/Login';

  static const String updateUserTokenForNotificationApi =
      'api/NotificationToken/UpdateUserTokenForNotification';

  static const String userTrackerApi =
      'api/ClientAuthorization/MobileUserTracker';

  static const String clientAuthenticationApi =
      'api/ClientAuthorization/GetCrisprsysMobAppOTP';

  static const String otpVerificationApi =
      'api/ClientAuthorization/CrisprsysMobAppOTPVerification';

  // Time Events
  static const String timeEventListApi = 'api/TimeEvents/GetTimeEventsData';
  static const String deleteEventApi = 'api/TimeEvents/DELETEAttendEvents';

  static const String approvalListApi =
      'api/TimeEventApprovals/GetTimeEventApprovalsData';

  static const String faceRecognitionListApi =
      'api/FaceRekognition/GetAttendanceUserProfiles';

  static const String getCheckInCheckOutDropDownListApi =
      'api/TimeEvents/GettingAttenEventsDropdown';

  static const String getGetFaceRekognitionScreenDataApi =
      'api/FaceRekognition/GetFaceRekognitionScreenData';
  static const String saveMobileAttendanceUserProfileApi =
      'api/FaceRekognition/SaveMobileAttendanceUserProfile';

  static const String getUserTimeZoneApi = '/api/UserProfile/GetUserTimezone';

  static const String checkInApi =  'api//TimeEvents/INSERT_TimeEvent'; //'/api/TimeEvents/SaveMobileAttendanceUserTimeEvents';

  static const String checkOutApi =  'api//TimeEvents/EditAttendanceEvents';

  static const String timeEventUpdateApi =  'api//TimeEvents/UPDATE_TimeEvent';

  static const String timeEventDeleteApi =  'api//TimeEvents/DELETEAttendEvents';
  //

  //https://apis.crisprsys.net/Help/Api/GET-api-TimeEvents-SaveMobileAttendanceUserTimeEvents_flag_CPMClientID_CPMUserName_AttendanceEventList_FilePath

  //

  //
  static const String isLoggedIn = 'is_logged_in';
  static String authType = 'authType';
  static String accessToken = 'token';

  static String prefClientID = 'prefClientID';
  static String prefPIN = 'prefPin';

  static String prefUsername = 'prefUsername';
  static String prefPassword = 'prefPassword';
  static String prefIsRemember = 'prefIsRemember';

  //login screen
  static const String clientAuthentication = 'Client Authentication';
  static const String companyId = 'Company ID';
  static const String email = 'Email';
  static const String submit = 'Submit';
  static const String backToLogin = 'Back to Login';
  static const String login = 'Login';
  static const String userName = 'User Name';
  static const String rememberMe = 'Remember me';

  static const String phone = 'Phone';
  static const String password = 'Password';

  static const String workForceManagement = 'Workforce management';
  static const String employeesOnLeave = 'Password';
  static const String checkIn = 'Password';
  static const String faceRegistrationList = 'Face Registration List';
  static const String timeEvents = 'Time Events';

  static const String emailIsRequired = 'Email is required';
  static const String passwordIsRequired = 'Password is required';

  static const String whatDidYouGet = 'What did you get done this week?';
  static const String continueWithEmail = 'Continue with Email/Phone';
  static const String continueWitX = 'Continue with X';
  static const String continueWithGoogle = 'Continue with Google';

  static const String byContinueYouAgree = 'By continuing you agree to the';
  static const String termsOfServices = 'Terms of Service';
  static const String privacyPolicy = 'Privacy policy';

  static const String and = 'and';

  static const String completed = 'Completed';
  static const String total = 'Total';
  static const String reminders = 'Reminders';
  static const String completionRate = 'Completion Rate';
  static const String tasks = 'Tasks';
  static const String notes = 'Notes';
  static const String reminder = 'Reminder';
  static const String from = 'From';

  static const String edit = 'Edit';
  static const String viewAdd = 'View/Add Description';
  static const String assignTask = 'Assign Task';
  static const String addReviewer = 'Add Reviewer';
  static const String moveTo = 'Move to';
  static const String category = 'Category';
  static const String delete = 'Delete';

  static const String lessonLearned = 'Lessons Learned';
  static const String visionForNextWeek = 'Vision for Next Week';

  static const String setCustomTimer = 'Set Custom Timer';
  static const String cancel = 'Cancel';
  static const String start = 'Start';
  static const String taskTest = 'Task Test';

  static const String addCategory = 'Add Category';
  static const String personalCare = 'Personal Care';
  static const String exercise = 'Exercise';
  static const String workStudy = 'Work/Study';
  static const String houseHold = 'Household';
  static const String social = 'Social';
  static const String leisure = 'Leisure';
  static const String travel = 'Travel';
  static const String wellness = 'Wellness';
  static const String spirituality = 'Spirituality';

  static const String add = 'Add';
  static const String addTask = 'Add Task';
  static const String addNewTask = 'Add New Task';

  static const String monday = 'Monday';
  static const String tuesday = 'Tuesday';
  static const String wednesday = 'Wednesday';
  static const String thursday = 'Thursday';
  static const String friday = 'Friday';
  static const String saturday = 'Saturday';
  static const String sunday = 'Sunday';

  static const String assign = 'Assign';
  static const String deleteTask = 'Delete Task';
  static const String yesDelete = 'Yes,Delete';

  static const String addDescription = 'Add Description';
  static const String taskName = 'Task Name';
  static const String dateDay = 'Date & Day';
  static const String update = 'Update';
  static const String verify = 'Verify';
  static const String description = 'Description';
  static const String setTimer = 'Set Timer';
  static const String editTask = 'Edit Task';

  static const String titleForAssignTask =
      'Enter the email address or phone number of the person you want to assign this task.';
  static const String titleForAddReviewer =
      'Enter the email address or phone number of the person you want to review this task.';

  static const String areYouSureYouWantToDelete =
      'Are you sure you want to delete this task from your list?';

  static const String deleteAccountContent =
      "You will lose all of your data by deleting your account. This action cannot be undone.";

  //

  static const String addName = 'Please add full name';
  static const String addEmail = 'Please add email address';
  static const String addValidEmail = 'Please add valid email';
  static const String addPhone = 'Please add phone number';
  static const String addValidPhone = 'Please add valid phone number';
  static const String addPassword = 'Please add password';
  static const String passwordShould =
      'Password should be at least 6 character';

  static const String addOtp = 'Please enter otp field';
  static const String addCorrectOtp = 'Please enter otp field';

  static const String lightMode = 'Light Mode';
  static const String darkMode = 'Dark Mode';
  static const String termsConditions = 'Terms & Conditions';

  //static const String privacyPolicy = 'Privacy Policy';
  static const String faq = 'FAQs';
  static const String deleteAccount = 'Delete Account';

  static const String logout = 'Logout';

  static const String fullName = 'Full name';
  static const String changePassword = 'Change Password';
  static const String editProfile = 'Edit Profile';

  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String confirmPassword = 'Confirm Password';

  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String commonErrorMessage =
      'Something went wrong. Try again later';
  static const String completedTask = 'Complete Task';
  static const String areYouSureYouWantToComplete =
      'Are you sure you want to complete this task from your list?';
  static const String yesComplete = 'Yes,Complete';

  static const String visibilityAssignee = 'assignee';
  static const String visibilityReviewer = 'reviewer';
  static const String visibilityCreator = '';

  // test4   assign  test3  --> assign from test 4
  // assign to test3 name

  //

  //By continuing you agree to the Terms of Service and
  // Privacy policy

  // dashboard screen

  //static value
  // static const String isLogin = 'isLogin';
  // static const String isIntro = 'isIntro';
  // static const String userToken = 'userToken';

  // error messages
  static const String internetConnectionError =
      'Please check your internet connection';
}
