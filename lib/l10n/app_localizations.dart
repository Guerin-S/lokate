import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'LOKATE'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In fr, this message translates to:
  /// **'Loue depuis chez toi'**
  String get appTagline;

  /// No description provided for @onboardingTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez votre logement'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In fr, this message translates to:
  /// **'Parcourez des centaines d\'appartements, studios et villas à Douala et Yaoundé depuis votre téléphone.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In fr, this message translates to:
  /// **'Visite virtuelle 360°'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In fr, this message translates to:
  /// **'Visitez chaque pièce en détail sans bouger de chez vous grâce à notre galerie interactive 360°.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In fr, this message translates to:
  /// **'Payez en Mobile Money'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In fr, this message translates to:
  /// **'MTN MoMo, Orange Money ou carte bancaire — choisissez le mode de paiement qui vous convient.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In fr, this message translates to:
  /// **'Signez en ligne'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In fr, this message translates to:
  /// **'Contrat signé, clés récupérées — tout se fait sans paperasse inutile.'**
  String get onboardingSubtitle4;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour 👋'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous à votre compte'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'votre@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'••••••'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordMin.
  ///
  /// In fr, this message translates to:
  /// **'6 caractères minimum'**
  String get loginPasswordMin;

  /// No description provided for @loginForgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get loginForgotPassword;

  /// No description provided for @loginForgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get loginForgotPasswordTitle;

  /// No description provided for @loginForgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre email pour réinitialiser'**
  String get loginForgotPasswordSubtitle;

  /// No description provided for @loginForgotPasswordSent.
  ///
  /// In fr, this message translates to:
  /// **'Email de réinitialisation envoyé'**
  String get loginForgotPasswordSent;

  /// No description provided for @loginForgotPasswordError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'envoyer l\'email'**
  String get loginForgotPasswordError;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get loginOr;

  /// No description provided for @loginGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get loginGoogle;

  /// No description provided for @loginPhone.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec le numéro de téléphone'**
  String get loginPhone;

  /// No description provided for @loginNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? '**
  String get loginNoAccount;

  /// No description provided for @loginCreateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get loginCreateAccount;

  /// No description provided for @loginErrorInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect'**
  String get loginErrorInvalid;

  /// No description provided for @loginErrorFirebase.
  ///
  /// In fr, this message translates to:
  /// **'Connexion impossible pour le moment. Vérifiez votre configuration Firebase.'**
  String get loginErrorFirebase;

  /// No description provided for @loginGoogleCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Google annulée'**
  String get loginGoogleCancelled;

  /// No description provided for @loginGoogleError.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Google échouée. Le mode démo est actif pour prévisualiser le parcours.'**
  String get loginGoogleError;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerTitle;

  /// No description provided for @registerIAm.
  ///
  /// In fr, this message translates to:
  /// **'Je suis...'**
  String get registerIAm;

  /// No description provided for @registerTenant.
  ///
  /// In fr, this message translates to:
  /// **'Locataire'**
  String get registerTenant;

  /// No description provided for @registerOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get registerOwner;

  /// No description provided for @registerName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get registerName;

  /// No description provided for @registerNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Jean Dupont'**
  String get registerNameHint;

  /// No description provided for @registerNameError.
  ///
  /// In fr, this message translates to:
  /// **'Nom trop court'**
  String get registerNameError;

  /// No description provided for @registerEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get registerEmail;

  /// No description provided for @registerEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'votre@email.com'**
  String get registerEmailHint;

  /// No description provided for @registerEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get registerEmailError;

  /// No description provided for @registerPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get registerPassword;

  /// No description provided for @registerPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'••••••'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordMin.
  ///
  /// In fr, this message translates to:
  /// **'6 caractères minimum'**
  String get registerPasswordMin;

  /// No description provided for @registerPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get registerPhone;

  /// No description provided for @registerPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'6XX XXX XXX'**
  String get registerPhoneHint;

  /// No description provided for @registerPhonePrefix.
  ///
  /// In fr, this message translates to:
  /// **'+237 '**
  String get registerPhonePrefix;

  /// No description provided for @registerPhoneError.
  ///
  /// In fr, this message translates to:
  /// **'9 chiffres requis'**
  String get registerPhoneError;

  /// No description provided for @registerButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get registerButton;

  /// No description provided for @registerPhoneButton.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le code SMS'**
  String get registerPhoneButton;

  /// No description provided for @registerError.
  ///
  /// In fr, this message translates to:
  /// **'Inscription échouée. Vérifiez votre configuration Firebase ou continuez en mode démo.'**
  String get registerError;

  /// No description provided for @otpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification SMS'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Code de vérification'**
  String get otpSubtitle;

  /// No description provided for @otpSentTo.
  ///
  /// In fr, this message translates to:
  /// **'Nous avons envoyé un code SMS au\n{phone}'**
  String otpSentTo(String phone);

  /// No description provided for @otpVerify.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get otpVerify;

  /// No description provided for @otpResend.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get otpResend;

  /// No description provided for @otpError.
  ///
  /// In fr, this message translates to:
  /// **'Code incorrect. Réessayez.'**
  String get otpError;

  /// No description provided for @otpDefaultName.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get otpDefaultName;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name} 👋'**
  String homeGreeting(String name);

  /// No description provided for @homeSearchPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un quartier, une ville...'**
  String get homeSearchPlaceholder;

  /// No description provided for @homeSearchDouala.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher à Douala, Yaoundé...'**
  String get homeSearchDouala;

  /// No description provided for @homeResultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} logements trouvés'**
  String homeResultsCount(int count);

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAll;

  /// No description provided for @filterApartment.
  ///
  /// In fr, this message translates to:
  /// **'Appartement'**
  String get filterApartment;

  /// No description provided for @filterStudio.
  ///
  /// In fr, this message translates to:
  /// **'Studio'**
  String get filterStudio;

  /// No description provided for @filterVilla.
  ///
  /// In fr, this message translates to:
  /// **'Villa'**
  String get filterVilla;

  /// No description provided for @filterRoom.
  ///
  /// In fr, this message translates to:
  /// **'Chambre'**
  String get filterRoom;

  /// No description provided for @emptySearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get emptySearchTitle;

  /// No description provided for @emptySearchSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun logement ne correspond à \"{query}\". Essayez avec d\'autres mots-clés.'**
  String emptySearchSubtitle(String query);

  /// No description provided for @emptyPropertiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun logement trouvé'**
  String get emptyPropertiesTitle;

  /// No description provided for @emptyPropertiesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifiez vos filtres pour voir plus de résultats.'**
  String get emptyPropertiesSubtitle;

  /// No description provided for @mapSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher sur la carte...'**
  String get mapSearch;

  /// No description provided for @mapPropertiesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} logements'**
  String mapPropertiesCount(int count);

  /// No description provided for @mapView.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get mapView;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get navMap;

  /// No description provided for @navMessages.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Gestion'**
  String get navDashboard;

  /// No description provided for @navFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @propertyLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du logement...'**
  String get propertyLoading;

  /// No description provided for @propertyNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Logement introuvable'**
  String get propertyNotFound;

  /// No description provided for @propertyNotFoundSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce logement a peut-être été supprimé.'**
  String get propertyNotFoundSubtitle;

  /// No description provided for @propertyVirtualTour.
  ///
  /// In fr, this message translates to:
  /// **'Visite 360°'**
  String get propertyVirtualTour;

  /// No description provided for @propertyAvailable.
  ///
  /// In fr, this message translates to:
  /// **'✓ Disponible'**
  String get propertyAvailable;

  /// No description provided for @propertyOccupied.
  ///
  /// In fr, this message translates to:
  /// **'✗ Occupé'**
  String get propertyOccupied;

  /// No description provided for @propertyMonthlyRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer mensuel'**
  String get propertyMonthlyRent;

  /// No description provided for @propertyBedrooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get propertyBedrooms;

  /// No description provided for @propertyBathrooms.
  ///
  /// In fr, this message translates to:
  /// **'Salles de bain'**
  String get propertyBathrooms;

  /// No description provided for @propertySurface.
  ///
  /// In fr, this message translates to:
  /// **'m²'**
  String get propertySurface;

  /// No description provided for @propertyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get propertyDescription;

  /// No description provided for @propertyAmenities.
  ///
  /// In fr, this message translates to:
  /// **'Équipements'**
  String get propertyAmenities;

  /// No description provided for @propertyOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get propertyOwner;

  /// No description provided for @propertyReviews.
  ///
  /// In fr, this message translates to:
  /// **'Avis ({count})'**
  String propertyReviews(int count);

  /// No description provided for @propertyContact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get propertyContact;

  /// No description provided for @propertyReserveNow.
  ///
  /// In fr, this message translates to:
  /// **'Réserver maintenant'**
  String get propertyReserveNow;

  /// No description provided for @propertySendMessage.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer une demande'**
  String get propertySendMessage;

  /// No description provided for @virtualTourTitle.
  ///
  /// In fr, this message translates to:
  /// **'Visite virtuelle 360°'**
  String get virtualTourTitle;

  /// No description provided for @virtualTourPiece.
  ///
  /// In fr, this message translates to:
  /// **'Pièce {current} / {total}'**
  String virtualTourPiece(int current, int total);

  /// No description provided for @virtualTourSwipe.
  ///
  /// In fr, this message translates to:
  /// **'← Glissez pour naviguer →'**
  String get virtualTourSwipe;

  /// No description provided for @virtualTourLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement de la vue 360°...'**
  String get virtualTourLoading;

  /// No description provided for @virtualTourUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Visite 360° non disponible'**
  String get virtualTourUnavailable;

  /// No description provided for @virtualTourNoData.
  ///
  /// In fr, this message translates to:
  /// **'Ce logement n\'a pas encore de visite virtuelle.'**
  String get virtualTourNoData;

  /// No description provided for @virtualTourSeePhotos.
  ///
  /// In fr, this message translates to:
  /// **'Voir les photos'**
  String get virtualTourSeePhotos;

  /// No description provided for @filterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filterTitle;

  /// No description provided for @filterReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get filterReset;

  /// No description provided for @filterType.
  ///
  /// In fr, this message translates to:
  /// **'Type de logement'**
  String get filterType;

  /// No description provided for @filterCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get filterCity;

  /// No description provided for @filterBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget mensuel (FCFA)'**
  String get filterBudget;

  /// No description provided for @filterBedroomsMin.
  ///
  /// In fr, this message translates to:
  /// **'Chambres minimum'**
  String get filterBedroomsMin;

  /// No description provided for @filterApply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer les filtres'**
  String get filterApply;

  /// No description provided for @filterPriceRange.
  ///
  /// In fr, this message translates to:
  /// **'{min} FCFA'**
  String filterPriceRange(int min);

  /// No description provided for @bookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réserver ce logement'**
  String get bookingTitle;

  /// No description provided for @bookingNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Logement introuvable'**
  String get bookingNotFound;

  /// No description provided for @bookingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la réservation'**
  String get bookingError;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée !'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le propriétaire examinera votre demande et vous contactera.'**
  String get bookingSuccessSubtitle;

  /// No description provided for @bookingBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get bookingBackHome;

  /// No description provided for @bookingFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence de paiement'**
  String get bookingFrequency;

  /// No description provided for @bookingMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get bookingMonthly;

  /// No description provided for @bookingMonthlyPrice.
  ///
  /// In fr, this message translates to:
  /// **'{price} FCFA/mois'**
  String bookingMonthlyPrice(int price);

  /// No description provided for @bookingAnnual.
  ///
  /// In fr, this message translates to:
  /// **'Annuel'**
  String get bookingAnnual;

  /// No description provided for @bookingAnnualDiscount.
  ///
  /// In fr, this message translates to:
  /// **'-10% de réduction'**
  String get bookingAnnualDiscount;

  /// No description provided for @bookingMoveInDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'emménagement'**
  String get bookingMoveInDate;

  /// No description provided for @bookingMessage.
  ///
  /// In fr, this message translates to:
  /// **'Message au propriétaire (optionnel)'**
  String get bookingMessage;

  /// No description provided for @bookingMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Présentez-vous et expliquez votre situation...'**
  String get bookingMessageHint;

  /// No description provided for @bookingBaseRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer de base'**
  String get bookingBaseRent;

  /// No description provided for @bookingAnnualDiscountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Réduction annuelle'**
  String get bookingAnnualDiscountLabel;

  /// No description provided for @bookingTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total à payer'**
  String get bookingTotal;

  /// No description provided for @bookingPerYear.
  ///
  /// In fr, this message translates to:
  /// **'par an'**
  String get bookingPerYear;

  /// No description provided for @bookingPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'par mois'**
  String get bookingPerMonth;

  /// No description provided for @bookingContinuePayment.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers le paiement'**
  String get bookingContinuePayment;

  /// No description provided for @bookingSendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get bookingSendRequest;

  /// No description provided for @paymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get paymentTitle;

  /// No description provided for @paymentAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant à payer'**
  String get paymentAmount;

  /// No description provided for @paymentMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Paiement mensuel'**
  String get paymentMonthly;

  /// No description provided for @paymentAnnual.
  ///
  /// In fr, this message translates to:
  /// **'Paiement annuel'**
  String get paymentAnnual;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode de paiement'**
  String get paymentMethod;

  /// No description provided for @paymentMTN.
  ///
  /// In fr, this message translates to:
  /// **'MTN Mobile Money'**
  String get paymentMTN;

  /// No description provided for @paymentOrange.
  ///
  /// In fr, this message translates to:
  /// **'Orange Money'**
  String get paymentOrange;

  /// No description provided for @paymentCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte bancaire (Visa/MasterCard)'**
  String get paymentCard;

  /// No description provided for @paymentSecure.
  ///
  /// In fr, this message translates to:
  /// **'Paiement 100% sécurisé'**
  String get paymentSecure;

  /// No description provided for @paymentProcessing.
  ///
  /// In fr, this message translates to:
  /// **'Traitement en cours...'**
  String get paymentProcessing;

  /// No description provided for @paymentPay.
  ///
  /// In fr, this message translates to:
  /// **'Payer {amount} FCFA'**
  String paymentPay(int amount);

  /// No description provided for @paymentError.
  ///
  /// In fr, this message translates to:
  /// **'Paiement échoué. Réessayez.'**
  String get paymentError;

  /// No description provided for @paymentNumberMTN.
  ///
  /// In fr, this message translates to:
  /// **'Numéro MTN'**
  String get paymentNumberMTN;

  /// No description provided for @paymentNumberOrange.
  ///
  /// In fr, this message translates to:
  /// **'Numéro Orange'**
  String get paymentNumberOrange;

  /// No description provided for @paymentPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'6XX XXX XXX'**
  String get paymentPhoneHint;

  /// No description provided for @paymentPhonePrefix.
  ///
  /// In fr, this message translates to:
  /// **'+237 '**
  String get paymentPhonePrefix;

  /// No description provided for @paymentPhoneConfirmationMTN.
  ///
  /// In fr, this message translates to:
  /// **'Vous recevrez un message de confirmation MTN MoMo sur ce numéro.'**
  String get paymentPhoneConfirmationMTN;

  /// No description provided for @paymentPhoneConfirmationOrange.
  ///
  /// In fr, this message translates to:
  /// **'Vous recevrez un message de confirmation Orange Money sur ce numéro.'**
  String get paymentPhoneConfirmationOrange;

  /// No description provided for @paymentCardNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte'**
  String get paymentCardNumber;

  /// No description provided for @paymentCardHint.
  ///
  /// In fr, this message translates to:
  /// **'1234 5678 9012 3456'**
  String get paymentCardHint;

  /// No description provided for @paymentCardExpiry.
  ///
  /// In fr, this message translates to:
  /// **'Expiration'**
  String get paymentCardExpiry;

  /// No description provided for @paymentCardExpiryHint.
  ///
  /// In fr, this message translates to:
  /// **'MM/AA'**
  String get paymentCardExpiryHint;

  /// No description provided for @paymentCardCVV.
  ///
  /// In fr, this message translates to:
  /// **'CVV'**
  String get paymentCardCVV;

  /// No description provided for @paymentCardCVVHint.
  ///
  /// In fr, this message translates to:
  /// **'•••'**
  String get paymentCardCVVHint;

  /// No description provided for @contractTitle.
  ///
  /// In fr, this message translates to:
  /// **'Contrat de location'**
  String get contractTitle;

  /// No description provided for @contractSignedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Contrat signé !'**
  String get contractSignedTitle;

  /// No description provided for @contractSignedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations ! Votre contrat de location a été signé avec sucesso.'**
  String get contractSignedSubtitle;

  /// No description provided for @contractBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get contractBackHome;

  /// No description provided for @contractHeading.
  ///
  /// In fr, this message translates to:
  /// **'CONTRAT DE LOCATION'**
  String get contractHeading;

  /// No description provided for @contractBrand.
  ///
  /// In fr, this message translates to:
  /// **'LOKATE — {year}'**
  String contractBrand(int year);

  /// No description provided for @contractProperty.
  ///
  /// In fr, this message translates to:
  /// **'Bien loué'**
  String get contractProperty;

  /// No description provided for @contractStartDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de début'**
  String get contractStartDate;

  /// No description provided for @contractRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer'**
  String get contractRent;

  /// No description provided for @contractFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence'**
  String get contractFrequency;

  /// No description provided for @contractMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get contractMonthly;

  /// No description provided for @contractAnnual.
  ///
  /// In fr, this message translates to:
  /// **'Annuel'**
  String get contractAnnual;

  /// No description provided for @contractTerms.
  ///
  /// In fr, this message translates to:
  /// **'Conditions générales'**
  String get contractTerms;

  /// No description provided for @contractAccept.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai lu et j\'accepte les conditions générales du contrat de location.'**
  String get contractAccept;

  /// No description provided for @contractSign.
  ///
  /// In fr, this message translates to:
  /// **'Signer le contrat'**
  String get contractSign;

  /// No description provided for @contractArticle1Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 1 – OBJET DU CONTRAT'**
  String get contractArticle1Title;

  /// No description provided for @contractArticle1Body.
  ///
  /// In fr, this message translates to:
  /// **'Le présent contrat a pour objet la location d\'un logement situé au adresse indiquée dans la réservation, par le Locataire auprès du Propriétaire.'**
  String get contractArticle1Body;

  /// No description provided for @contractArticle2Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 2 – DURÉE'**
  String get contractArticle2Title;

  /// No description provided for @contractArticle2Body.
  ///
  /// In fr, this message translates to:
  /// **'Le contrat est conclu pour la durée indiquée dans la réservation, renouvelable par tacite reconduction sauf dénonciation par l\'une des parties avec un préavis de 30 jours.'**
  String get contractArticle2Body;

  /// No description provided for @contractArticle3Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 3 – LOYER'**
  String get contractArticle3Title;

  /// No description provided for @contractArticle3Body.
  ///
  /// In fr, this message translates to:
  /// **'Le montant du loyer est celui convenu lors de la réservation. Il est payable d\'avance, soit mensuellement soit annuellement selon l\'option choisie.'**
  String get contractArticle3Body;

  /// No description provided for @contractArticle4Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 4 – CHARGES'**
  String get contractArticle4Title;

  /// No description provided for @contractArticle4Body.
  ///
  /// In fr, this message translates to:
  /// **'Les charges locatives sont incluses dans le loyer sauf exception mentionnée explicitement. Les charges de consommation (eau, électricité) restent à la charge du locataire.'**
  String get contractArticle4Body;

  /// No description provided for @contractArticle5Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 5 – ÉTAT DES LIEUX'**
  String get contractArticle5Title;

  /// No description provided for @contractArticle5Body.
  ///
  /// In fr, this message translates to:
  /// **'Un état des lieux d\'entrée sera effectué le jour de la remise des clés. Le locataire s\'engage à restituer le logement en bon état.'**
  String get contractArticle5Body;

  /// No description provided for @contractArticle6Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 6 – RÉSILIATION'**
  String get contractArticle6Title;

  /// No description provided for @contractArticle6Body.
  ///
  /// In fr, this message translates to:
  /// **'Chaque partie peut résilier le contrat avec un préavis de 30 jours. En cas de non-paiement, le propriétaire peut résilier sans préavis.'**
  String get contractArticle6Body;

  /// No description provided for @contractArticle7Title.
  ///
  /// In fr, this message translates to:
  /// **'Article 7 – DROIT APPLICABLE'**
  String get contractArticle7Title;

  /// No description provided for @contractArticle7Body.
  ///
  /// In fr, this message translates to:
  /// **'Le présent contrat est régi par les lois de la République du Cameroun. Tout litige sera soumis aux tribunaux compétents de Douala.'**
  String get contractArticle7Body;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Contactez un propriétaire pour démarrer une conversation.'**
  String get chatEmptySubtitle;

  /// No description provided for @chatOnline.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get chatOnline;

  /// No description provided for @chatInputHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre message...'**
  String get chatInputHint;

  /// No description provided for @chatStartConversation.
  ///
  /// In fr, this message translates to:
  /// **'Démarrez la conversation'**
  String get chatStartConversation;

  /// No description provided for @chatSendMessageTo.
  ///
  /// In fr, this message translates to:
  /// **'Envoyez un message à {name}'**
  String chatSendMessageTo(String name);

  /// No description provided for @chatNow.
  ///
  /// In fr, this message translates to:
  /// **'maintenant'**
  String get chatNow;

  /// No description provided for @chatMinutesAgo.
  ///
  /// In fr, this message translates to:
  /// **'{minutes}min'**
  String chatMinutesAgo(int minutes);

  /// No description provided for @chatHoursAgo.
  ///
  /// In fr, this message translates to:
  /// **'{hours}h'**
  String chatHoursAgo(int hours);

  /// No description provided for @chatDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'{days}j'**
  String chatDaysAgo(int days);

  /// No description provided for @chatDefaultName.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get chatDefaultName;

  /// No description provided for @profileRating.
  ///
  /// In fr, this message translates to:
  /// **'{rating} ({count} avis)'**
  String profileRating(String rating, int count);

  /// No description provided for @profileMyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get profileMyAccount;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get profilePersonalInfo;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone : {phone}'**
  String profilePhone(String phone);

  /// No description provided for @profilePhoneNotSet.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get profilePhoneNotSet;

  /// No description provided for @profileRentalHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des locations'**
  String get profileRentalHistory;

  /// No description provided for @profilePreferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get profilePreferences;

  /// No description provided for @profileLightMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode clair'**
  String get profileLightMode;

  /// No description provided for @profileDarkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get profileDarkMode;

  /// No description provided for @profileLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue / Language'**
  String get profileLanguage;

  /// No description provided for @profileNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileSupport.
  ///
  /// In fr, this message translates to:
  /// **'Support'**
  String get profileSupport;

  /// No description provided for @profileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Centre d\'aide'**
  String get profileHelp;

  /// No description provided for @profilePrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get profilePrivacy;

  /// No description provided for @profileShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager LOKATE'**
  String get profileShare;

  /// No description provided for @profileAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos de LOKATE'**
  String get profileAbout;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get profileLogout;

  /// No description provided for @profileEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEditTitle;

  /// No description provided for @profileEditName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get profileEditName;

  /// No description provided for @profileEditNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre nom'**
  String get profileEditNameHint;

  /// No description provided for @profileEditSaved.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour !'**
  String get profileEditSaved;

  /// No description provided for @profileEditSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get profileEditSave;

  /// No description provided for @profileAboutText.
  ///
  /// In fr, this message translates to:
  /// **'Louez depuis chez vous avec visite virtuelle 360° et paiement Mobile Money.'**
  String get profileAboutText;

  /// No description provided for @profileClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get profileClose;

  /// No description provided for @reviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Laisser un avis'**
  String get reviewTitle;

  /// No description provided for @reviewExperience.
  ///
  /// In fr, this message translates to:
  /// **'Votre expérience'**
  String get reviewExperience;

  /// No description provided for @reviewHelpOthers.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis aide les autres utilisateurs à faire le bon choix.'**
  String get reviewHelpOthers;

  /// No description provided for @reviewComment.
  ///
  /// In fr, this message translates to:
  /// **'Votre commentaire'**
  String get reviewComment;

  /// No description provided for @reviewCommentHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre expérience avec ce logement / propriétaire...'**
  String get reviewCommentHint;

  /// No description provided for @reviewSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Publier mon avis'**
  String get reviewSubmit;

  /// No description provided for @reviewSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Avis publié avec succès !'**
  String get reviewSuccess;

  /// No description provided for @reviewError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la publication'**
  String get reviewError;

  /// No description provided for @reviewRatingVeryBad.
  ///
  /// In fr, this message translates to:
  /// **'Très mauvais'**
  String get reviewRatingVeryBad;

  /// No description provided for @reviewRatingBad.
  ///
  /// In fr, this message translates to:
  /// **'Mauvais'**
  String get reviewRatingBad;

  /// No description provided for @reviewRatingOk.
  ///
  /// In fr, this message translates to:
  /// **'Correct'**
  String get reviewRatingOk;

  /// No description provided for @reviewRatingGood.
  ///
  /// In fr, this message translates to:
  /// **'Bien'**
  String get reviewRatingGood;

  /// No description provided for @reviewRatingExcellent.
  ///
  /// In fr, this message translates to:
  /// **'Excellent !'**
  String get reviewRatingExcellent;

  /// No description provided for @dashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon tableau de bord'**
  String get dashboardTitle;

  /// No description provided for @dashboardAddProperty.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un bien'**
  String get dashboardAddProperty;

  /// No description provided for @dashboardLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement de vos biens...'**
  String get dashboardLoading;

  /// No description provided for @dashboardPublished.
  ///
  /// In fr, this message translates to:
  /// **'Biens publiés'**
  String get dashboardPublished;

  /// No description provided for @dashboardAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponibles'**
  String get dashboardAvailable;

  /// No description provided for @dashboardOccupied.
  ///
  /// In fr, this message translates to:
  /// **'Occupés'**
  String get dashboardOccupied;

  /// No description provided for @dashboardMyProperties.
  ///
  /// In fr, this message translates to:
  /// **'Mes logements'**
  String get dashboardMyProperties;

  /// No description provided for @dashboardRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes'**
  String get dashboardRequests;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun bien publié'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Publiez votre premier logement pour commencer à recevoir des demandes.'**
  String get dashboardEmptySubtitle;

  /// No description provided for @dashboardEmptyAction.
  ///
  /// In fr, this message translates to:
  /// **'Publier un bien'**
  String get dashboardEmptyAction;

  /// No description provided for @dashboardAvailableLabel.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get dashboardAvailableLabel;

  /// No description provided for @dashboardOccupiedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Occupé'**
  String get dashboardOccupiedLabel;

  /// No description provided for @dashboardMarkOccupied.
  ///
  /// In fr, this message translates to:
  /// **'Marqué comme occupé'**
  String get dashboardMarkOccupied;

  /// No description provided for @dashboardMarkAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Marqué comme disponible'**
  String get dashboardMarkAvailable;

  /// No description provided for @dashboardDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce bien ?'**
  String get dashboardDeleteTitle;

  /// No description provided for @dashboardDeleteSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Toutes les données seront perdues.'**
  String get dashboardDeleteSubtitle;

  /// No description provided for @dashboardCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get dashboardCancel;

  /// No description provided for @dashboardDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get dashboardDelete;

  /// No description provided for @dashboardDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Bien supprimé'**
  String get dashboardDeleted;

  /// No description provided for @dashboardEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get dashboardEdit;

  /// No description provided for @dashboardMarkOccupiedAction.
  ///
  /// In fr, this message translates to:
  /// **'Marquer occupé'**
  String get dashboardMarkOccupiedAction;

  /// No description provided for @dashboardMarkAvailableAction.
  ///
  /// In fr, this message translates to:
  /// **'Marquer disponible'**
  String get dashboardMarkAvailableAction;

  /// No description provided for @ownerReservationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de location'**
  String get ownerReservationsTitle;

  /// No description provided for @ownerReservationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande'**
  String get ownerReservationsEmpty;

  /// No description provided for @ownerStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get ownerStatusPending;

  /// No description provided for @ownerStatusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvée'**
  String get ownerStatusApproved;

  /// No description provided for @ownerStatusActive.
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get ownerStatusActive;

  /// No description provided for @ownerStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetée'**
  String get ownerStatusRejected;

  /// No description provided for @ownerStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get ownerStatusCompleted;

  /// No description provided for @ownerReject.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get ownerReject;

  /// No description provided for @ownerApprove.
  ///
  /// In fr, this message translates to:
  /// **'Approuver'**
  String get ownerApprove;

  /// No description provided for @ownerPricePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{price} FCFA / mois'**
  String ownerPricePerMonth(int price);

  /// No description provided for @ownerPricePerYear.
  ///
  /// In fr, this message translates to:
  /// **'{price} FCFA / an'**
  String ownerPricePerYear(int price);

  /// No description provided for @addPropertyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Publier un logement'**
  String get addPropertyTitle;

  /// No description provided for @addPropertyStep1.
  ///
  /// In fr, this message translates to:
  /// **'Informations générales'**
  String get addPropertyStep1;

  /// No description provided for @addPropertyStep1Of3.
  ///
  /// In fr, this message translates to:
  /// **'Étape 1 sur 3'**
  String get addPropertyStep1Of3;

  /// No description provided for @addPropertyTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre du bien'**
  String get addPropertyTitleLabel;

  /// No description provided for @addPropertyTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Bel appartement 3 pièces à Bonapriso'**
  String get addPropertyTitleHint;

  /// No description provided for @addPropertyTitleError.
  ///
  /// In fr, this message translates to:
  /// **'Titre trop court'**
  String get addPropertyTitleError;

  /// No description provided for @addPropertyType.
  ///
  /// In fr, this message translates to:
  /// **'Type de bien'**
  String get addPropertyType;

  /// No description provided for @addPropertyTypeApartment.
  ///
  /// In fr, this message translates to:
  /// **'Appartement'**
  String get addPropertyTypeApartment;

  /// No description provided for @addPropertyTypeStudio.
  ///
  /// In fr, this message translates to:
  /// **'Studio'**
  String get addPropertyTypeStudio;

  /// No description provided for @addPropertyTypeVilla.
  ///
  /// In fr, this message translates to:
  /// **'Villa'**
  String get addPropertyTypeVilla;

  /// No description provided for @addPropertyTypeRoom.
  ///
  /// In fr, this message translates to:
  /// **'Chambre'**
  String get addPropertyTypeRoom;

  /// No description provided for @addPropertyTypeOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get addPropertyTypeOther;

  /// No description provided for @addPropertyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get addPropertyDescription;

  /// No description provided for @addPropertyDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre logement en détail...'**
  String get addPropertyDescriptionHint;

  /// No description provided for @addPropertyDescriptionError.
  ///
  /// In fr, this message translates to:
  /// **'Description trop courte'**
  String get addPropertyDescriptionError;

  /// No description provided for @addPropertyStep2.
  ///
  /// In fr, this message translates to:
  /// **'Localisation & Prix'**
  String get addPropertyStep2;

  /// No description provided for @addPropertyStep2Of3.
  ///
  /// In fr, this message translates to:
  /// **'Étape 2 sur 3'**
  String get addPropertyStep2Of3;

  /// No description provided for @addPropertyCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get addPropertyCity;

  /// No description provided for @addPropertyDistrict.
  ///
  /// In fr, this message translates to:
  /// **'Quartier'**
  String get addPropertyDistrict;

  /// No description provided for @addPropertyDistrictHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Bonapriso, Akwa, Bastos...'**
  String get addPropertyDistrictHint;

  /// No description provided for @addPropertyAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse complète'**
  String get addPropertyAddress;

  /// No description provided for @addPropertyAddressHint.
  ///
  /// In fr, this message translates to:
  /// **'Rue, numéro...'**
  String get addPropertyAddressHint;

  /// No description provided for @addPropertyFieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get addPropertyFieldRequired;

  /// No description provided for @addPropertyRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer mensuel (FCFA)'**
  String get addPropertyRent;

  /// No description provided for @addPropertyRentHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 150000'**
  String get addPropertyRentHint;

  /// No description provided for @addPropertyRentError.
  ///
  /// In fr, this message translates to:
  /// **'Prix invalide'**
  String get addPropertyRentError;

  /// No description provided for @addPropertyBedrooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get addPropertyBedrooms;

  /// No description provided for @addPropertyBathrooms.
  ///
  /// In fr, this message translates to:
  /// **'Salles de bain'**
  String get addPropertyBathrooms;

  /// No description provided for @addPropertySurface.
  ///
  /// In fr, this message translates to:
  /// **'Surface (m²)'**
  String get addPropertySurface;

  /// No description provided for @addPropertySurfaceHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 80'**
  String get addPropertySurfaceHint;

  /// No description provided for @addPropertyBack.
  ///
  /// In fr, this message translates to:
  /// **'← Retour'**
  String get addPropertyBack;

  /// No description provided for @addPropertyNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant →'**
  String get addPropertyNext;

  /// No description provided for @addPropertyStep3.
  ///
  /// In fr, this message translates to:
  /// **'Photos & Équipements'**
  String get addPropertyStep3;

  /// No description provided for @addPropertyStep3Of3.
  ///
  /// In fr, this message translates to:
  /// **'Étape 3 sur 3'**
  String get addPropertyStep3Of3;

  /// No description provided for @addPropertyPhotos.
  ///
  /// In fr, this message translates to:
  /// **'Photos du logement'**
  String get addPropertyPhotos;

  /// No description provided for @addPropertyAddPhotos.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter des photos'**
  String get addPropertyAddPhotos;

  /// No description provided for @addPropertyAmenities.
  ///
  /// In fr, this message translates to:
  /// **'Équipements'**
  String get addPropertyAmenities;

  /// No description provided for @addPropertyReservationMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode de réservation'**
  String get addPropertyReservationMode;

  /// No description provided for @addPropertyImmediate.
  ///
  /// In fr, this message translates to:
  /// **'Réservation immédiate'**
  String get addPropertyImmediate;

  /// No description provided for @addPropertyApprovalRequired.
  ///
  /// In fr, this message translates to:
  /// **'Approbation requise'**
  String get addPropertyApprovalRequired;

  /// No description provided for @addPropertyImmediateDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les locataires peuvent réserver directement'**
  String get addPropertyImmediateDesc;

  /// No description provided for @addPropertyApprovalDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous approuvez chaque demande avant confirmation'**
  String get addPropertyApprovalDesc;

  /// No description provided for @addPropertyPublishing.
  ///
  /// In fr, this message translates to:
  /// **'Publication...'**
  String get addPropertyPublishing;

  /// No description provided for @addPropertyPublish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get addPropertyPublish;

  /// No description provided for @addPropertySuccess.
  ///
  /// In fr, this message translates to:
  /// **'Bien publié avec succès !'**
  String get addPropertySuccess;

  /// No description provided for @addPropertyError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la publication'**
  String get addPropertyError;

  /// No description provided for @amenityWifi.
  ///
  /// In fr, this message translates to:
  /// **'WiFi'**
  String get amenityWifi;

  /// No description provided for @amenityParking.
  ///
  /// In fr, this message translates to:
  /// **'Parking'**
  String get amenityParking;

  /// No description provided for @amenityAC.
  ///
  /// In fr, this message translates to:
  /// **'Climatisation'**
  String get amenityAC;

  /// No description provided for @amenityGuard.
  ///
  /// In fr, this message translates to:
  /// **'Gardien'**
  String get amenityGuard;

  /// No description provided for @amenityGenerator.
  ///
  /// In fr, this message translates to:
  /// **'Groupe électrogène'**
  String get amenityGenerator;

  /// No description provided for @amenityHotWater.
  ///
  /// In fr, this message translates to:
  /// **'Eau chaude'**
  String get amenityHotWater;

  /// No description provided for @amenityBalcony.
  ///
  /// In fr, this message translates to:
  /// **'Balcon'**
  String get amenityBalcony;

  /// No description provided for @amenityKitchen.
  ///
  /// In fr, this message translates to:
  /// **'Cuisine équipée'**
  String get amenityKitchen;

  /// No description provided for @amenityPool.
  ///
  /// In fr, this message translates to:
  /// **'Piscine'**
  String get amenityPool;

  /// No description provided for @editPropertyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le logement'**
  String get editPropertyTitle;

  /// No description provided for @editPropertySuccess.
  ///
  /// In fr, this message translates to:
  /// **'Logement mis à jour !'**
  String get editPropertySuccess;

  /// No description provided for @editPropertyError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la mise à jour'**
  String get editPropertyError;

  /// No description provided for @editPropertySave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les modifications'**
  String get editPropertySave;

  /// No description provided for @editPropertyAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get editPropertyAvailable;

  /// No description provided for @badgeVerified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifié'**
  String get badgeVerified;

  /// No description provided for @badgeCertified.
  ///
  /// In fr, this message translates to:
  /// **'Certifié'**
  String get badgeCertified;

  /// No description provided for @badgeTrusted.
  ///
  /// In fr, this message translates to:
  /// **'Fiable'**
  String get badgeTrusted;

  /// No description provided for @cardAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get cardAvailable;

  /// No description provided for @cardOccupied.
  ///
  /// In fr, this message translates to:
  /// **'Occupé'**
  String get cardOccupied;

  /// No description provided for @card360.
  ///
  /// In fr, this message translates to:
  /// **'360°'**
  String get card360;

  /// No description provided for @cardBedroomsShort.
  ///
  /// In fr, this message translates to:
  /// **'{count} ch.'**
  String cardBedroomsShort(int count);

  /// No description provided for @cardSurfaceShort.
  ///
  /// In fr, this message translates to:
  /// **'{surface} m²'**
  String cardSurfaceShort(int surface);

  /// No description provided for @emptyErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get emptyErrorTitle;

  /// No description provided for @emptyErrorSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre connexion internet et réessayez.'**
  String get emptyErrorSubtitle;

  /// No description provided for @emptyErrorRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get emptyErrorRetry;

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// No description provided for @commonSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get commonSearch;

  /// No description provided for @commonYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get commonNo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
