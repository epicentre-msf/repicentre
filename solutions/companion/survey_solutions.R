# --------------------------------------------------------------------------------------------------
# intro to mortality survey analysis
#
# author : cat eisenhauer
# date : september 2025
# --------------------------------------------------------------------------------------------------

library(dplyr)
library(srvyr)

recall_start <- as.Date('2010-10-17')

# import -------------------------------------------------------------------------------------------
df_raw <- rio::import(here::here('data', 'mod_survey', 'cholera-survey_haiti_2010.xlsx'),
                      which = 2) |>
  select(sex, age, ends_with('date'), born, joined, left, died, died_cause, hh = '_parent_index')

df_hh <- rio::import(here::here('data', 'mod_survey', 'cholera-survey_haiti_2010.xlsx'),
                                  which = 1) |>
  select(interview_date, clst_id, hh = '_index', present, consent) 


# clean -------------------------------------------------------------------------------------------- 
df <- df_raw |>
  # join household data
  left_join(df_hh) |>

  mutate(
    # recoding
    sex = case_when(sex == 1 ~ 'Male',
                    sex == 2 ~ 'Female',
                    .default = NA),
    across(c(born, joined, left, died),
           ~ case_when(. == 0 ~ 'No',
                       . == 1 ~ 'Yes',
                       . == 99 ~ 'Unknown',
                       .default = NA)),
    died_cause = case_when(died_cause == 1 ~ 'Diarrhoea',
                           died_cause == 2 ~ 'Fever',
                           died_cause == 3 ~ 'Respiratory Disease',
                           died_cause == 4 ~ 'Accident',
                           died_cause == 5 ~ 'During Delivery',
                           died_cause == 6 ~ 'Other',
                           died_cause == 99 ~ 'Unknown',
                           is.na(died_cause) ~ 'Did Not Die'),

    # dates as dates
    across(ends_with('date'), lubridate::ymd),

    # can't be born / join the family after you die -- prefer death dates
    born_date = case_when(born_date > died_date ~ NA,
                          .default = born_date),
    joined_date = case_when(joined_date > died_date ~ NA,
                            .default = joined_date),

    # can't be born in recall and have age != 0
    age = case_when(born == 'Yes' ~ 0,
                    .default = age),

    # can't die after you left unless you rejoined -- prefer leaving
    died = case_when(left == 'Yes' & died == 'Yes' & joined == 'No' ~ 'No',
                     .default = died),
    died_date = case_when(died == 'No' ~ NA,
                          .default = died_date)
  )


# person-time --------------------------------------------------------------------------------------
df <- df |>
  mutate(
    pt_start = case_when(born == 'Yes' ~ born_date,
                         joined == 'Yes' ~ joined_date,
                         .default = recall_start),
    pt_end = case_when(left == 'Yes' ~ left_date,
                       died == 'Yes' ~ died_date,
                       .default = interview_date),
    pt = pt_end - pt_start,
    pt = case_when(
      joined_date > left_date & born == 'Yes' ~ (left_date - born_date) + (interview_date - joined_date),
      joined_date > left_date ~ (left_date - recall_start) + (interview_date - joined_date),
      .default = pt
    ),
    pt = as.numeric(pt)
  ) |>
  select(-pt_start, -pt_end)


# mortality ----------------------------------------------------------------------------------------
pop_size <- 228425
sample_size <- nrow(df)

df <- df |>
  summarize(.by = clst_id,
    hh_count = n_distinct(hh)
  ) |>
  mutate(
    weight = (pop_size / sample_size) * (32 / hh_count),
    pop = pop_size
  ) |>
  right_join(df)


# cmr and dsmr
df |>
  as_survey_design(
    ids = clst_id,
    wt = weight,
    fpc = pop
  ) |>
  summarize(
    cmr = survey_ratio(
      numerator = (died == 'Yes') * 10000,
      denominator = pt,
      vartype = 'ci',
      deff = TRUE,
      na.rm = TRUE
    ),
    dsmr = survey_ratio(
      numerator = (died_cause == 'Diarrhoea') * 10000,
      denominator = pt,
      vartype = 'ci',
      deff = TRUE,
      na.rm = TRUE
    )
  )


# u5mr
df |>
  filter(age < 5) |>
  as_survey_design(
    ids = clst_id,
    wt = weight,
    fpc = pop
  ) |>
  summarize(
    u5mr = survey_ratio(
      numerator = (died == 'Yes') * 10000,
      denominator = pt,
      vartype = 'ci',
      deff = TRUE,
      na.rm = TRUE
    )
  )

