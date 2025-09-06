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
  static const String leaveRequestOverviewApi =
      'api/LeaveRequest/LeaveRequestOverview';
  static const String leaveRequestGetLeaveQuotaApi =
      'api/LeaveQuota/GetLeaveQuotaOverview';
  static const String deleteLeaveRequestApi =
      'api/LeaveRequest/DeleteLeaveRequest';
  static const String getJustDashboardDataApi =
      'api/Justification/GetJustDashboardData';

  static const String approvalListApi =
      'api/TimeEventApprovals/GetTimeEventApprovalsData';

  static const String faceRecognitionListApi =
      'api/FaceRekognition/GetAttendanceUserProfiles';

  static const String getCheckInCheckOutDropDownListApi =
      'api/TimeEvents/GettingAttenEventsDropdown';

  static const String getGetFaceRekognitionScreenDataApi =
      'api/FaceRekognition/GetFaceRekognitionScreenData';
  static const String saveMobileAttendanceUserProfileApi =
      'api//FaceRekognition/AttendanceUserProfilePic';

  static const String getUserTimeZoneApi = '/api/UserProfile/GetUserTimezone';

  static const String checkInApi =
      'api//TimeEvents/INSERT_TimeEvent'; //'/api/TimeEvents/SaveMobileAttendanceUserTimeEvents';

  static const String checkOutApi = 'api//TimeEvents/EditAttendanceEvents';

  static const String timeEventUpdateApi = 'api//TimeEvents/UPDATE_TimeEvent';

  static const String timeEventDeleteApi = 'api//TimeEvents/DELETEAttendEvents';

  static const String deleteFaceRegistrationApi =
      'api//FaceRekognition/DeleteAttendanceUserProfilePic';

  static const String deleteJustificationApi =
      'api//Justification/DELETE_Justifications';

  static const String getMyAccountDetailApi =
      'api/UserProfile/UserProfileDetails';

  static const String getJustificationDropDownListApi =
      'api/Justification/GettingJustifyDropdown';

  static const String getDynamicDashboardsGetChnagedUserTemplateDataApi =
      'api/DynamicDashboards/GetChnagedUserTemplateData';

  static const String getNotificationListApi =
      'api/Notifications/GetNotifications';

  static const String validationForJustification =
      'api/Justification/CommonJustifyWebMobileValidations';

  static const String createJustificationApi =
      'api//Justification/INSERT_Justifications';

  static const String updateJustificationApi =
      'api/Justification/UPDATE_Justifications';

  //https://apis.crisprsys.net/Help/Api/GET-api-TimeEvents-SaveMobileAttendanceUserTimeEvents_flag_CPMClientID_CPMUserName_AttendanceEventList_FilePath

  static const String getLeaveRequestDropDownListApi =
      '/api/LeaveRequest/LeaveRequestData';

  static const String validationForCreateLeaveRequestApi =
      '/api/LeaveRequest/CommonLeaveWebMobileValidations';

  static const String createLeaveRequestApi =
      'api/LeaveRequest/SaveLeaveRequest';

  static const String updateLeaveRequestApi =
      'api//LeaveRequest/EditLeaveRequest';

  static const String dashboardReportApi =
      'api//DynamicDashboards/DisplayTilesReportData';

  static const busObject = 'ATTEND_BUS_Attendance_Events_Overview';

  static const String getNotificationCount = 'api/Notifications/GetNotificationCount';
  //
  //

  static const add = 'Add';
  static const edit = 'Edit';
  static const view = 'View';

  static const somethingWentWrong =
      'Something went wrong...please try again later';
  static const noDataFound = 'No data found';

  static const String isLoggedIn = 'is_logged_in';
  static String authType = 'authType';
  static String accessToken = 'token';

  static String prefClientID = 'prefClientID';
  static String prefPIN = 'prefPin';

  static String prefUsername = 'prefUsername';
  static String prefPassword = 'prefPassword';
  static String prefIsRemember = 'prefIsRemember';

  static String prefEmpName = 'prefEmpName';
  static String prefRole = 'prefRole';
  static String prefRoleCode = 'prefRoleCode';
  static String prefUserId = 'prefUserId';
  static String prefPENRId = 'prefPENRId';

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

  // error messages
  static const String internetConnectionError =
      'Please check your internet connection';
}
