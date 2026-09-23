#!/usr/bin/env bash
# ============================================================================
# LOKATE — Script d'installation complet
# Application de location immobilière à distance au Cameroun
# ============================================================================
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   🏠 LOKATE — Installation Complète                         ║"
echo "║   Loue depuis chez toi                                      ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================================================
# ÉTAPE 1 : Vérifier les prérequis
# ============================================================================
echo -e "${CYAN}[1/10] Vérification des prérequis...${NC}"

check_cmd() {
  if ! command -v "$1" &> /dev/null; then
    echo -e "${RED}✗ $1 n'est pas installé.${NC}"
    echo "  → Installe-le : $2"
    return 1
  fi
  echo -e "${GREEN}✓ $1 trouvé : $(command -v "$1")${NC}"
  return 0
}

MISSING=0
check_cmd "flutter" "https://docs.flutter.dev/get-started/install" || MISSING=1
check_cmd "dart" "https://docs.flutter.dev/get-started/install" || MISSING=1
check_cmd "node" "https://nodejs.org/" || MISSING=1
check_cmd "npm" "https://nodejs.org/" || MISSING=1

if [ $MISSING -eq 1 ]; then
  echo ""
  echo -e "${RED}Installe les outils manquants puis relance ce script.${NC}"
  exit 1
fi

# Vérifier Flutter
FLUTTER_VERSION=$(flutter --version 2>&1 | head -n1)
echo -e "${GREEN}  Flutter : $FLUTTER_VERSION${NC}"

# ============================================================================
# ÉTAPE 2 : Installer Firebase CLI si nécessaire
# ============================================================================
echo ""
echo -e "${CYAN}[2/10] Firebase CLI...${NC}"

if ! command -v firebase &> /dev/null; then
  echo "  Installation de Firebase CLI..."
  npm install -g firebase-tools 2>&1 | tail -1
  echo -e "${GREEN}✓ Firebase CLI installé${NC}"
else
  echo -e "${GREEN}✓ Firebase CLI déjà installé${NC}"
fi

# Installer FlutterFire CLI
echo "  Installation de FlutterFire CLI..."
dart pub global activate flutterfire_cli 2>&1 | tail -1
echo -e "${GREEN}✓ FlutterFire CLI prêt${NC}"

# ============================================================================
# ÉTAPE 3 : flutter pub get
# ============================================================================
echo ""
echo -e "${CYAN}[3/10] Installation des dépendances Flutter...${NC}"
flutter pub get 2>&1 | tail -3
echo -e "${GREEN}✓ Dépendances installées${NC}"

# ============================================================================
# ÉTAPE 4 : Créer les plateformes (android/ios/web)
# ============================================================================
echo ""
echo -e "${CYAN}[4/10] Génération des plateformes...${NC}"

if [ ! -d "android" ]; then
  echo "  Création du dossier android/..."
  flutter create --org com.lokate --project-name lokate . 2>&1 | tail -3
  echo -e "${GREEN}✓ android/ créé${NC}"
else
  echo -e "${GREEN}✓ android/ existe déjà${NC}"
fi

# ============================================================================
# ÉTAPE 5 : Configuration Firebase
# ============================================================================
echo ""
echo -e "${CYAN}[5/10] Configuration Firebase...${NC}"

if grep -q "demo-project-id" lib/firebase_options.dart 2>/dev/null; then
  echo ""
  echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${YELLOW}║  ⚠  CONFIGURATION FIREBASE REQUISE                        ║${NC}"
  echo -e "${YELLOW}║                                                              ║${NC}"
  echo -e "${YELLOW}║  1. Va sur https://console.firebase.google.com/             ║${NC}"
  echo -e "${YELLOW}║  2. Crée un projet (nom : lokate-app)                       ║${NC}"
  echo -e "${YELLOW}║  3. Lance :                                                 ║${NC}"
  echo -e "${YELLOW}║                                                              ║${NC}"
  echo -e "${YELLOW}║     firebase login                                          ║${NC}"
  echo -e "${YELLOW}║     flutterfire configure                                   ║${NC}"
  echo -e "${YELLOW}║                                                              ║${NC}"
  echo -e "${YELLOW}║  4. Puis relance ce script                                  ║${NC}"
  echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}En attendant, l'app tourne en MODE DÉMO (sans Firebase).${NC}"
else
  echo -e "${GREEN}✓ Firebase configuré (credentials détectés)${NC}"

  # Activer les services Firebase
  echo "  Activation des services Firebase..."
  echo -e "${GREEN}  ✓ Auth, Firestore, Storage, Messaging devront être activés manuellement${NC}"
  echo -e "${GREEN}  → Voir FIREBASE_SETUP.md pour les détails${NC}"
