#' @export
remove_label <- function(owner, repo, name, token) {

    query <- paste0(
        '{
            repository(owner:"', owner, '", name:"', repo, '") {
                label(name:"', name, '") {
                    id
                }
            }
        }
        '
    )

    response <- httr::POST(
        url = "https://api.github.com/graphql",
        config = httr::add_headers(Authorization = paste0("bearer ", token)),
        body = list(query = query),
        encode = "json"
    ) %>% content()

    id <- response$data$repository$label$id

    query <- paste0(
        'mutation {
            deleteLabel(input:{id:"', id ,'"}) {
                clientMutationId
            }
        }'
    )

    response <- httr::POST(
        url = "https://api.github.com/graphql",
        config = httr::add_headers(
            Authorization = paste0("bearer ", token),
            # to enable preview shema label memebers
            Accept = "application/vnd.github.bane-preview+json"
        ),
        body = list(query = query),
        encode = "json"
    ) %>% content()

}
