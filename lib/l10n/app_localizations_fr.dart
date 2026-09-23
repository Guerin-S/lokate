// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LOKATE';

  @override
  String get appTagline => 'Loue depuis chez toi';

  @override
  String get onboardingTitle1 => 'Trouvez votre logement';

  @override
  String get onboardingSubtitle1 =>
      'Parcourez des centaines d\'appartements, studios et villas à Douala et Yaoundé depuis votre téléphone.';

  @override
  String get onboardingTitle2 => 'Visite virtuelle 360°';

  @override
  String get onboardingSubtitle2 =>
      'Visitez chaque pièce en détail sans bouger de chez vous grâce à notre galerie interactive 360°.';

  @override
  String get onboardingTitle3 => 'Payez en Mobile Money';

  @override
  String get onboardingSubtitle3 =>
      'MTN MoMo, Orange Money ou carte bancaire — choisissez le mode de paiement qui vous convient.';

  @override
  String get onboardingTitle4 => 'Signez en ligne';

  @override
  String get onboardingSubtitle4 =>
      'Contrat signé, clés récupérées — tout se fait sans paperasse inutile.';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get loginWelcomeBack => 'Bon retour 👋';

  @override
  String get loginSubtitle => 'Connectez-vous à votre compte';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginEmailHint => 'votre@email.com';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginPasswordMin => '6 caractères minimum';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginForgotPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get loginForgotPasswordSubtitle =>
      'Entrez votre email pour réinitialiser';

  @override
  String get loginForgotPasswordSent => 'Email de réinitialisation envoyé';

  @override
  String get loginForgotPasswordError => 'Impossible d\'envoyer l\'email';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginOr => 'ou';

  @override
  String get loginGoogle => 'Continuer avec Google';

  @override
  String get loginPhone => 'Continuer avec le numéro de téléphone';

  @override
  String get loginNoAccount => 'Pas encore de compte ? ';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String get loginErrorInvalid => 'Email ou mot de passe incorrect';

  @override
  String get loginErrorFirebase =>
      'Connexion impossible pour le moment. Vérifiez votre configuration Firebase.';

  @override
  String get loginGoogleCancelled => 'Connexion Google annulée';

  @override
  String get loginGoogleError =>
      'Connexion Google échouée. Le mode démo est actif pour prévisualiser le parcours.';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerIAm => 'Je suis...';

  @override
  String get registerTenant => 'Locataire';

  @override
  String get registerOwner => 'Propriétaire';

  @override
  String get registerName => 'Nom complet';

  @override
  String get registerNameHint => 'Jean Dupont';

  @override
  String get registerNameError => 'Nom trop court';

  @override
  String get registerEmail => 'Email';

  @override
  String get registerEmailHint => 'votre@email.com';

  @override
  String get registerEmailError => 'Email invalide';

  @override
  String get registerPassword => 'Mot de passe';

  @override
  String get registerPasswordHint => '••••••';

  @override
  String get registerPasswordMin => '6 caractères minimum';

  @override
  String get registerPhone => 'Numéro de téléphone';

  @override
  String get registerPhoneHint => '6XX XXX XXX';

  @override
  String get registerPhonePrefix => '+237 ';

  @override
  String get registerPhoneError => '9 chiffres requis';

  @override
  String get registerButton => 'Créer mon compte';

  @override
  String get registerPhoneButton => 'Envoyer le code SMS';

  @override
  String get registerError =>
      'Inscription échouée. Vérifiez votre configuration Firebase ou continuez en mode démo.';

  @override
  String get otpTitle => 'Vérification SMS';

  @override
  String get otpSubtitle => 'Code de vérification';

  @override
  String otpSentTo(String phone) {
    return 'Nous avons envoyé un code SMS au\n$phone';
  }

  @override
  String get otpVerify => 'Vérifier';

  @override
  String get otpResend => 'Renvoyer le code';

  @override
  String get otpError => 'Code incorrect. Réessayez.';

  @override
  String get otpDefaultName => 'Utilisateur';

  @override
  String homeGreeting(String name) {
    return 'Bonjour $name 👋';
  }

  @override
  String get homeSearchPlaceholder => 'Rechercher un quartier, une ville...';

  @override
  String get homeSearchDouala => 'Rechercher à Douala, Yaoundé...';

  @override
  String homeResultsCount(int count) {
    return '$count logements trouvés';
  }

  @override
  String get filterAll => 'Tous';

  @override
  String get filterApartment => 'Appartement';

  @override
  String get filterStudio => 'Studio';

  @override
  String get filterVilla => 'Villa';

  @override
  String get filterRoom => 'Chambre';

  @override
  String get emptySearchTitle => 'Aucun résultat';

  @override
  String emptySearchSubtitle(String query) {
    return 'Aucun logement ne correspond à \"$query\". Essayez avec d\'autres mots-clés.';
  }

  @override
  String get emptyPropertiesTitle => 'Aucun logement trouvé';

  @override
  String get emptyPropertiesSubtitle =>
      'Modifiez vos filtres pour voir plus de résultats.';

  @override
  String get mapSearch => 'Rechercher sur la carte...';

  @override
  String mapPropertiesCount(int count) {
    return '$count logements';
  }

  @override
  String get mapView => 'Voir';

  @override
  String get navHome => 'Accueil';

  @override
  String get navMap => 'Carte';

  @override
  String get navMessages => 'Messages';

  @override
  String get navDashboard => 'Gestion';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navProfile => 'Profil';

  @override
  String get propertyLoading => 'Chargement du logement...';

  @override
  String get propertyNotFound => 'Logement introuvable';

  @override
  String get propertyNotFoundSubtitle =>
      'Ce logement a peut-être été supprimé.';

  @override
  String get propertyVirtualTour => 'Visite 360°';

  @override
  String get propertyAvailable => '✓ Disponible';

  @override
  String get propertyOccupied => '✗ Occupé';

  @override
  String get propertyMonthlyRent => 'Loyer mensuel';

  @override
  String get propertyBedrooms => 'Chambres';

  @override
  String get propertyBathrooms => 'Salles de bain';

  @override
  String get propertySurface => 'm²';

  @override
  String get propertyDescription => 'Description';

  @override
  String get propertyAmenities => 'Équipements';

  @override
  String get propertyOwner => 'Propriétaire';

  @override
  String propertyReviews(int count) {
    return 'Avis ($count)';
  }

  @override
  String get propertyContact => 'Contacter';

  @override
  String get propertyReserveNow => 'Réserver maintenant';

  @override
  String get propertySendMessage => 'Envoyer une demande';

  @override
  String get virtualTourTitle => 'Visite virtuelle 360°';

  @override
  String virtualTourPiece(int current, int total) {
    return 'Pièce $current / $total';
  }

  @override
  String get virtualTourSwipe => '← Glissez pour naviguer →';

  @override
  String get virtualTourLoading => 'Chargement de la vue 360°...';

  @override
  String get virtualTourUnavailable => 'Visite 360° non disponible';

  @override
  String get virtualTourNoData =>
      'Ce logement n\'a pas encore de visite virtuelle.';

  @override
  String get virtualTourSeePhotos => 'Voir les photos';

  @override
  String get filterTitle => 'Filtres';

  @override
  String get filterReset => 'Réinitialiser';

  @override
  String get filterType => 'Type de logement';

  @override
  String get filterCity => 'Ville';

  @override
  String get filterBudget => 'Budget mensuel (FCFA)';

  @override
  String get filterBedroomsMin => 'Chambres minimum';

  @override
  String get filterApply => 'Appliquer les filtres';

  @override
  String filterPriceRange(int min) {
    return '$min FCFA';
  }

  @override
  String get bookingTitle => 'Réserver ce logement';

  @override
  String get bookingNotFound => 'Logement introuvable';

  @override
  String get bookingError => 'Erreur lors de la réservation';

  @override
  String get bookingSuccessTitle => 'Demande envoyée !';

  @override
  String get bookingSuccessSubtitle =>
      'Le propriétaire examinera votre demande et vous contactera.';

  @override
  String get bookingBackHome => 'Retour à l\'accueil';

  @override
  String get bookingFrequency => 'Fréquence de paiement';

  @override
  String get bookingMonthly => 'Mensuel';

  @override
  String bookingMonthlyPrice(int price) {
    return '$price FCFA/mois';
  }

  @override
  String get bookingAnnual => 'Annuel';

  @override
  String get bookingAnnualDiscount => '-10% de réduction';

  @override
  String get bookingMoveInDate => 'Date d\'emménagement';

  @override
  String get bookingMessage => 'Message au propriétaire (optionnel)';

  @override
  String get bookingMessageHint =>
      'Présentez-vous et expliquez votre situation...';

  @override
  String get bookingBaseRent => 'Loyer de base';

  @override
  String get bookingAnnualDiscountLabel => 'Réduction annuelle';

  @override
  String get bookingTotal => 'Total à payer';

  @override
  String get bookingPerYear => 'par an';

  @override
  String get bookingPerMonth => 'par mois';

  @override
  String get bookingContinuePayment => 'Continuer vers le paiement';

  @override
  String get bookingSendRequest => 'Envoyer la demande';

  @override
  String get paymentTitle => 'Paiement';

  @override
  String get paymentAmount => 'Montant à payer';

  @override
  String get paymentMonthly => 'Paiement mensuel';

  @override
  String get paymentAnnual => 'Paiement annuel';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get paymentMTN => 'MTN Mobile Money';

  @override
  String get paymentOrange => 'Orange Money';

  @override
  String get paymentCard => 'Carte bancaire (Visa/MasterCard)';

  @override
  String get paymentSecure => 'Paiement 100% sécurisé';

  @override
  String get paymentProcessing => 'Traitement en cours...';

  @override
  String paymentPay(int amount) {
    return 'Payer $amount FCFA';
  }

  @override
  String get paymentError => 'Paiement échoué. Réessayez.';

  @override
  String get paymentNumberMTN => 'Numéro MTN';

  @override
  String get paymentNumberOrange => 'Numéro Orange';

  @override
  String get paymentPhoneHint => '6XX XXX XXX';

  @override
  String get paymentPhonePrefix => '+237 ';

  @override
  String get paymentPhoneConfirmationMTN =>
      'Vous recevrez un message de confirmation MTN MoMo sur ce numéro.';

  @override
  String get paymentPhoneConfirmationOrange =>
      'Vous recevrez un message de confirmation Orange Money sur ce numéro.';

  @override
  String get paymentCardNumber => 'Numéro de carte';

  @override
  String get paymentCardHint => '1234 5678 9012 3456';

  @override
  String get paymentCardExpiry => 'Expiration';

  @override
  String get paymentCardExpiryHint => 'MM/AA';

  @override
  String get paymentCardCVV => 'CVV';

  @override
  String get paymentCardCVVHint => '•••';

  @override
  String get contractTitle => 'Contrat de location';

  @override
  String get contractSignedTitle => 'Contrat signé !';

  @override
  String get contractSignedSubtitle =>
      'Félicitations ! Votre contrat de location a été signé avec sucesso.';

  @override
  String get contractBackHome => 'Retour à l\'accueil';

  @override
  String get contractHeading => 'CONTRAT DE LOCATION';

  @override
  String contractBrand(int year) {
    return 'LOKATE — $year';
  }

  @override
  String get contractProperty => 'Bien loué';

  @override
  String get contractStartDate => 'Date de début';

  @override
  String get contractRent => 'Loyer';

  @override
  String get contractFrequency => 'Fréquence';

  @override
  String get contractMonthly => 'Mensuel';

  @override
  String get contractAnnual => 'Annuel';

  @override
  String get contractTerms => 'Conditions générales';

  @override
  String get contractAccept =>
      'J\'ai lu et j\'accepte les conditions générales du contrat de location.';

  @override
  String get contractSign => 'Signer le contrat';

  @override
  String get contractArticle1Title => 'Article 1 – OBJET DU CONTRAT';

  @override
  String get contractArticle1Body =>
      'Le présent contrat a pour objet la location d\'un logement situé au adresse indiquée dans la réservation, par le Locataire auprès du Propriétaire.';

  @override
  String get contractArticle2Title => 'Article 2 – DURÉE';

  @override
  String get contractArticle2Body =>
      'Le contrat est conclu pour la durée indiquée dans la réservation, renouvelable par tacite reconduction sauf dénonciation par l\'une des parties avec un préavis de 30 jours.';

  @override
  String get contractArticle3Title => 'Article 3 – LOYER';

  @override
  String get contractArticle3Body =>
      'Le montant du loyer est celui convenu lors de la réservation. Il est payable d\'avance, soit mensuellement soit annuellement selon l\'option choisie.';

  @override
  String get contractArticle4Title => 'Article 4 – CHARGES';

  @override
  String get contractArticle4Body =>
      'Les charges locatives sont incluses dans le loyer sauf exception mentionnée explicitement. Les charges de consommation (eau, électricité) restent à la charge du locataire.';

  @override
  String get contractArticle5Title => 'Article 5 – ÉTAT DES LIEUX';

  @override
  String get contractArticle5Body =>
      'Un état des lieux d\'entrée sera effectué le jour de la remise des clés. Le locataire s\'engage à restituer le logement en bon état.';

  @override
  String get contractArticle6Title => 'Article 6 – RÉSILIATION';

  @override
  String get contractArticle6Body =>
      'Chaque partie peut résilier le contrat avec un préavis de 30 jours. En cas de non-paiement, le propriétaire peut résilier sans préavis.';

  @override
  String get contractArticle7Title => 'Article 7 – DROIT APPLICABLE';

  @override
  String get contractArticle7Body =>
      'Le présent contrat est régi par les lois de la République du Cameroun. Tout litige sera soumis aux tribunaux compétents de Douala.';

  @override
  String get chatEmptyTitle => 'Aucun message';

  @override
  String get chatEmptySubtitle =>
      'Contactez un propriétaire pour démarrer une conversation.';

  @override
  String get chatOnline => 'En ligne';

  @override
  String get chatInputHint => 'Votre message...';

  @override
  String get chatStartConversation => 'Démarrez la conversation';

  @override
  String chatSendMessageTo(String name) {
    return 'Envoyez un message à $name';
  }

  @override
  String get chatNow => 'maintenant';

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
    return '${days}j';
  }

  @override
  String get chatDefaultName => 'Utilisateur';

  @override
  String profileRating(String rating, int count) {
    return '$rating ($count avis)';
  }

  @override
  String get profileMyAccount => 'Mon compte';

  @override
  String get profilePersonalInfo => 'Informations personnelles';

  @override
  String profilePhone(String phone) {
    return 'Téléphone : $phone';
  }

  @override
  String get profilePhoneNotSet => 'Non renseigné';

  @override
  String get profileRentalHistory => 'Historique des locations';

  @override
  String get profilePreferences => 'Préférences';

  @override
  String get profileLightMode => 'Mode clair';

  @override
  String get profileDarkMode => 'Mode sombre';

  @override
  String get profileLanguage => 'Langue / Language';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileSupport => 'Support';

  @override
  String get profileHelp => 'Centre d\'aide';

  @override
  String get profilePrivacy => 'Confidentialité';

  @override
  String get profileShare => 'Partager LOKATE';

  @override
  String get profileAbout => 'À propos de LOKATE';

  @override
  String get profileLogout => 'Se déconnecter';

  @override
  String get profileEditTitle => 'Modifier le profil';

  @override
  String get profileEditName => 'Nom complet';

  @override
  String get profileEditNameHint => 'Votre nom';

  @override
  String get profileEditSaved => 'Profil mis à jour !';

  @override
  String get profileEditSave => 'Enregistrer';

  @override
  String get profileAboutText =>
      'Louez depuis chez vous avec visite virtuelle 360° et paiement Mobile Money.';

  @override
  String get profileClose => 'Fermer';

  @override
  String get reviewTitle => 'Laisser un avis';

  @override
  String get reviewExperience => 'Votre expérience';

  @override
  String get reviewHelpOthers =>
      'Votre avis aide les autres utilisateurs à faire le bon choix.';

  @override
  String get reviewComment => 'Votre commentaire';

  @override
  String get reviewCommentHint =>
      'Décrivez votre expérience avec ce logement / propriétaire...';

  @override
  String get reviewSubmit => 'Publier mon avis';

  @override
  String get reviewSuccess => 'Avis publié avec succès !';

  @override
  String get reviewError => 'Erreur lors de la publication';

  @override
  String get reviewRatingVeryBad => 'Très mauvais';

  @override
  String get reviewRatingBad => 'Mauvais';

  @override
  String get reviewRatingOk => 'Correct';

  @override
  String get reviewRatingGood => 'Bien';

  @override
  String get reviewRatingExcellent => 'Excellent !';

  @override
  String get dashboardTitle => 'Mon tableau de bord';

  @override
  String get dashboardAddProperty => 'Ajouter un bien';

  @override
  String get dashboardLoading => 'Chargement de vos biens...';

  @override
  String get dashboardPublished => 'Biens publiés';

  @override
  String get dashboardAvailable => 'Disponibles';

  @override
  String get dashboardOccupied => 'Occupés';

  @override
  String get dashboardMyProperties => 'Mes logements';

  @override
  String get dashboardRequests => 'Demandes';

  @override
  String get dashboardEmptyTitle => 'Aucun bien publié';

  @override
  String get dashboardEmptySubtitle =>
      'Publiez votre premier logement pour commencer à recevoir des demandes.';

  @override
  String get dashboardEmptyAction => 'Publier un bien';

  @override
  String get dashboardAvailableLabel => 'Disponible';

  @override
  String get dashboardOccupiedLabel => 'Occupé';

  @override
  String get dashboardMarkOccupied => 'Marqué comme occupé';

  @override
  String get dashboardMarkAvailable => 'Marqué comme disponible';

  @override
  String get dashboardDeleteTitle => 'Supprimer ce bien ?';

  @override
  String get dashboardDeleteSubtitle =>
      'Cette action est irréversible. Toutes les données seront perdues.';

  @override
  String get dashboardCancel => 'Annuler';

  @override
  String get dashboardDelete => 'Supprimer';

  @override
  String get dashboardDeleted => 'Bien supprimé';

  @override
  String get dashboardEdit => 'Modifier';

  @override
  String get dashboardMarkOccupiedAction => 'Marquer occupé';

  @override
  String get dashboardMarkAvailableAction => 'Marquer disponible';

  @override
  String get ownerReservationsTitle => 'Demandes de location';

  @override
  String get ownerReservationsEmpty => 'Aucune demande';

  @override
  String get ownerStatusPending => 'En attente';

  @override
  String get ownerStatusApproved => 'Approuvée';

  @override
  String get ownerStatusActive => 'Active';

  @override
  String get ownerStatusRejected => 'Rejetée';

  @override
  String get ownerStatusCompleted => 'Terminée';

  @override
  String get ownerReject => 'Refuser';

  @override
  String get ownerApprove => 'Approuver';

  @override
  String ownerPricePerMonth(int price) {
    return '$price FCFA / mois';
  }

  @override
  String ownerPricePerYear(int price) {
    return '$price FCFA / an';
  }

  @override
  String get addPropertyTitle => 'Publier un logement';

  @override
  String get addPropertyStep1 => 'Informations générales';

  @override
  String get addPropertyStep1Of3 => 'Étape 1 sur 3';

  @override
  String get addPropertyTitleLabel => 'Titre du bien';

  @override
  String get addPropertyTitleHint => 'Ex: Bel appartement 3 pièces à Bonapriso';

  @override
  String get addPropertyTitleError => 'Titre trop court';

  @override
  String get addPropertyType => 'Type de bien';

  @override
  String get addPropertyTypeApartment => 'Appartement';

  @override
  String get addPropertyTypeStudio => 'Studio';

  @override
  String get addPropertyTypeVilla => 'Villa';

  @override
  String get addPropertyTypeRoom => 'Chambre';

  @override
  String get addPropertyTypeOther => 'Autre';

  @override
  String get addPropertyDescription => 'Description';

  @override
  String get addPropertyDescriptionHint =>
      'Décrivez votre logement en détail...';

  @override
  String get addPropertyDescriptionError => 'Description trop courte';

  @override
  String get addPropertyStep2 => 'Localisation & Prix';

  @override
  String get addPropertyStep2Of3 => 'Étape 2 sur 3';

  @override
  String get addPropertyCity => 'Ville';

  @override
  String get addPropertyDistrict => 'Quartier';

  @override
  String get addPropertyDistrictHint => 'Ex: Bonapriso, Akwa, Bastos...';

  @override
  String get addPropertyAddress => 'Adresse complète';

  @override
  String get addPropertyAddressHint => 'Rue, numéro...';

  @override
  String get addPropertyFieldRequired => 'Champ requis';

  @override
  String get addPropertyRent => 'Loyer mensuel (FCFA)';

  @override
  String get addPropertyRentHint => 'Ex: 150000';

  @override
  String get addPropertyRentError => 'Prix invalide';

  @override
  String get addPropertyBedrooms => 'Chambres';

  @override
  String get addPropertyBathrooms => 'Salles de bain';

  @override
  String get addPropertySurface => 'Surface (m²)';

  @override
  String get addPropertySurfaceHint => 'Ex: 80';

  @override
  String get addPropertyBack => '← Retour';

  @override
  String get addPropertyNext => 'Suivant →';

  @override
  String get addPropertyStep3 => 'Photos & Équipements';

  @override
  String get addPropertyStep3Of3 => 'Étape 3 sur 3';

  @override
  String get addPropertyPhotos => 'Photos du logement';

  @override
  String get addPropertyAddPhotos => 'Ajouter des photos';

  @override
  String get addPropertyAmenities => 'Équipements';

  @override
  String get addPropertyReservationMode => 'Mode de réservation';

  @override
  String get addPropertyImmediate => 'Réservation immédiate';

  @override
  String get addPropertyApprovalRequired => 'Approbation requise';

  @override
  String get addPropertyImmediateDesc =>
      'Les locataires peuvent réserver directement';

  @override
  String get addPropertyApprovalDesc =>
      'Vous approuvez chaque demande avant confirmation';

  @override
  String get addPropertyPublishing => 'Publication...';

  @override
  String get addPropertyPublish => 'Publier';

  @override
  String get addPropertySuccess => 'Bien publié avec succès !';

  @override
  String get addPropertyError => 'Erreur lors de la publication';

  @override
  String get amenityWifi => 'WiFi';

  @override
  String get amenityParking => 'Parking';

  @override
  String get amenityAC => 'Climatisation';

  @override
  String get amenityGuard => 'Gardien';

  @override
  String get amenityGenerator => 'Groupe électrogène';

  @override
  String get amenityHotWater => 'Eau chaude';

  @override
  String get amenityBalcony => 'Balcon';

  @override
  String get amenityKitchen => 'Cuisine équipée';

  @override
  String get amenityPool => 'Piscine';

  @override
  String get editPropertyTitle => 'Modifier le logement';

  @override
  String get editPropertySuccess => 'Logement mis à jour !';

  @override
  String get editPropertyError => 'Erreur lors de la mise à jour';

  @override
  String get editPropertySave => 'Enregistrer les modifications';

  @override
  String get editPropertyAvailable => 'Disponible';

  @override
  String get badgeVerified => 'Vérifié';

  @override
  String get badgeCertified => 'Certifié';

  @override
  String get badgeTrusted => 'Fiable';

  @override
  String get cardAvailable => 'Disponible';

  @override
  String get cardOccupied => 'Occupé';

  @override
  String get card360 => '360°';

  @override
  String cardBedroomsShort(int count) {
    return '$count ch.';
  }

  @override
  String cardSurfaceShort(int surface) {
    return '$surface m²';
  }

  @override
  String get emptyErrorTitle => 'Une erreur est survenue';

  @override
  String get emptyErrorSubtitle =>
      'Vérifiez votre connexion internet et réessayez.';

  @override
  String get emptyErrorRetry => 'Réessayer';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';
}
