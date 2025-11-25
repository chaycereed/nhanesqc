#' Plot method for nhanes_qc_result objects
#'
#' @description
#' Simple visualization for NHANES QC results.
#'
#' Currently supports:
#' - `type = "missing"`: barplot of proportion missing by variable
#' - `type = "special"`: barplot of proportion special codes by variable
#'
#' Only the top `top_n` variables (by the chosen metric) are shown.
#'
#' @param x An object of class `nhanes_qc_result`, as returned by [nhanes_qc()].
#' @param type Character; either `"missing"` or `"special"`.
#' @param top_n Integer; number of variables to show (sorted descending).
#' @param ... Additional arguments passed to [graphics::barplot()].
#'
#' @return The result of [graphics::barplot()], invisibly.
#' @export
#' @method plot nhanes_qc_result
plot.nhanes_qc_result <- function(
  x,
  type = c("missing", "special"),
  top_n = 20,
  ...
) {
  if (!inherits(x, "nhanes_qc_result")) {
    stop("`x` must be an object of class 'nhanes_qc_result'.", call. = FALSE)
  }

  type <- match.arg(type)

  miss_tbl <- x$missingness

  if (!is.data.frame(miss_tbl)) {
    stop("No missingness table available in `x$missingness`.", call. = FALSE)
  }

  if (!all(c("variable", "prop_na", "prop_special") %in% names(miss_tbl))) {
    stop("`x$missingness` must contain 'variable', 'prop_na', and 'prop_special' columns.", call. = FALSE)
  }

  if (nrow(miss_tbl) == 0L) {
    stop("Missingness table is empty; nothing to plot.", call. = FALSE)
  }

  # Choose which metric to plot
  if (type == "missing") {
    metric <- miss_tbl$prop_na
    metric_label <- "Proportion missing"
    title <- "Proportion missing by variable"
  } else {
    metric <- miss_tbl$prop_special
    metric_label <- "Proportion special codes"
    title <- "Proportion NHANES-style special codes by variable"
  }

  # Keep only variables with > 0 for the chosen metric
  keep <- which(metric > 0 & !is.na(metric))
  if (length(keep) == 0L) {
    message("No variables with non-zero ", type, " values to plot.")
    return(invisible(NULL))
  }

  metric <- metric[keep]
  vars   <- miss_tbl$variable[keep]

  # Order by descending metric and take top_n
  ord <- order(metric, decreasing = TRUE)
  ord <- ord[seq_len(min(top_n, length(ord)))]

  metric_top <- metric[ord]
  vars_top   <- vars[ord]

  # Create a simple horizontal barplot (easier to read)
  op <- par(no.readonly = TRUE)
  on.exit(par(op), add = TRUE)

  par(mar = c(5, 10, 4, 2) + 0.1)  # more space for y-axis labels

  barplot(
    height = metric_top,
    names.arg = vars_top,
    horiz = TRUE,
    las   = 1,
    xlab  = metric_label,
    main  = title,
    ...
  ) -> res

  invisible(res)
}