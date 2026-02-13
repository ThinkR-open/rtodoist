# Review rtodoist v0.4.0 - Avant soumission CRAN

**Date**: 2026-02-13
**Branche**: v4

---

## Sommaire Exécutif

| Catégorie | Statut | Bloquants CRAN |
|-----------|--------|----------------|
| Structure package | OK | 0 |
| Documentation | A CORRIGER | 2 |
| Qualité du code | A AMÉLIORER | 6 |
| Tests | OK | 0 |
| Dépendances | A NETTOYER | 3 |

**Verdict**: Le package nécessite quelques corrections avant soumission CRAN.

---

## 1. Problèmes Bloquants CRAN

### 1.1 Tags @return manquants (CRITIQUE)

Deux fonctions exportées n'ont pas de documentation `@return`, ce qui génère des fichiers Rd sans section `\value{}`. CRAN rejette systématiquement les packages avec ce problème.

| Fonction | Fichier | Ligne |
|----------|---------|-------|
| `add_section()` | R/section.R | ~11 |
| `get_section_id()` | R/section.R | ~55 |

**Correction requise**: Ajouter `@return` dans la documentation roxygen de ces fonctions.

### 1.2 Fichier LICENSE incomplet

Le fichier `LICENSE` contient uniquement les variables template:
```
YEAR: 2019
COPYRIGHT HOLDER: Cervan Girard
```

Il devrait contenir le texte complet de la licence MIT (présent dans `LICENSE.md`).

**Correction requise**: Mettre à jour le fichier LICENSE avec le format standard CRAN.

---

## 2. Problèmes de Qualité du Code

### 2.1 Injection JSON potentielle (SÉCURITÉ)

Dans `R/tasks.R`, la fonction `move_task()` insère des IDs directement dans le JSON sans échappement:

```r
# Lignes 501-510 - IDs non échappés
glue('"id": "{task_id}"')           # Vulnérable
glue('"project_id": "{project_id}"') # Vulnérable
```

**Impact**: Si un ID contient des caractères spéciaux, cela peut corrompre le JSON.

**Correction**: Utiliser `escape_json()` pour tous les paramètres insérés dans le JSON.

### 2.2 Création automatique de projet (effet de bord)

`get_project_id()` dans `R/projects.R` crée automatiquement un projet si `create=TRUE` (valeur par défaut):

```r
get_project_id("projet_inexistant")  # Crée le projet silencieusement!
```

**Impact**: Risque de création de projets non désirés par erreur.

**Correction suggérée**: Changer le défaut à `create=FALSE` ou afficher un avertissement explicite.

### 2.3 print() au lieu de message()

Dans `R/users.R`, `print(res)` est utilisé pour l'affichage (lignes 113, 179). CRAN préfère `message()` pour les sorties utilisateur.

```r
# Actuel
if (verbose) { print(res) }

# Recommandé
if (verbose) { message(res) }
```

### 2.4 Échecs silencieux avec try()

Dans `R/tasks.R` (lignes 119, 154):
```r
try(task_ok$section_id[is.na(task_ok$section_id)] <- "null")
```

Les erreurs sont silencieusement ignorées, masquant potentiellement des bugs.

### 2.5 Validation de token manquante

Les fonctions `call_api()` et `call_api_rest()` dans `R/utils.R` n'ont pas de validation de token:

```r
# Manquant
if (is.null(token) || !nzchar(token)) {
  stop("API token is required")
}
```

### 2.6 Normalisation Unicode avec effets de bord

Dans `R/section.R`, les noms de sections sont convertis en ASCII:
```r
stringi::stri_trans_general(tolower(section_name), id = "Latin-ASCII")
```

"Café" devient "cafe", ce qui peut matcher des sections non désirées.

---

## 3. Dépendances à Nettoyer

### 3.1 httr - Dépendance obsolète (IMPORTS)

`httr` est importé mais **jamais utilisé**. La migration vers `httr2` est complète.

