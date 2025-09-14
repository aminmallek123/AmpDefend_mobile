#!/bin/bash

echo "🔥 Vérification Configuration Firebase Database"
echo "=============================================="
echo ""

# Vérifier si Firebase CLI est installé
if command -v firebase &> /dev/null; then
    echo "✅ Firebase CLI est installé"
    
    # Vérifier la connexion
    if firebase projects:list &> /dev/null; then
        echo "✅ Connecté à Firebase"
        
        # Afficher le projet actuel
        echo "📊 Projet actuel:"
        firebase use
        
        echo ""
        echo "🚀 Pour appliquer les règles de base de données:"
        echo "   firebase deploy --only database"
        
    else
        echo "❌ Non connecté à Firebase"
        echo "   Utilisez: firebase login"
    fi
    
else
    echo "❌ Firebase CLI non installé"
    echo "   Installez avec: npm install -g firebase-tools"
fi

echo ""
echo "📋 Alternative: Configuration via Console Web"
echo "   1. Allez sur https://console.firebase.google.com"
echo "   2. Sélectionnez votre projet"
echo "   3. Realtime Database > Règles"
echo "   4. Copiez le contenu de database.rules.json"
echo "   5. Publiez les règles"

echo ""
echo "🎯 Résultat attendu: Plus d'avertissement 'Using an unspecified index'"