@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================================
:: LOKATE — Script d'installation complet (Windows)
:: Application de location immobilière à distance au Cameroun
:: ============================================================================

title LOKATE - Installation

echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║   🏠 LOKATE — Installation Complète                         ║
echo  ║   Loue depuis chez toi                                      ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.

:: ============================================================================
:: ÉTAPE 1 : Vérifier les prérequis
:: ============================================================================
echo [1/10] Verification des prerequis...

where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo  ✗ Flutter n'est pas installe.
    echo    → https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)
echo  ✓ Flutter trouve

where dart >nul 2>&1
if %errorlevel% neq 0 (
    echo  ✗ Dart n'est pas installe.
    pause
    exit /b 1
)
echo  ✓ Dart trouve

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo  ⚠ Node.js non trouve (recommande pour Firebase CLI)
)

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo  ⚠ npm non trouve (recommande pour Firebase CLI)
)

:: ============================================================================
:: ÉTAPE 2 : Installer Firebase CLI
:: ============================================================================
echo.
echo [2/10] Firebase CLI...

where firebase >nul 2>&1
if %errorlevel% neq 0 (
    echo  Installation de Firebase CLI...
    call npm install -g firebase-tools
    echo  ✓ Firebase CLI installe
) else (
    echo  ✓ Firebase CLI deja installe
)

echo  Installation de FlutterFire CLI...
call dart pub global activate flutterfire_cli
echo  ✓ FlutterFire CLI pret

:: ============================================================================
:: ÉTAPE 3 : flutter pub get
:: ============================================================================
echo.
echo [3/10] Installation des dependances Flutter...
call flutter pub get
echo  ✓ Dependances installees

:: ============================================================================
:: ÉTAPE 4 : Creer les plateformes
:: ============================================================================
echo.
echo [4/10] Generation des plateformes...

if not exist "android" (
    echo  Creation du dossier android/...
    call flutter create --org com.lokate --project-name lokate .
    echo  ✓ android/ cree
) else (
    echo  ✓ android/ existe deja
)

:: ============================================================================
:: ÉTAPE 5 : Configuration Firebase
:: ============================================================================
echo.
echo [5/10] Configuration Firebase...

findstr /C:"demo-project-id" lib\firebase_options.dart >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo  ╔══════════════════════════════════════════════════════════════╗
    echo  ║  ⚠  CONFIGURATION FIREBASE REQUISE                        ║
    echo  ║                                                              ║
    echo  ║  1. Va sur https://console.firebase.google.com/             ║
    echo  ║  2. Cree un projet (nom : lokate-app)                       ║
    echo  ║  3. Lance :                                                 ║
    echo  ║                                                              ║
    echo  ║     firebase login                                          ║
    echo  ║     flutterfire configure                                   ║
    echo  ║                                                              ║
    echo  ║  4. Puis relance ce script                                  ║
    echo  ║                                                              ║
    echo  ╚══════════════════════════════════════════════════════════════╝
    echo.
    echo  En attendant, l'app tourne en MODE DEMO (sans Firebase).
) else (
    echo  ✓ Firebase configure (credentials detectes)
    echo  → Voir FIREBASE_SETUP.md pour activer les services
)

:: ============================================================================
:: ÉTAPE 6 : Generer les traductions
:: ============================================================================
echo.
echo [6/10] Generation des traductions...

if exist "l10n.yaml" (
    call flutter gen-l10n
    echo  ✓ Traductions FR/EN generees
) else (
    echo  ⚠ l10n.yaml non trouve
)

:: ============================================================================
:: ÉTAPE 7 : Verifier les fonts
:: ============================================================================
echo.
echo [7/10] Verification des fonts Poppins...

if not exist "assets\fonts" mkdir "assets\fonts"

for %%w in (Regular Medium SemiBold Bold) do (
    if not exist "assets\fonts\Poppins-%%w.ttf" (
        echo  Telechargement de Poppins-%%w...
        curl -sL "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-%%w.ttf" -o "assets\fonts\Poppins-%%w.ttf"
        echo  ✓ Poppins-%%w telecharge
    )
)
echo  ✓ Toutes les fonts Poppins sont presentes

:: ============================================================================
:: ÉTAPE 8 : Verifier les assets
:: ============================================================================
echo.
echo [8/10] Verification des assets...

if not exist "assets\images" mkdir "assets\images"
if not exist "assets\icons" mkdir "assets\icons"
if not exist "assets\animations" mkdir "assets\animations"

echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==> temp_b64.txt
certutil -decode temp_b64.txt "assets\images\placeholder.png" >nul 2>&1
del temp_b64.txt >nul 2>&1
echo  ✓ Assets verifies

:: ============================================================================
:: ÉTAPE 9 : Analyser le code
:: ============================================================================
echo.
echo [9/10] Analyse du code...

call flutter analyze --no-pub
echo.

:: ============================================================================
:: ÉTAPE 10 : Fin
:: ============================================================================
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║   ✅ INSTALLATION TERMINEE                                  ║
echo  ║                                                              ║
echo  ║   Commandes disponibles :                                    ║
echo  ║                                                              ║
echo  ║   flutter run                    Lancer sur connecte        ║
echo  ║   flutter run -d chrome          Lancer sur web             ║
echo  ║   flutter build apk              Build APK Android          ║
echo  ║   flutter build ios              Build iOS                  ║
echo  ║   flutter test                   Lancer les tests           ║
echo  ║   flutter analyze                Analyser le code           ║
echo  ║                                                              ║
echo  ║   Guide complet : FIREBASE_SETUP.md                          ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.

set /p LAUNCH="Voulez-vous lancer l'app maintenant ? (y/n) "
if /i "%LAUNCH%"=="y" (
    echo Lancement de l'app...
    call flutter run
) else (
    echo D'accord. Lance avec 'flutter run' quand tu es pret.
)

pause