```r
# NAMESPACE - À supprimer
importFrom(httr, POST)
importFrom(httr, content)
```

**Action**: Supprimer `httr` de DESCRIPTION et NAMESPACE.

### 3.2 lubridate - Dépendance morte (SUGGESTS)

Listé dans Suggests mais jamais utilisé nulle part.

**Action**: Supprimer de DESCRIPTION.

### 3.3 stringi - Dépendance lourde (~2MB)

Utilisé uniquement pour `stri_trans_general()` (3 appels). Pourrait être remplacé par `iconv()` de base R.

**Action**: Optionnel - évaluer si le remplacement vaut l'effort.

---

## 4. Améliorations Recommandées (Non Bloquantes)

### 4.1 Refactoring de add_tasks_in_project()

La fonction fait 225 lignes et gère trop de responsabilités:
- Validation des paramètres
- Gestion des utilisateurs
- Création de sections
- Construction JSON
- Appels API

**Suggestion**: Découper en fonctions plus petites et testables.

### 4.2 Messages d'erreur à améliorer

Certains messages contiennent des emojis ou sont peu informatifs:
```r
stop("Are you sure about the name of the project :) ?")  # R/projects.R:52
```

**Suggestion**: Messages professionnels avec le nom du projet manquant.

### 4.3 Paramètre en français

`que_si_necessaire` dans plusieurs fonctions devrait être renommé en anglais (ex: `only_if_needed`).

### 4.4 Code commenté à supprimer

```r
# browser()  # R/section.R:100
# # browser()  # R/tasks.R:162
```

### 4.5 Copyright year

Le fichier LICENSE mentionne 2019. À mettre à jour pour inclure l'année courante.

---

## 5. Points Positifs

- Structure de package conforme aux standards R
- Vignettes bien documentées avec `eval=FALSE` approprié
- Tests avec `skip_on_cran()` correctement configurés
- `.Rbuildignore` bien configuré
- NEWS.md à jour et bien formaté
- README avec badges et exemples
- Gestion du token via keyring (sécurisé)
- Pattern pipe-friendly bien implémenté

---

## 6. Plan d'Action Recommandé

### Priorité 1 - Bloquants CRAN (À faire immédiatement)

1. [ ] Ajouter `@return` à `add_section()` et `get_section_id()`
2. [ ] Corriger le fichier LICENSE
3. [ ] Supprimer `httr` de DESCRIPTION et NAMESPACE
4. [ ] Supprimer `lubridate` de DESCRIPTION

### Priorité 2 - Sécurité et Robustesse

5. [ ] Échapper les IDs dans `move_task()` avec `escape_json()`
6. [ ] Ajouter validation du token dans `call_api()` et `call_api_rest()`
7. [ ] Remplacer `print()` par `message()` dans R/users.R

### Priorité 3 - Qualité (Optionnel)

8. [ ] Changer défaut `create=FALSE` dans `get_project_id()`
9. [ ] Supprimer les `try()` silencieux ou ajouter gestion d'erreur
10. [ ] Supprimer le code commenté (`# browser()`)
11. [ ] Améliorer les messages d'erreur

---

## 7. Commande de Vérification

Avant soumission, exécuter:

```r
# Vérification complète
rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")

# Vérification des URLs
urlchecker::url_check()

# Vérification orthographe
spelling::spell_check_package()
```

---

## Annexe: Fichiers Concernés

| Fichier | Problèmes | Priorité |
|---------|-----------|----------|
| R/section.R | @return manquants, browser commenté | P1 |
| R/tasks.R | JSON injection, try silencieux | P2 |
| R/users.R | print() au lieu de message() | P2 |
| R/utils.R | Validation token manquante | P2 |
| R/projects.R | Effet de bord création projet | P3 |
| DESCRIPTION | httr et lubridate à supprimer | P1 |
| NAMESPACE | httr imports à supprimer | P1 |
| LICENSE | Contenu incomplet | P1 |
