# Plan d'implémentation des fonctionnalités manquantes - rtodoist

## État actuel du package (v0.3)

### Fonctionnalités implémentées
- **Projets** : création, liste, récupération par nom
- **Tasks** : création, mise à jour, liste, assignation, dates d'échéance, sections
- **Sections** : création, liste, récupération par nom
- **Utilisateurs/Collaboration** : liste des collaborateurs, ajout d'utilisateurs aux projets
- **Token** : gestion sécurisée via keyring

---

## Fonctionnalités manquantes (par priorité)

### Priorité 1 - Fonctionnalités essentielles

#### 1.1 Labels (Étiquettes)
Aucune fonction label n'existe actuellement.

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `add_label()` | `label_add` | Créer une étiquette |
| `get_all_labels()` | GET `/labels` | Récupérer toutes les étiquettes |
| `get_label()` | GET `/labels/{id}` | Récupérer une étiquette |
| `update_label()` | `label_update` | Modifier une étiquette |
| `delete_label()` | `label_delete` | Supprimer une étiquette |
| `get_shared_labels()` | GET `/labels/shared` | Étiquettes partagées du workspace |

**Fichier à créer** : `R/labels.R`

#### 1.2 Comments (Commentaires)
Aucune fonction commentaire n'existe.

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `add_comment()` | `note_add` | Ajouter un commentaire à une tâche/projet |
| `get_comments()` | GET `/comments` | Récupérer les commentaires |
| `get_comment()` | GET `/comments/{id}` | Récupérer un commentaire |
| `update_comment()` | `note_update` | Modifier un commentaire |
| `delete_comment()` | `note_delete` | Supprimer un commentaire |

**Fichier à créer** : `R/comments.R`

#### 1.3 Opérations CRUD manquantes sur les ressources existantes

**Projets** (`R/projects.R`) :
| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `update_project()` | `project_update` | Modifier un projet |
| `delete_project()` | `project_delete` | Supprimer un projet |
| `archive_project()` | `project_archive` | Archiver un projet |
| `unarchive_project()` | `project_unarchive` | Désarchiver un projet |
| `get_archived_projects()` | GET `/projects/archived` | Liste des projets archivés |

**Tasks** (`R/tasks.R`) :
| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `delete_task()` | `item_delete` | Supprimer une tâche |
| `close_task()` | `item_close` | Marquer comme terminée |
| `reopen_task()` | `item_uncomplete` | Réouvrir une tâche |
| `move_task()` | `item_move` | Déplacer vers un autre projet/section |
| `get_completed_tasks()` | GET `/tasks/completed/by_completion_date` | Tâches terminées |
| `quick_add_task()` | POST `/tasks/quick` | Ajout en langage naturel |

**Sections** (`R/section.R`) :
| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `update_section()` | `section_update` | Modifier une section |
| `delete_section()` | `section_delete` | Supprimer une section |
| `move_section()` | `section_move` | Déplacer une section |
| `archive_section()` | `section_archive` | Archiver une section |

---

### Priorité 2 - Fonctionnalités avancées

#### 2.1 Reminders (Rappels)

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `add_reminder()` | `reminder_add` | Ajouter un rappel |
| `update_reminder()` | `reminder_update` | Modifier un rappel |
| `delete_reminder()` | `reminder_delete` | Supprimer un rappel |
| `get_reminders()` | Sync API | Récupérer tous les rappels |

**Fichier à créer** : `R/reminders.R`

#### 2.2 Filters (Filtres personnalisés)

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `add_filter()` | `filter_add` | Créer un filtre |
| `get_all_filters()` | GET `/filters` | Récupérer les filtres |
| `update_filter()` | `filter_update` | Modifier un filtre |
| `delete_filter()` | `filter_delete` | Supprimer un filtre |
| `get_tasks_by_filter()` | GET `/tasks/filter` | Tâches selon un filtre |

**Fichier à créer** : `R/filters.R`

#### 2.3 User Management étendu

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `get_user_info()` | Sync (user) | Informations utilisateur |
| `update_user()` | `user_update` | Modifier profil |
| `get_productivity_stats()` | Sync (stats) | Statistiques de productivité |

**Fichier à modifier** : `R/users.R`

#### 2.4 Collaboration étendue

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `delete_collaborator()` | `collaborator_delete` | Retirer un collaborateur |
| `accept_invitation()` | PUT `/invitations/{id}/accept` | Accepter une invitation |
| `reject_invitation()` | PUT `/invitations/{id}/reject` | Refuser une invitation |
| `get_project_permissions()` | GET `/projects/{id}/permissions` | Permissions d'un projet |

**Fichier à modifier** : `R/users.R`

---

### Priorité 3 - Fonctionnalités entreprise/avancées

#### 3.1 Workspaces

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `add_workspace()` | `workspace_add` | Créer un workspace |
| `update_workspace()` | `workspace_update` | Modifier un workspace |
| `leave_workspace()` | `workspace_leave` | Quitter un workspace |
| `delete_workspace()` | `workspace_delete` | Supprimer un workspace |
| `get_workspace_users()` | Sync (workspace_users) | Membres du workspace |
| `invite_to_workspace()` | `workspace_invite` | Inviter au workspace |

