# Vérification Configuration Firebase Database
Write-Host "🔥 Vérification Configuration Firebase Database" -ForegroundColor Cyan
Write-Host "=============================================="
Write-Host ""

# Vérifier si Firebase CLI est installé
$firebaseExists = Get-Command firebase -ErrorAction SilentlyContinue
if ($firebaseExists) {
    Write-Host "✅ Firebase CLI est installé" -ForegroundColor Green
    
    # Vérifier la connexion
    try {
        $projects = firebase projects:list 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Connecté à Firebase" -ForegroundColor Green
            
            # Afficher le projet actuel
            Write-Host "📊 Projet actuel:"
            firebase use
            
            Write-Host ""
            Write-Host "🚀 Pour appliquer les règles de base de données:" -ForegroundColor Yellow
            Write-Host "   firebase deploy --only database" -ForegroundColor White
            
        } else {
            Write-Host "❌ Non connecté à Firebase" -ForegroundColor Red
            Write-Host "   Utilisez: firebase login" -ForegroundColor White
        }
    } catch {
        Write-Host "❌ Erreur de connexion Firebase" -ForegroundColor Red
    }
    
} else {
    Write-Host "❌ Firebase CLI non installé" -ForegroundColor Red
    Write-Host "   Installez avec: npm install -g firebase-tools" -ForegroundColor White
}

Write-Host ""
Write-Host "📋 Alternative: Configuration via Console Web" -ForegroundColor Magenta
Write-Host "   1. Allez sur https://console.firebase.google.com"
Write-Host "   2. Sélectionnez votre projet"
Write-Host "   3. Realtime Database > Règles"
Write-Host "   4. Copiez le contenu de database.rules.json"
Write-Host "   5. Publiez les règles"

Write-Host ""
Write-Host "🎯 Résultat attendu: Plus d'avertissement 'Using an unspecified index'" -ForegroundColor Green

# Vérifier si le fichier de règles existe
if (Test-Path "database.rules.json") {
    Write-Host ""
    Write-Host "📄 Contenu à copier dans Firebase Console:" -ForegroundColor Yellow
    Get-Content "database.rules.json" | Write-Host -ForegroundColor White
}