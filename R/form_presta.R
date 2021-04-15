#' Init project
#' 
#' Create a project with a specific to-do list for different people
#' 
#' @param project_id id of project
#' @param tasks_list lists of tasks
# @param try_again try again the http request
#' @param verbose make the function verbose
# @param time_try_again number of tries
#' @param responsible add people in project
#' @param token todoist API token
#' 
#' @return id of project (character vector)
#' @export
init_project <- function(project_id,
                         tasks_list,
                         # try_again = 3,
                         # time_try_again = 3,
                         verbose = TRUE,
                         responsible = NULL,
                         token = get_todoist_api_token()) {
  if (!is.list(tasks_list)) {
    # allow user to pass a vector
    tasks_list <- as.list(tasks_list)
  }
  add_tasks_in_project(
    project_id = project_id,
    token = token,
    # try_again = try_again,
    # time_try_again = time_try_again,
    verbose = verbose,
    responsible = responsible,
    tasks_list = tasks_list
  )
}

#' @rdname init_project
#' @export
init_presta <- function(project_id,
                        tasks_list = list(
                          "Reunions",
                          "Proposition - Devis",
                          "Gestion projet",
                          "Code",
                          "S'assurer d'avoir un nom de projet coherent avec Slack",
                          "S'assigner et mettre des dates sur certaines taches pour pas les oublier",
                          "Facturer",
                          "Rediger la reference de la mission dans {reference}",
                          "Paye"
                        ),
                        # try_again = 3,
                        # time_try_again = 3,
                        verbose = TRUE,
                        responsible = NULL,
                        token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token,
    # try_again = try_again,
    # time_try_again = time_try_again,
    verbose = verbose,
    tasks_list = tasks_list,
    responsible = responsible
  )
}

#' @rdname init_project
#'
#' @export
init_presta_admin <- function(project_id,
                              tasks_list = list("Facturer", "Etre Pay\\u00E9"),
                              # try_again = 3,
                              # time_try_again = 3,
                              verbose = TRUE,
                              responsible = NULL,
                              token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token,
    # try_again = try_again,
    # time_try_again = time_try_again,
    verbose = verbose,
    tasks_list = tasks_list,
    responsible = responsible
  )
}

#' @rdname init_project
#'
#' @export
init_presta_manager <- function(project_id,
                                tasks_list = list(
                                  "Proposition - Devis",
                                  "Gestion projet",
                                  "S'assurer d'avoir un nom de projet coherent avec Slack",
                                  "S'assigner et mettre des dates sur certaines taches pour pas les oublier",
                                  "Rediger la reference de la mission dans {reference}"
                                ),
                                try_again = 3,
                                time_try_again = 3,
                                verbose = TRUE,
                                responsible = NULL,
                                token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token,
    # time_try_again = time_try_again,
    # try_again = try_again,
    verbose = verbose,
    tasks_list = tasks_list,
    responsible = responsible
  )
}

#' @rdname init_project
#'
#' @export
init_forma_formateur <- function(project_id,
                                 tasks_list = list(
                                   "f_S'assurer d'avoir logistique OK",
                                   "f_Cr\\u00E9er le contenu de la formation",
                                   "f_Imprimer des feuilles d'emargement",
                                   "f_S'assurer d'avoir son materiel complet",
                                   "f_Remplir notes de frais",
                                   "f_Scanner feuille d'emargement",
                                   "f_transferer feuille d'emargement"
                                 ),
                                 # try_again = 3,
                                 # time_try_again = 3,
                                 verbose = TRUE,
                                 responsible = NULL,
                                 token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token,
    verbose = verbose, 
    # time_try_again = time_try_again,
    # try_again = try_again,
    responsible = responsible,
    tasks_list = tasks_list
  )
}

#' @rdname init_project
#'
#' @export
init_forma_manager <- function(project_id,
                               tasks_list = list(
                                 "Envoi du devis + contenu",
                                 "Assigner au formateur les taches du formateur",
                                 "Etre Pay\\u00E9"
                               ),
                               # try_again = 3,
                               # time_try_again = 3,
                               verbose = TRUE,
                               responsible = NULL,
                               token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token, 
    verbose = verbose,
    # time_try_again = time_try_again,
    # try_again = try_again,
    responsible = responsible,
    tasks_list = tasks_list
  )
}

#' @rdname init_project
#'
#' @export
init_inter <- function(project_id,
                       tasks_list = list(
                         "S'assurer d'avoir un nom de projet coherent avec Slack",
                         "S'assigner et mettre des dates sur certaines taches pour pas les oublier",
                         "Envoyer les questionnaires",
                         "Envoi du devis + contenu",
                         "Envoi des conventions de formation",
                         "Envoi des convocations",
                         "Creer le contenu de la formation",
                         "Reserver salle",
                         "Envoi des liens d'installations",
                         "Imprimer des feuilles d'emargement",
                         "S'assurer d'avoir son materiel complet",
                         "Reserver Resto",
                         "Remplir ses notes de frais",
                         "Scanner la feuille d'emargement",
                         "Enregistrer son temps de formation dans Toggl",
                         "Envoyer le questionnaire de satisfaction",
                         "Envoyer questionnaire de satisfaction a froid",
                         "Facturer",
                         "Paye"
                       ),
                       # try_again = 3,
                       # time_try_again = 3,
                       verbose = TRUE,
                       token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token, 
    verbose = verbose,
    # time_try_again = time_try_again,
    # try_again = try_again,
    tasks_list = tasks_list
  )
}

#' @rdname init_project
#'
#' @export
init_forma_admin <- function(project_id,
                             tasks_list = list("recevoir nom/prenom et mail des stagiaires",
                                               "envoyer test de pr\\u00E9\\u00E9valuation",
                                               "mettre les echeances aux taches suivantes",
                                               "envoyer convention",
                                               "v\\u00E9rifier retour convention",
                                               "s'assurer que la logistique du formateur est OK",
                                               "envoyer convocation aux stagiaires",
                                               "upload feuille emmargement",
                                               "envoyer facture",
                                               "verifier que la facture est bien dans le bon projet axonaut",
                                               "envoyer attestation",
                                               "envoyer evaluation a chaud",
                                               "plannifier l'evaluation a froid",
                                               "verifie retour eval a cahud",
                                               "verifie retour eval \\u00E0 froid",
                                               "mail retour de qualit\\u00E9 + audt besoin"),
                             # try_again = 3,
                             # time_try_again = 3,
                             verbose = TRUE,
                             responsible = NULL,
                             token = get_todoist_api_token()) {
  init_project(
    project_id = project_id,
    token = token,
    verbose = verbose, 
    # try_again = try_again,
    # time_try_again = time_try_again,
    responsible = responsible,
    tasks_list = tasks_list
  )
}