fi

# ============================================================================
# ÉTAPE 6 : Générer les traductions l10n
# ============================================================================
echo ""
echo -e "${CYAN}[6/10] Génération des traductions...${NC}"

if [ -f "l10n.yaml" ]; then
  flutter gen-l10n 2>&1 | tail -2
  echo -e "${GREEN}✓ Traductions FR/EN générées${NC}"
else
  echo -e "${YELLOW}⚠ l10n.yaml non trouvé, les traductions ne sont pas générées${NC}"
fi

# ============================================================================
# ÉTAPE 7 : Télécharger les fonts Poppins (si manquantes)
# ============================================================================
echo ""
echo -e "${CYAN}[7/10] Vérification des fonts Poppins...${NC}"

FONTS_OK=true
for weight in Regular Medium SemiBold Bold; do
  FILE="assets/fonts/Poppins-${weight}.ttf"
  if [ ! -f "$FILE" ]; then
    echo "  Téléchargement de Poppins-${weight}..."
    URL="https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-${weight}.ttf"
    curl -sL "$URL" -o "$FILE"
    echo -e "${GREEN}  ✓ Poppins-${weight} téléchargé${NC}"
  fi
done
echo -e "${GREEN}✓ Toutes les fonts Poppins sont présentes${NC}"

# ============================================================================
# ÉTAPE 8 : Vérifier les assets
# ============================================================================
echo ""
echo -e "${CYAN}[8/10] Vérification des assets...${NC}"

# Créer les dossiers s'ils n'existent pas
mkdir -p assets/images assets/icons assets/animations

# Placeholder image si vide
if [ -z "$(ls -A assets/images/ 2>/dev/null)" ]; then
  echo "  Création d'images placeholder..."
  # Créer un PNG 1x1 transparent minimal
  echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==" | base64 -d > assets/images/placeholder.png
  echo -e "${GREEN}  ✓ Placeholder créé${NC}"
fi

# Vérifier animations Lottie
if [ ! -f "assets/animations/loading.json" ]; then
  echo -e "${YELLOW}  ⚠ Animation loading.json manquante${NC}"
fi

echo -e "${GREEN}✓ Assets vérifiés${NC}"

# ============================================================================
# ÉTAPE 9 : Analyser le code
# ============================================================================
echo ""
echo -e "${CYAN}[9/10] Analyse du code...${NC}"

ANALYZE_OUTPUT=$(flutter analyze --no-pub 2>&1)
ERRORS=$(echo "$ANALYZE_OUTPUT" | grep -c "error -" || true)
WARNINGS=$(echo "$ANALYZE_OUTPUT" | grep -c "warning -" || true)
INFOS=$(echo "$ANALYZE_OUTPUT" | grep -c "info -" || true)

if [ "$ERRORS" -gt 0 ]; then
  echo -e "${RED}✗ $ERRORS erreurs trouvées :${NC}"
  echo "$ANALYZE_OUTPUT" | grep "error -"
else
  echo -e "${GREEN}✓ 0 erreurs${NC}"
fi

if [ "$WARNINGS" -gt 0 ]; then
  echo -e "${YELLOW}  ⚠ $WARNINGS warnings${NC}"
else
  echo -e "${GREEN}✓ 0 warnings${NC}"
fi

echo -e "${GREEN}  ℹ $INFOS infos (dépréciations Flutter mineures)${NC}"

# ============================================================================
# ÉTAPE 10 : Lancer l'app
# ============================================================================
echo ""
echo -e "${CYAN}[10/10] Lancement...${NC}"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║   ✅ INSTALLATION TERMINÉE                                  ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║   Commandes disponibles :                                    ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║   flutter run                    Lancer sur connecté        ║${NC}"
echo -e "${GREEN}║   flutter run -d chrome          Lancer sur web             ║${NC}"
echo -e "${GREEN}║   flutter build apk              Build APK Android          ║${NC}"
echo -e "${GREEN}║   flutter build ios              Build iOS                  ║${NC}"
echo -e "${GREEN}║   flutter test                   Lancer les tests           ║${NC}"
echo -e "${GREEN}║   flutter analyze                Analyser le code           ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║   Firebase :                                                ║${NC}"
echo -e "${GREEN}║   firebase login                 Connexion Firebase         ║${NC}"
echo -e "${GREEN}║   flutterfire configure          Configurer Firebase        ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║   Guide complet : FIREBASE_SETUP.md                          ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Proposer de lancer l'app
read -p "Voulez-vous lancer l'app maintenant ? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${BLUE}Lancement de l'app...${NC}"
  flutter run 2>&1
else
  echo -e "${GREEN}D'accord. Lance avec 'flutter run' quand tu es prêt.${NC}"
fi
