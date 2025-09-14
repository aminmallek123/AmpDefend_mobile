# Configuration Firebase Database

## Règles de Base de Données

Pour optimiser les performances et résoudre l'avertissement Firebase concernant l'index sur `uploaded_at`, vous devez appliquer les règles de base de données.

### Comment appliquer les règles :

1. **Via Firebase Console :**
   - Allez sur [Firebase Console](https://console.firebase.google.com)
   - Sélectionnez votre projet
   - Allez dans "Realtime Database" > "Règles"
   - Copiez-collez le contenu de `database.rules.json`
   - Cliquez sur "Publier"

2. **Via Firebase CLI :**
   ```bash
   firebase deploy --only database
   ```

### Index Configurés :

- **`uploaded_at`** : Pour les requêtes triées par date
- **`severity`** : Pour filtrer par niveau de sévérité
- **`alert_type`** : Pour filtrer par type d'alerte
- **`ip_address`** : Pour rechercher par adresse IP

### Sécurité :

- Lecture/Écriture uniquement pour les utilisateurs authentifiés
- Validation des champs obligatoires pour les alertes
- Protection des données utilisateurs

### Performance :

Avec ces index, vos requêtes Firebase seront optimisées et vous ne verrez plus l'avertissement :
```
Using an unspecified index. Consider adding '".indexOn": "uploaded_at"'
```

## Structure des Données

```json
{
  "alerts": {
    "alertId": {
      "alert_type": "intrusion",
      "severity": "critical",
      "ip_address": "192.168.1.100",
      "uploaded_at": "2025-09-14T10:30:00Z",
      "country": "France",
      "description": "Tentative d'intrusion détectée"
    }
  }
}
```