// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LOKATE';

  @override
  String get appTagline => 'Rent from home';

  @override
  String get onboardingTitle1 => 'Find your home';

  @override
  String get onboardingSubtitle1 =>
      'Browse hundreds of apartments, studios and villas in Douala and Yaoundé from your phone.';

  @override
  String get onboardingTitle2 => '360° Virtual Tour';

  @override
  String get onboardingSubtitle2 =>
      'Visit every room in detail without leaving home thanks to our interactive 360° gallery.';

  @override
  String get onboardingTitle3 => 'Pay with Mobile Money';

  @override
  String get onboardingSubtitle3 =>
      'MTN MoMo, Orange Money or credit card — choose the payment method that works for you.';

  @override
  String get onboardingTitle4 => 'Sign Online';

  @override
  String get onboardingSubtitle4 =>
      'Contract signed, keys collected — everything done without unnecessary paperwork.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get loginWelcomeBack => 'Welcome back 👋';

  @override
  String get loginSubtitle => 'Sign in to your account';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginPasswordMin => 'Minimum 6 characters';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginForgotPasswordTitle => 'Reset Password';

  @override
  String get loginForgotPasswordSubtitle => 'Enter your email to reset';

  @override
  String get loginForgotPasswordSent => 'Reset email sent';

  @override
  String get loginForgotPasswordError => 'Could not send email';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginOr => 'or';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get loginPhone => 'Continue with phone number';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get loginErrorInvalid => 'Incorrect email or password';

  @override
  String get loginErrorFirebase =>
      'Login unavailable. Check your Firebase configuration.';

  @override
  String get loginGoogleCancelled => 'Google sign-in cancelled';

  @override
  String get loginGoogleError =>
      'Google sign-in failed. Demo mode is active for preview.';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerIAm => 'I am...';

  @override
  String get registerTenant => 'Tenant';

  @override
  String get registerOwner => 'Owner';

  @override
  String get registerName => 'Full name';

  @override
  String get registerNameHint => 'John Doe';

  @override
  String get registerNameError => 'Name too short';

  @override
  String get registerEmail => 'Email';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerEmailError => 'Invalid email';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerPasswordHint => '••••••';

  @override
  String get registerPasswordMin => 'Minimum 6 characters';

  @override
  String get registerPhone => 'Phone number';

  @override
  String get registerPhoneHint => '6XX XXX XXX';

  @override
  String get registerPhonePrefix => '+237 ';

  @override
  String get registerPhoneError => '9 digits required';

  @override
  String get registerButton => 'Create my account';

  @override
  String get registerPhoneButton => 'Send SMS code';

  @override
  String get registerError =>
      'Registration failed. Check your Firebase configuration or continue in demo mode.';

  @override
  String get otpTitle => 'SMS Verification';

  @override
  String get otpSubtitle => 'Verification code';

  @override
  String otpSentTo(String phone) {
    return 'We sent an SMS code to\n$phone';
  }

  @override
  String get otpVerify => 'Verify';

  @override
  String get otpResend => 'Resend code';

  @override
  String get otpError => 'Incorrect code. Try again.';

  @override
  String get otpDefaultName => 'User';

  @override
  String homeGreeting(String name) {
    return 'Hello $name 👋';
  }

  @override
  String get homeSearchPlaceholder => 'Search a neighborhood, a city...';

  @override
  String get homeSearchDouala => 'Search in Douala, Yaoundé...';

  @override
  String homeResultsCount(int count) {
    return '$count properties found';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterApartment => 'Apartment';

  @override
  String get filterStudio => 'Studio';

  @override
  String get filterVilla => 'Villa';

  @override
  String get filterRoom => 'Room';

  @override
  String get emptySearchTitle => 'No results';

  @override
  String emptySearchSubtitle(String query) {
    return 'No properties match \"$query\". Try different keywords.';
  }

  @override
  String get emptyPropertiesTitle => 'No properties found';

  @override
  String get emptyPropertiesSubtitle =>
      'Adjust your filters to see more results.';

  @override
  String get mapSearch => 'Search on map...';

  @override
  String mapPropertiesCount(int count) {
    return '$count properties';
  }

  @override
  String get mapView => 'View';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navMessages => 'Messages';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navProfile => 'Profile';

  @override
  String get propertyLoading => 'Loading property...';

  @override
  String get propertyNotFound => 'Property not found';

  @override
  String get propertyNotFoundSubtitle => 'This property may have been deleted.';

  @override
  String get propertyVirtualTour => '360° Tour';

  @override
  String get propertyAvailable => '✓ Available';

  @override
  String get propertyOccupied => '✗ Occupied';

  @override
  String get propertyMonthlyRent => 'Monthly rent';

  @override
  String get propertyBedrooms => 'Bedrooms';

  @override
  String get propertyBathrooms => 'Bathrooms';

  @override
  String get propertySurface => 'm²';

  @override
  String get propertyDescription => 'Description';

  @override
  String get propertyAmenities => 'Amenities';

  @override
  String get propertyOwner => 'Owner';

  @override
  String propertyReviews(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get propertyContact => 'Contact';

  @override
  String get propertyReserveNow => 'Book now';

  @override
  String get propertySendMessage => 'Send a request';

  @override
  String get virtualTourTitle => '360° Virtual Tour';

  @override
  String virtualTourPiece(int current, int total) {
    return 'Room $current / $total';
  }

  @override
  String get virtualTourSwipe => '← Swipe to navigate →';

  @override
  String get virtualTourLoading => 'Loading 360° view...';

  @override
  String get virtualTourUnavailable => '360° Tour unavailable';

  @override
  String get virtualTourNoData =>
      'This property doesn\'t have a virtual tour yet.';

  @override
  String get virtualTourSeePhotos => 'See photos';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterReset => 'Reset';

  @override
  String get filterType => 'Property type';

  @override
  String get filterCity => 'City';

  @override
  String get filterBudget => 'Monthly budget (FCFA)';

  @override
  String get filterBedroomsMin => 'Minimum bedrooms';

  @override
  String get filterApply => 'Apply filters';

  @override
  String filterPriceRange(int min) {
    return '$min FCFA';
  }

  @override
  String get bookingTitle => 'Book this property';

  @override
  String get bookingNotFound => 'Property not found';

  @override
  String get bookingError => 'Booking error';

  @override
  String get bookingSuccessTitle => 'Request sent!';

  @override
  String get bookingSuccessSubtitle =>
      'The owner will review your request and contact you.';

  @override
  String get bookingBackHome => 'Back to home';

  @override
  String get bookingFrequency => 'Payment frequency';

  @override
  String get bookingMonthly => 'Monthly';

  @override
  String bookingMonthlyPrice(int price) {
    return '$price FCFA/month';
  }

  @override
  String get bookingAnnual => 'Annual';

  @override
  String get bookingAnnualDiscount => '-10% discount';

  @override
  String get bookingMoveInDate => 'Move-in date';

  @override
  String get bookingMessage => 'Message to owner (optional)';

  @override
  String get bookingMessageHint =>
      'Introduce yourself and explain your situation...';

  @override
  String get bookingBaseRent => 'Base rent';

  @override
  String get bookingAnnualDiscountLabel => 'Annual discount';

  @override
  String get bookingTotal => 'Total to pay';

  @override
  String get bookingPerYear => 'per year';

  @override
  String get bookingPerMonth => 'per month';

  @override
  String get bookingContinuePayment => 'Continue to payment';

  @override
  String get bookingSendRequest => 'Send request';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentAmount => 'Amount to pay';

  @override
  String get paymentMonthly => 'Monthly payment';

  @override
  String get paymentAnnual => 'Annual payment';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentMTN => 'MTN Mobile Money';

  @override
  String get paymentOrange => 'Orange Money';

  @override
  String get paymentCard => 'Credit card (Visa/MasterCard)';

  @override
  String get paymentSecure => '100% secure payment';

  @override
  String get paymentProcessing => 'Processing...';

  @override
  String paymentPay(int amount) {
    return 'Pay $amount FCFA';
  }

  @override
  String get paymentError => 'Payment failed. Try again.';

  @override
  String get paymentNumberMTN => 'MTN Number';

  @override
  String get paymentNumberOrange => 'Orange Number';

  @override
  String get paymentPhoneHint => '6XX XXX XXX';

  @override
  String get paymentPhonePrefix => '+237 ';

  @override
  String get paymentPhoneConfirmationMTN =>
      'You will receive an MTN MoMo confirmation on this number.';

  @override
  String get paymentPhoneConfirmationOrange =>
      'You will receive an Orange Money confirmation on this number.';

  @override
  String get paymentCardNumber => 'Card number';

  @override
  String get paymentCardHint => '1234 5678 9012 3456';

  @override
  String get paymentCardExpiry => 'Expiry';

  @override
  String get paymentCardExpiryHint => 'MM/YY';

  @override
  String get paymentCardCVV => 'CVV';

  @override
  String get paymentCardCVVHint => '•••';

  @override
  String get contractTitle => 'Rental Agreement';

  @override
  String get contractSignedTitle => 'Contract signed!';

  @override
  String get contractSignedSubtitle =>
      'Congratulations! Your rental contract has been signed successfully.';

  @override
  String get contractBackHome => 'Back to home';

  @override
  String get contractHeading => 'RENTAL AGREEMENT';

  @override
  String contractBrand(int year) {
    return 'LOKATE — $year';
  }

  @override
  String get contractProperty => 'Rented property';

  @override
  String get contractStartDate => 'Start date';

  @override
  String get contractRent => 'Rent';

  @override
  String get contractFrequency => 'Frequency';

  @override
  String get contractMonthly => 'Monthly';

  @override
  String get contractAnnual => 'Annual';

  @override
  String get contractTerms => 'General Terms';

  @override
  String get contractAccept =>
      'I have read and accept the general terms of the rental agreement.';

  @override
  String get contractSign => 'Sign contract';

  @override
  String get contractArticle1Title => 'Article 1 – PURPOSE';

  @override
  String get contractArticle1Body =>
      'This agreement concerns the rental of a property located at the address specified in the booking, by the Tenant from the Owner.';

  @override
  String get contractArticle2Title => 'Article 2 – DURATION';

  @override
  String get contractArticle2Body =>
      'This contract is concluded for the duration specified in the booking, renewable by tacit renewal unless terminated by either party with 30 days\' notice.';

  @override
  String get contractArticle3Title => 'Article 3 – RENT';

  @override
  String get contractArticle3Body =>
      'The rent amount is as agreed at the time of booking. It is payable in advance, either monthly or annually depending on the option chosen.';

  @override
  String get contractArticle4Title => 'Article 4 – CHARGES';

  @override
  String get contractArticle4Body =>
      'Charges are included in the rent unless explicitly stated otherwise. Utility charges (water, electricity) remain the tenant\'s responsibility.';

  @override
  String get contractArticle5Title => 'Article 5 – INVENTORY';

  @override
  String get contractArticle5Body =>
      'An entry inventory will be conducted on the day of key handover. The tenant agrees to return the property in good condition.';

  @override
  String get contractArticle6Title => 'Article 6 – TERMINATION';

  @override
  String get contractArticle6Body =>
      'Either party may terminate the contract with 30 days\' notice. In case of non-payment, the owner may terminate without notice.';

  @override
  String get contractArticle7Title => 'Article 7 – APPLICABLE LAW';

  @override
  String get contractArticle7Body =>
      'This contract is governed by the laws of the Republic of Cameroon. Any dispute shall be submitted to the competent courts of Douala.';

  @override
  String get chatEmptyTitle => 'No messages';

  @override
  String get chatEmptySubtitle => 'Contact an owner to start a conversation.';

  @override
  String get chatOnline => 'Online';

  @override
  String get chatInputHint => 'Your message...';

  @override
  String get chatStartConversation => 'Start the conversation';

  @override
  String chatSendMessageTo(String name) {
    return 'Send a message to $name';
  }

  @override
  String get chatNow => 'now';

  @override
  String chatMinutesAgo(int minutes) {
    return '${minutes}min';
  }

  @override
  String chatHoursAgo(int hours) {
    return '${hours}h';
  }

  @override
  String chatDaysAgo(int days) {
    return '${days}d';
  }

  @override
  String get chatDefaultName => 'User';

  @override
  String profileRating(String rating, int count) {
    return '$rating ($count reviews)';
  }

  @override
  String get profileMyAccount => 'My Account';

  @override
  String get profilePersonalInfo => 'Personal Information';

  @override
  String profilePhone(String phone) {
    return 'Phone: $phone';
  }

  @override
  String get profilePhoneNotSet => 'Not set';

  @override
  String get profileRentalHistory => 'Rental History';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileLightMode => 'Light Mode';

  @override
  String get profileDarkMode => 'Dark Mode';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileSupport => 'Support';

  @override
  String get profileHelp => 'Help Center';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get profileShare => 'Share LOKATE';

  @override
  String get profileAbout => 'About LOKATE';

  @override
  String get profileLogout => 'Sign Out';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileEditName => 'Full name';

  @override
  String get profileEditNameHint => 'Your name';

  @override
  String get profileEditSaved => 'Profile updated!';

  @override
  String get profileEditSave => 'Save';

  @override
  String get profileAboutText =>
      'Rent from home with 360° virtual tours and Mobile Money payments.';

  @override
  String get profileClose => 'Close';

  @override
  String get reviewTitle => 'Leave a Review';

  @override
  String get reviewExperience => 'Your experience';

  @override
  String get reviewHelpOthers =>
      'Your review helps other users make the right choice.';

  @override
  String get reviewComment => 'Your comment';

  @override
  String get reviewCommentHint =>
      'Describe your experience with this property / owner...';

  @override
  String get reviewSubmit => 'Submit my review';

  @override
  String get reviewSuccess => 'Review published successfully!';

  @override
  String get reviewError => 'Error publishing review';

  @override
  String get reviewRatingVeryBad => 'Very bad';

  @override
  String get reviewRatingBad => 'Bad';

  @override
  String get reviewRatingOk => 'OK';

  @override
  String get reviewRatingGood => 'Good';

  @override
  String get reviewRatingExcellent => 'Excellent!';

  @override
  String get dashboardTitle => 'My Dashboard';

  @override
  String get dashboardAddProperty => 'Add Property';

  @override
  String get dashboardLoading => 'Loading your properties...';

  @override
  String get dashboardPublished => 'Published';

  @override
  String get dashboardAvailable => 'Available';

  @override
  String get dashboardOccupied => 'Occupied';

  @override
  String get dashboardMyProperties => 'My Properties';

  @override
  String get dashboardRequests => 'Requests';

  @override
  String get dashboardEmptyTitle => 'No properties published';

  @override
  String get dashboardEmptySubtitle =>
      'Publish your first property to start receiving requests.';

  @override
  String get dashboardEmptyAction => 'Publish a property';

  @override
  String get dashboardAvailableLabel => 'Available';

  @override
  String get dashboardOccupiedLabel => 'Occupied';

  @override
  String get dashboardMarkOccupied => 'Marked as occupied';

  @override
  String get dashboardMarkAvailable => 'Marked as available';

  @override
  String get dashboardDeleteTitle => 'Delete this property?';

  @override
  String get dashboardDeleteSubtitle =>
      'This action is irreversible. All data will be lost.';

  @override
  String get dashboardCancel => 'Cancel';

  @override
  String get dashboardDelete => 'Delete';

  @override
  String get dashboardDeleted => 'Property deleted';

  @override
  String get dashboardEdit => 'Edit';

  @override
  String get dashboardMarkOccupiedAction => 'Mark occupied';

  @override
  String get dashboardMarkAvailableAction => 'Mark available';

  @override
  String get ownerReservationsTitle => 'Rental Requests';

  @override
  String get ownerReservationsEmpty => 'No requests';

  @override
  String get ownerStatusPending => 'Pending';

  @override
  String get ownerStatusApproved => 'Approved';

  @override
  String get ownerStatusActive => 'Active';

  @override
  String get ownerStatusRejected => 'Rejected';

  @override
  String get ownerStatusCompleted => 'Completed';

  @override
  String get ownerReject => 'Reject';

  @override
  String get ownerApprove => 'Approve';

  @override
  String ownerPricePerMonth(int price) {
    return '$price FCFA / month';
  }

  @override
  String ownerPricePerYear(int price) {
    return '$price FCFA / year';
  }

  @override
  String get addPropertyTitle => 'Publish Property';

  @override
  String get addPropertyStep1 => 'General Information';

  @override
  String get addPropertyStep1Of3 => 'Step 1 of 3';

  @override
  String get addPropertyTitleLabel => 'Property title';

  @override
  String get addPropertyTitleHint =>
      'Ex: Beautiful 3-bedroom apartment in Bonapriso';

  @override
  String get addPropertyTitleError => 'Title too short';

  @override
  String get addPropertyType => 'Property type';

  @override
  String get addPropertyTypeApartment => 'Apartment';

  @override
  String get addPropertyTypeStudio => 'Studio';

  @override
  String get addPropertyTypeVilla => 'Villa';

  @override
  String get addPropertyTypeRoom => 'Room';

  @override
  String get addPropertyTypeOther => 'Other';

  @override
  String get addPropertyDescription => 'Description';

  @override
  String get addPropertyDescriptionHint =>
      'Describe your property in detail...';

  @override
  String get addPropertyDescriptionError => 'Description too short';

  @override
  String get addPropertyStep2 => 'Location & Price';

  @override
  String get addPropertyStep2Of3 => 'Step 2 of 3';

  @override
  String get addPropertyCity => 'City';

  @override
  String get addPropertyDistrict => 'Neighborhood';

  @override
  String get addPropertyDistrictHint => 'Ex: Bonapriso, Akwa, Bastos...';

  @override
  String get addPropertyAddress => 'Full address';

  @override
  String get addPropertyAddressHint => 'Street, number...';

  @override
  String get addPropertyFieldRequired => 'Required field';

  @override
  String get addPropertyRent => 'Monthly rent (FCFA)';

  @override
  String get addPropertyRentHint => 'Ex: 150000';

  @override
  String get addPropertyRentError => 'Invalid price';

  @override
  String get addPropertyBedrooms => 'Bedrooms';

  @override
  String get addPropertyBathrooms => 'Bathrooms';

  @override
  String get addPropertySurface => 'Area (m²)';

  @override
  String get addPropertySurfaceHint => 'Ex: 80';

  @override
  String get addPropertyBack => '← Back';

  @override
  String get addPropertyNext => 'Next →';

  @override
  String get addPropertyStep3 => 'Photos & Amenities';

  @override
  String get addPropertyStep3Of3 => 'Step 3 of 3';

  @override
  String get addPropertyPhotos => 'Property photos';

  @override
  String get addPropertyAddPhotos => 'Add photos';

  @override
  String get addPropertyAmenities => 'Amenities';

  @override
  String get addPropertyReservationMode => 'Booking mode';

  @override
  String get addPropertyImmediate => 'Immediate booking';

  @override
  String get addPropertyApprovalRequired => 'Approval required';

  @override
  String get addPropertyImmediateDesc => 'Tenants can book directly';

  @override
  String get addPropertyApprovalDesc =>
      'You approve each request before confirmation';

  @override
  String get addPropertyPublishing => 'Publishing...';

  @override
  String get addPropertyPublish => 'Publish';

  @override
  String get addPropertySuccess => 'Property published successfully!';

  @override
  String get addPropertyError => 'Error publishing property';

  @override
  String get amenityWifi => 'WiFi';

  @override
  String get amenityParking => 'Parking';

  @override
  String get amenityAC => 'Air Conditioning';

  @override
  String get amenityGuard => 'Security Guard';

  @override
  String get amenityGenerator => 'Generator';

  @override
  String get amenityHotWater => 'Hot Water';

  @override
  String get amenityBalcony => 'Balcony';

  @override
  String get amenityKitchen => 'Equipped Kitchen';

  @override
  String get amenityPool => 'Swimming Pool';

  @override
  String get editPropertyTitle => 'Edit Property';

  @override
  String get editPropertySuccess => 'Property updated!';

  @override
  String get editPropertyError => 'Error updating property';

  @override
  String get editPropertySave => 'Save Changes';

  @override
  String get editPropertyAvailable => 'Available';

  @override
  String get badgeVerified => 'Verified';

  @override
  String get badgeCertified => 'Certified';

  @override
  String get badgeTrusted => 'Trusted';

  @override
  String get cardAvailable => 'Available';

  @override
  String get cardOccupied => 'Occupied';

  @override
  String get card360 => '360°';

  @override
  String cardBedroomsShort(int count) {
    return '$count bd.';
  }

  @override
  String cardSurfaceShort(int surface) {
    return '$surface m²';
  }

  @override
  String get emptyErrorTitle => 'An error occurred';

  @override
  String get emptyErrorSubtitle =>
      'Check your internet connection and try again.';

  @override
  String get emptyErrorRetry => 'Try Again';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';
}