**Fichier à créer** : `R/workspaces.R`

#### 3.2 Activity Logs

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `get_activity_logs()` | GET `/activity_logs` | Journal d'activité |

**Fichier à créer** : `R/activity.R`

#### 3.3 Templates

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `import_template()` | POST `/templates/import_into_project` | Importer un template |
| `export_template()` | GET `/templates/export_as_file` | Exporter en template |

**Fichier à créer** : `R/templates.R`

#### 3.4 Backups

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `get_backups()` | GET `/backups` | Liste des backups |
| `download_backup()` | GET `/backups/{id}/download` | Télécharger un backup |

**Fichier à créer** : `R/backups.R`

#### 3.5 Uploads (Pièces jointes)

| Fonction à créer | Endpoint API | Description |
|------------------|--------------|-------------|
| `upload_file()` | POST `/uploads` | Uploader un fichier |
| `delete_upload()` | DELETE `/uploads/{id}` | Supprimer un upload |

**Fichier à créer** : `R/uploads.R`

---

## Plan d'exécution recommandé

### Phase 1 : Compléter les CRUD existants (1-2 semaines)
1. Ajouter `update_project()`, `delete_project()`, `archive_project()` dans `projects.R`
2. Ajouter `delete_task()`, `close_task()`, `reopen_task()`, `move_task()` dans `tasks.R`
3. Ajouter `update_section()`, `delete_section()` dans `section.R`
4. Tests unitaires pour chaque nouvelle fonction

### Phase 2 : Labels et Comments (1-2 semaines)
1. Créer `R/labels.R` avec toutes les fonctions CRUD
2. Créer `R/comments.R` avec toutes les fonctions CRUD
3. Mettre à jour NAMESPACE et documentation
4. Tests unitaires

### Phase 3 : Fonctionnalités avancées des tâches (1 semaine)
1. `get_completed_tasks()` avec pagination
2. `quick_add_task()` pour l'ajout en langage naturel
3. `get_tasks_by_filter()` pour les filtres personnalisés

### Phase 4 : Reminders et Filters (1-2 semaines)
1. Créer `R/reminders.R`
2. Créer `R/filters.R`
3. Tests et documentation

### Phase 5 : User Management et Collaboration avancée (1 semaine)
1. Étendre `R/users.R` avec les nouvelles fonctions
2. Gestion des invitations
3. Statistiques de productivité

### Phase 6 : Fonctionnalités entreprise (2-3 semaines)
1. Workspaces (si besoin)
2. Activity logs
3. Templates
4. Backups
5. Uploads

---

## Considérations techniques

### Patterns à suivre (cohérence avec le code existant)
```r
# Pattern pour les fonctions CRUD
add_xxx <- function(name, ..., verbose = TRUE, token = get_todoist_api_token()) {
  # Validation des paramètres
  # Appel API via call_api() ou call_api_rest()
  # Gestion du verbose
  # Retour de l'ID créé
}

# Pattern pour les fonctions de récupération
get_all_xxx <- function(token = get_todoist_api_token()) {
  # Appel API avec pagination si nécessaire
  # Transformation en tibble
  # Retour des données
}
```

### Fonctions utilitaires à réutiliser
- `call_api()` : pour les appels Sync API (batch commands)
- `call_api_rest()` : pour les appels REST avec pagination
- `escape_json()` : pour échapper les caractères spéciaux
- `random_key()` : pour générer les UUIDs des commandes

### Tests à implémenter
- Utiliser `httptest2` pour les mocks API
- Suivre le pattern existant dans `tests/testthat/`
- Tester les cas d'erreur (token invalide, ressource inexistante)

### Documentation
- Roxygen2 pour toutes les nouvelles fonctions
- Mettre à jour la vignette principale
- Exemples dans chaque fonction

---

## Résumé des fichiers à créer/modifier

| Fichier | Action | Fonctions |
|---------|--------|-----------|
| `R/projects.R` | Modifier | +5 fonctions |
| `R/tasks.R` | Modifier | +6 fonctions |
| `R/section.R` | Modifier | +4 fonctions |
| `R/users.R` | Modifier | +7 fonctions |
| `R/labels.R` | Créer | 6 fonctions |
| `R/comments.R` | Créer | 5 fonctions |
| `R/reminders.R` | Créer | 4 fonctions |
| `R/filters.R` | Créer | 5 fonctions |
| `R/workspaces.R` | Créer | 6 fonctions |
| `R/activity.R` | Créer | 1 fonction |
| `R/templates.R` | Créer | 2 fonctions |
| `R/backups.R` | Créer | 2 fonctions |
| `R/uploads.R` | Créer | 2 fonctions |

**Total : ~55 nouvelles fonctions à implémenter**

---

## Notes importantes de l'API v1

1. **Pagination** : Utiliser le système de cursor pour les grandes listes
2. **Rate limiting** : Respecter les limites (non documentées précisément)
3. **Sync tokens** : Utiliser pour les synchronisations incrémentales
4. **Temporary IDs** : Système pour référencer des ressources créées dans le même batch
5. **Webhooks** : Possibilité d'ajouter un support webhook pour les intégrations avancées
