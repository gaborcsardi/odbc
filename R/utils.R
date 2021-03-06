has_names <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !(is.na(nms) | nms == "")
  }
}

`%||%` <- function(x, y) if (is.null(x)) y else x

string_values <- function(x) {

  # TODO: Throw a condition object that can be caught for debugging purposes
  x <- tryCatch(x, error = function(x) "")
  unique(x[nzchar(x)])
}

# version of iconv that respects input Encoding, which bare iconv does not.
enc2iconv <- function(x, to, ...) {
  encodings <- Encoding(x)
  for (enc in unique(encodings)) {
    if (enc == to) {
      next
    }
    current <- enc == encodings
    if (enc == "unknown") {
      enc <- ""
    }
    x[current] <- iconv(x[current], from = enc, to = to, ...)
  }
  x
}

choices_rd <- function(x) {
  paste0(collapse = ", ", paste0("\\sQuote{", x, "}"))
}

lengths <- function(x) {
  vapply(x, length, integer(1))
}

# A 'size' must be an integer greater than 1, returned as a double so we have a larger range
parse_size <- function(x) {
  nme <- substitute(x) %||% "NULL"

  if (rlang::is_scalar_integerish(x) && !is.na(x) && !is.infinite(x) && x > 0) {
    return(as.numeric(x))
  }

  stop(sprintf("`%s` is not a valid size:\n  Must be a positive integer.", as.character(nme)), call. = FALSE)
}

id_field <- function(id, field, default = NULL) {
  if (field %in% names(id@name)) {
    id@name[[field]]
  } else {
    default
  }
}

check_n <- function(n) {
  if (length(n) != 1) stop("`n` must be scalar", call. = FALSE)
  if (n < -1) stopc("`n` must be nonnegative or -1")
  if (is.infinite(n)) n <- -1
  if (trunc(n) != n) stopc("`n` must be a whole number", call. = FALSE)
  n
}
