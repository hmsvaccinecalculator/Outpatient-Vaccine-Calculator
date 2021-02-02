#install.packages("shiny","shinydashboard", "shinyTime", "scales","tidyverse","plotly")

library(shiny)
library(shinydashboard)
library(shinyTime)
library(scales)
library(tidyverse)
library(plotly)

#' Code structure for this R Shiny app was based primarily on the dashboard created by the AFI DSI COVID-19 Research Group's
#' COVID-19 Screening Tool: https://github.com/UW-Madison-DataScience/Paltiel-COVID-19-Screening-for-College

# see https://rstudio.github.io/shinydashboard/appearance.html#statuses-and-colors
input_element_color <- "primary" 
highlight_color <- "olive" 
regular_color <- "navy"

#format header and link to HMS CPC and Ariadne Labs
header <- dashboardHeader(
  title = "Outpatient COVID Vaccination Time & Budget Calculator",
  titleWidth = 600,
  tags$li(a(href = "https://primarycare.hms.harvard.edu/",
            img(src = "HMS-CPC.png",
                title = "HMS Center for Primary Care", height = "30px", width='100px'),
            style = "padding-top:10px; padding-bottom:10px;"),
          class = "dropdown"),
  tags$li(a(href = "https://www.ariadnelabs.org/",
            img(src = "Ariadne.png",
                title = "Ariadne Labs", height = "30px", width='100px'),
            style = "padding-top:10px; padding-bottom:10px;"),
          class = "dropdown")
)

#format sidebar to open with results displayed on the 'dashboard' tab with parameters on the 'inputs' tab
sidebar <- dashboardSidebar(
  tags$style("@import url(https://use.fontawesome.com/releases/v5.14.0/css/all.css);"),
  sidebarMenu(
    id = "sidebar",
    menuItem("Results", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Input: Off-Site Prep", tabName = "off-site-prep", icon = icon("clipboard")),
    menuItem("Input: On-Site Activities", tabName = "on-site-activities", icon = icon("clinic-medical")),
    menuItem("Input: Post-Administration", tabName = "post-admin", icon = icon("file-invoice")),
    menuItem("Source Code", icon = icon("file-code-o"), 
             href = "https://github.com/hmsvaccinecalculator/Outpatient-Vaccine-Calculator"),
    menuItem("Original Spreadsheet", icon = icon("google-drive"), 
             href = "https://docs.google.com/spreadsheets/d/1Eg1sYAvxQv6VYpPl4BO4ym5xAG09H54Dmj1bdFSpWTg/edit#gid=0"),
    menuItem("Start Here", tabName = "references", icon = icon("book"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(
      # MAIN DASHBOARD ---------------------------------------------------
      tabName = "dashboard",
      ## INPUTS --------
      
      
            
    
      ## OUTPUT: plot and metrics --------
      column(width = 8, 
             fluidRow(
               valueBoxOutput("testing_cost_box", width = 4),
               valueBoxOutput("number_tested_box", width = 4),
               valueBoxOutput("average_iu_census_box", width = 4),
             ),
             fluidRow(
               valueBoxOutput("infections_box", width = 4),
               valueBoxOutput("number_confirmatory_tests_box", width = 4),
               valueBoxOutput("average_pct_isolated_box", width = 4),
             ),
             box(plotlyOutput("plot1"), width = 400)
      )
    ),
    ## Off-Site Prep ------------------------------------------------
  
    tabItem(
      tabName = "off-site-prep",
        column(width = 4,
          box(title = "Site Registration", width = NULL, solidHeader = TRUE, status = input_element_color,
                   collapsible = TRUE, collapsed = FALSE,
              numericInput("site_registration", "CDC, State, and/or County Site Registration and Verification (Hours, once per site)", value = 3,
                      min = 0),
          ),
          box(title = "Cohort ID", width = NULL, solidHeader = TRUE, status = input_element_color,
             collapsible = TRUE, collapsed = TRUE,
             
             numericInput("cohort_id-roster", "Generate Roster of Eligibles for Each of 13 NASEM/ACIP Subphases (Hours, once per subphase)", value = 2,
                          min = 0),
             numericInput("cohort_id-duplicate", "De-Duplication, Contact Information Corrections (Hours, once per subphase)", value = 1,
                          min = 0),
         ),
         box(title = "Contact", width = NULL, solidHeader = TRUE, status = input_element_color,
             collapsible = TRUE, collapsed = TRUE,
             
             numericInput("contact-staffing", "Outreach and Scheduling Staffing (USD, per diem cost per worker per hour)", value = 27,
                          min = 0),
             numericInput("contact-screening", "Outreach and Pre-screening Time (Minutes per outreach, including callbacks)", value = 5,
                          min = 0),
             numericInput("contact-scheduling", "Scheduling and Documentation Time (Minutes per outreach, calendaring and notes)", value = 5,
                          min = 0),
             numericInput("contact-outreaches", "Outreaches per Subphase", value = 1432,
                          min = 0),
         ),
         box(title = "Scheduling", width = NULL, solidHeader = TRUE, status = input_element_color,
             collapsible = TRUE, collapsed = TRUE,
             
             numericInput("scheduling-availability", "Vaccine Clinic Public Availability (Days per week)", value = 5,
                          min = 0),
             numericInput("scheduling-probability", "Probability of Scheduling Changes/Cancellations for Dose 1", value = 0.1,
                          min = 0, max = 1),
             numericInput("scheduling-cancel", "Time to Reschedule/Cancel for Dose 1 (Minutes per patient)", value = 5,
                          min = 0),
         ),
         
        ),
        column(width = 4,
             box(title = "Staffing", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("staffing-buyout", "Admin/Supervisor Time Buy-out per Subphase (Hours per subphase)", value = 40,
                              min = 0),
                 numericInput("staffing-planning", "Planning Time for Admins for Each Site (Hours, once per site)", value = 5,
                              min = 0),
                 numericInput("staffing-perdiem", "HR Per Diem Processes, Hiring (Hours per hire)", value = 3,
                              min = 0),
                 numericInput("staffing-overhead", "Overhead Rate for Per Diem Hires (Cost as a proportion of salary)", value = 0.3,
                              min = 0, max = 1),
                 numericInput("staffing-training", "Training on Vaccine Administration Process (Hours, once per site)", value = 5,
                              min = 0),
                 numericInput("staffing-practicerun", "Practice Run of Vaccine Administration Process (Hours, once per site)", value = 2,
                              min = 0),
             ),
             box(title = "Equipment Prep", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("equipment-ppeorder", "PPE Ordering Time (Hours per week)", value = 1,
                              min = 0),
                 numericInput("equipment-ppecost", "PPE Costs (USD, cost per staff member per day)", value = 25,
                              min = 0),
                 numericInput("equipment-stocking", "Stocking and Logging Time (Hours per week)", value = 1,
                              min = 0),
                 numericInput("equipment-paperwork", "Paperwork Printing and Collation Time (Hours per day)", value = 0.5,
                              min = 0),
                 numericInput("equipment-pharmacy", "Pharmacist Support for Delivery and Storage (Hours per day)", value = 2,
                              min = 0),
                 numericInput("equipment-refrigeration", "Refrigeration Transport/Setup (Hours, once per site)", value = 3,
                              min = 0),
                 numericInput("equipment-supplyorder", "Supply Ordering and Costs (USD, per 100 vaccinations prepped)", value = 53,
                              min = 0),
             ),
             box(title = "QI", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("qi-pdsa1", "Initial PDSA Cycle: Cohort ID and Scheduling (Hours per subphase)", value = 4,
                              min = 0),
                 numericInput("qi-pdsa2", "Follow-up PDSA Cycles: Workflow, Staffing Ratios (Hours per subphase)", value = 4,
                              min = 0),
             ),
        ),
    ),
    ## On-Site Activities --------------------------------------------------
    tabItem(
      tabName = "on-site-activities",
      column(width = 4,
             box(title = "Safety", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 numericInput("safety-donning", "PPE Donning, Room Cleaning (Minutes per vaccination)", value = 1,
                              min = 0),
             ),
             box(title = "No Shows", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 numericInput("no-show", "Proportion of Scheduled Patients Missing Appointment", value = 0.05,
                              min = 0, max = 1),
             ),
             box(title = "Registration/Intake", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("intake-equipment", "Registration Area IT/Equipment Setup (Hours, once per site)", value = 2,
                              min = 0),
                 numericInput("intake-wages", "Registration Worker Wages (USD, per diem cost per worker per hour)", value = 27,
                              min = 0),
                 timeInput("intake-time", "Time of First Patient Appointment (24 Hr format)", value = strptime("08:15:00", "%T"),
                              seconds = FALSE),
                 numericInput("intake-registration", "Patient Registration Time (Minutes per patient)", value = 4,
                              min = 0),
             ),
             box(title = "Waiting Area", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("waiting-setup", "Waiting Room Setup Time (Minutes, twice per day)", value = 5,
                              min = 0),
                 numericInput("waiting-cleanup", "Waiting Room Clean-up/Maintenance (Minutes, twice per day)", value = 10,
                              min = 0),
             ),
      ),
      column(width = 4,
             box(title = "Back Room", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("backroom-wages", "Wages for Staff (USD, per-diem per worker per hour)", value = 27,
                              min = 0),
                 numericInput("backroom-vialprep", "Vial Prep and Monitoring, Checklists (Minutes per batch of 24 vaccines)", value = 30,
                              min = 0),
                 numericInput("backroom-needleprep", "Needle Prep and Documentation (Minutes per batch of 24 vaccines)", value = 12,
                              min = 0),
             ),
             box(title = "Vaccination Room", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("vaccination-id", "ID Re-Verification, Assessment, and Counseling (Minutes per vaccination)", value = 2,
                              min = 0),
                 numericInput("vaccination-wages", "Nurse Wages (USD, per-diem per worker per hour)", value = 29,
                              min = 0),
                 numericInput("vaccination-nurses", "Number of Nurses Simultaneously Administering Vaccines on Site", value = 2,
                              min = 0),
                 numericInput("vaccination-disposal", "Injection and Safe Disposal (Minutes per vaccination)", value = 1,
                              min = 0),
             ),
      ),
    ),
    ## Post-Admin-----------------------
    tabItem(
      tabName = "post-admin",
      column(width = 4,
             box(title = "Clean-Up", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 numericInput("cleanup-doffing", "PPE Doffing, Admin Room Clean-up Time (Minutes per vaccination)", value = 1,
                              min = 0),
             ),
             box(title = "Documentation", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 numericInput("documentation-reporting", "Vaccination Card, EHR/Registry Reporting (Minutes per vaccination)", value = 1,
                              min = 0),
             ),
             box(title = "Observation", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("observation-time", "Post-Vaccination Observation Time (Minutes per vaccination)", value = 15,
                              min = 0),
                 numericInput("observation-anaphylaxis", "Anaphylaxis Rate", value = 0.0000111,
                              min = 0, max = 1),
                 numericInput("observation-supplies", "Cost of Required Anaphylaxis Supplies On-Hand (USD)", value = 650,
                              min = 0),
                 numericInput("observation-vaers", "VAERS Reporting Time (Hours per adverse event)", value = 1,
                              min = 0),
             ),
      ),
      column(width = 4,
             box(title = "Follow-Up", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 timeInput("followup-time", "Time of Last Patient Appointment (24 Hr format)", value = strptime("17:00:00", "%T"),
                           seconds = FALSE),
                 numericInput("followup-cancel", "Rate of Appointment Changes/Cancellations for Dose 2", value = 0.1,
                              min = 0, max = 1),
                 numericInput("followup-reschedule", "Time Required to Reschedule/Cancel Appointments for Dose 2 (Minutes)", value = 5,
                              min = 0),
             ),
             box(title = "Closing Up", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("closingup-cleanup", "Clean-Up/Maintenance (Hours, once per day, including biohazards)", value = 1.5,
                              min = 0),
                 numericInput("closingup-wages", "Custodial Worker Wages (USD, per diem cost per worker per hour)", value = 12,
                              min = 0),
                 numericInput("closingup-storage", "Time Required to Properly Store Leftover Vaccine (Hours, once per day)", value = 0.5,
                              min = 0),
             ),
             box(title = "Billing Admin", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = TRUE,
                 
                 numericInput("billing-claims", "Claims Coding, Submission, Reconciliation (Minutes per vaccination)", value = 1,
                              min = 0),
             ),
      ),
    ),
    ## Start Here ----------------------------------------------------------
    tabItem(
      tabName = "references",
      h2("Instructions"),
      p("This tool is intended to assist site managers at outpatient clinics or 
        offsite locations with preparation, workforce planning and budgeting for 
        COVID vaccination in compliance with NASEM, ACIP, state, and county 
        guidelines and regulations, principally focused on Moderna, Pfizer, or 
        AstraZeneca vaccine distribution. The workflow below is utilized for the 
        budget spreadsheet and estimated time requirements. Input parameters can 
        be customized and adjusted in the three 'Input' tabs at the left of the 
        screen, and will automatically update the Results tab.
        The current version assumes costs of the purchasing the vaccines
        themselves are subsumed and federally funded under current CARES Act 
        provisions, hence the calculator focuses on prep and administration 
        costs including workforce, PPE and auxiliary supplies. Calculations are 
        meant to be estimates only, with usual disclaimers. Prior to use, we 
        recommend ", 
        a("this readiness quick-start guide.",
          href = "https://eziz.org/assets/docs/COVID19/IMM-1333.pdf"),
        " 
      "),
      
      h2("Acknowledgements"),
      p("Thanks to site managers at Kaiser Permanente Northern California, 
        Intermountain Healthcare, University of California San Francisco, 
        California Department of Public Health, Beth Israel Deaconness Medical 
        Center, Tufts Healthcare, Harvard Medical School, Ariadne Labs, CVSHealth, 
        Los Angeles Department of Public Health, Alameda Health System, and 
        HealthRight360 for providing input parameters based on their experience 
        to date.
      "),
      
      h2("Legal Disclosure"),
      p("This website contains tools and data intended for use by healthcare 
        professionals. These tools do not give professional advice; physicians 
        and other healthcare professionals who use these tools or data should 
        exercise their own clinical judgment as to the information they provide.
        Consumers who use the tools or data do so at their own risk. Individuals 
        with any type of medical condition are specifically cautioned to seek 
        professional medical advice before beginning any sort of health treatment. 
        For medical concerns, including decisions about medications and other 
        treatments, users should always consult their physician or other 
        qualified healthcare professional. Our content developers have carefully 
        tried to create its content to conform to the standards of professional 
        practice that prevailed at the time of development. However, standards 
        and practices in medicine change as new data become available and the 
        individual medical professional should consult a variety of sources. 
        The contents of the Site, such as text, graphics and images are for 
        informational purposes only. We do not recommend or endorse any specific 
        tests, physicians, products, procedures, opinions, or other information 
        that may be mentioned on the Site. While information on this site has 
        been obtained from sources believed to be reliable, neither we nor our 
        content providers warrant the accuracy of the information contained on 
        this site. We do not give medical advice, nor do we provide medical or 
        diagnostic services. Medical information changes rapidly. Neither we nor 
        our content providers guarantee that the content covers all possible 
        uses, directions, precautions, drug interactions, or adverse effects 
        that may be associated with any therapeutic treatments. Your reliance 
        upon information and content obtained by you at or through this site is 
        solely at your own risk. Neither we nor our content providers assume any 
        liability or responsibility for damage or injury (including death) to you, 
        other persons or property arising from any use of any product, 
        information, idea or instruction contained in the content or services 
        provided to you. We cannot and will not be held legally, financially, or 
        medically responsible for decisions made using these calculators, equations, 
        and algorithms, and this Site is for the use of medical professionals only.
      "),
       
      h2("Contacts"),
      p("We encourage suggestions of new features and improvements to make the 
        visualizations and methodology for this calculator more helpful. The developers can be contacted below."),
      tags$ul(tags$li("Sanjay Basu MD PhD (",
                      a("sanjay_basu@hms.harvard.edu",
                        href = "mailto:sanjay_basu@hms.harvard.edu"),
                      ")"),
              ),
      h2("References"),
      p(""),
    )
  )
)


    ##Server------------------
ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  ## Check that inputs meet restrictions ---------------------------------------
  observe({
    # Don't throw an error if the field is left blank momentarily
    req(input$initial_susceptible,
        input$initial_infected,
        input$R0,
        input$new_infections_per_shock,
        input$days_to_incubation,
        input$time_to_recovery,
        input$pct_advancing_to_symptoms,
        input$symptom_case_fatality_ratio,
        input$test_sensitivity,
        input$test_specificity,
        input$test_cost,
        input$confirmatory_test_cost,
        cancelOutput = TRUE
    )
    
    showWarningIf <- function(condition, message) {
      if (condition) {
        showNotification(message, type = "warning")
      }
    }
    
    showWarningIf(input$initial_susceptible < 1000, "The value for initial susceptible you entered is below the recommended minimum of 1000.")
    showWarningIf(input$initial_infected > 500, "The value for initial infected you entered is above the recommended maximum of 500.")
    showWarningIf(input$R0 < 0.1, "The value for R0 you entered is below the recommended minimum of 0.1.")
    showWarningIf(input$R0 > 5, "The value for R0 you entered is above the recommended maximum of 5.")
    showWarningIf(input$new_infections_per_shock < 0, "The value for the number of new infections per shock you entered is below the recommended minimum of 0.")
    showWarningIf(input$new_infections_per_shock > 200, "The value the number of new infections per shock you entered is above the recommended maximum of 200.")
    showWarningIf(input$days_to_incubation < 1, "The value for days to incubation you entered is below the recommended minimum of 1.")
    showWarningIf(input$time_to_recovery < 1, "The value for time to recovery (days) you entered is below the recommended minimum of 1.")
    showWarningIf(input$pct_advancing_to_symptoms < 5, "The value for percent asymptomatic advancing to symptoms you entered is below the recommended minimum of 5.")
    showWarningIf(input$pct_advancing_to_symptoms > 95, "The value for percent asymptomatic advancing to symptoms you entered is above the recommended maximum of 95.")
    showWarningIf(input$symptom_case_fatality_ratio < 0, "The value for symptom case fatality risk you entered is below the recommended minimum of 0.")
    showWarningIf(input$symptom_case_fatality_ratio > 0.01, "The value for symptom case fatality risk you entered is above the recommended maximum of 0.01.")
    showWarningIf(input$test_sensitivity < 0.5, "The value for test sensitivity you entered is below the recommended minimum of 0.5.")
    showWarningIf(input$test_sensitivity > 1, "The value for test sensitivity you entered is above the recommended maximum of 1.")
    showWarningIf(input$test_specificity < 0.7, "The value for test specificity you entered is below the recommended minimum of 0.7.")
    showWarningIf(input$test_specificity > 1, "The value for test specificity you entered is above the recommended maximum of 1.")
    showWarningIf(input$test_cost < 0, "The value for test cost you entered is below the recommended minimum of 0.")
    showWarningIf(input$test_cost > 1000, "The value for test cost you entered is above the recommended maximum of 1000.")
    showWarningIf(input$confirmatory_test_cost < 0, "The value for confirmatory test cost you entered is below the recommended minimum of 0.")
    showWarningIf(input$confirmatory_test_cost > 1000, "The value for confirmatory test cost you entered is above the recommended maximum of 1000.")
  })
  
  ## Reactive elements -------------------------------------------------------
  df <- reactive({
    req(input$initial_susceptible,
        input$initial_infected,
        input$R0,
        input$new_infections_per_shock,
        input$days_to_incubation,
        input$time_to_recovery,
        input$pct_advancing_to_symptoms,
        input$symptom_case_fatality_ratio,
        input$test_sensitivity,
        input$test_specificity,
        input$test_cost,
        input$confirmatory_test_cost,
        cancelOutput = TRUE
    )
    
    num.exogenous.shocks <- case_when(
      input$exogenous_shocks == "Yes" ~ 1,
      input$exogenous_shocks == "No" ~ 0
    )
    cycles.per.day <- 3
    frequency.exogenous.shocks <- cycles.per.day*input$frequency_exogenous_shocks
    cycles.per.test <- case_when(
      input$frequency_of_screening == "Daily" ~ 1*cycles.per.day,
      input$frequency_of_screening == "Every 2 days" ~ 2*cycles.per.day,
      input$frequency_of_screening == "Every 3 days" ~ 3*cycles.per.day,
      input$frequency_of_screening == "Weekly" ~ 7*cycles.per.day,
      input$frequency_of_screening == "Every 2 weeks" ~ 14*cycles.per.day,
      input$frequency_of_screening == "Every 3 weeks" ~ 21*cycles.per.day,
      input$frequency_of_screening == "Every 4 weeks" ~ 28*cycles.per.day,
      input$frequency_of_screening == "Symptoms Only" ~ 99999999999
    )
    rho <- 1/(input$time_to_recovery*cycles.per.day)
    sigma <- rho*(input$pct_advancing_to_symptoms/100/(1-input$pct_advancing_to_symptoms/100))
    beta <- input$R0*(rho+sigma)
    delta <- (input$symptom_case_fatality_ratio/(1-input$symptom_case_fatality_ratio))*rho
    theta <- 1/(input$days_to_incubation*cycles.per.day)
    mu <- 1/(cycles.per.day*input$time_to_return_fps)
    
    n.cycle <- 240
    
    mat <- matrix(c(0,input$initial_susceptible,0,0,input$initial_infected,0,0,0,0), nrow = 1)
    mat <- 
      rbind(
        mat,
        c(1,
          max(0,mat[1,2]*(1-beta*(mat[1,5]/(mat[1,2]+mat[1,5]+mat[1,4])))+mat[1,3]*mu),
          max(0,mat[1,3]*(1-mu)),
          max(0,mat[1,4]*(1-theta)+ beta*(mat[1,2]*mat[1,5]/(mat[1,2]+mat[1,5]+mat[1,4]))),
          max(0,mat[1,5]*(1-sigma-rho)+mat[1,4]*theta),
          max(0,mat[1,6]*(1-delta-rho)+(mat[1,5]+mat[1,7])*sigma),
          0,
          max(0,mat[1,8]+(mat[1,5]+mat[1,6]+mat[1,7])*rho),
          max(0,delta*mat[1,6]+mat[1,9]))
      )
    
    superspreader.event <- 0
    superspreader.event <- c(superspreader.event, 
                             (1:n.cycle %% frequency.exogenous.shocks == 0)*num.exogenous.shocks)
    
    for(i in 2:n.cycle) {
      mat <- 
        rbind(
          mat,
          c(i,
            max(0,mat[i,2]*(1-beta*(mat[i,5]/(mat[i,2]+mat[i,5]+mat[i,4])))+mat[i,3]*mu-mat[i-1,2]*(1-input$test_specificity)/cycles.per.test-superspreader.event[i+1]*input$new_infections_per_shock),
            max(0,mat[i,3]*(1-mu)+mat[i-1,2]*(1-input$test_specificity)/cycles.per.test),
            max(0,mat[i,4]*(1-theta)+beta*(mat[i,2]*mat[i,5]/(mat[i,2]+mat[i,5]+mat[i,4]))+superspreader.event[i+1]*input$new_infections_per_shock),
            max(0,mat[i,5]*(1-sigma-rho)+mat[i,4]*theta-mat[i-1,5]*input$test_sensitivity/cycles.per.test),
            max(0,mat[i,6]*(1-delta-rho)+(mat[i,5]+mat[i,7])*sigma),
            max(0,mat[i,7]*(1-sigma-rho)+mat[i-1,5]*input$test_sensitivity/cycles.per.test),
            max(0,mat[i,8]+(mat[i,5]+mat[i,6]+mat[i,7])*rho),
            max(0,delta*mat[i,6]+mat[i,9]))
        )
    }
    mat <- cbind(mat, superspreader.event)
    
    names.df <- c("Cycle","Susceptible","FP","Exposed","Asympt","Symptoms","TP","Recovered","Dead","Superspreader Event")
    df <- 
      mat %>% 
      as_tibble() %>% 
      rename_all(~names.df) %>% 
      mutate(`Persons Tested` = (lag(Susceptible,1,NA)+lag(Exposed,1,NA)+lag(Asympt,1,NA))/cycles.per.test,
             `Total TPs` = lag(Asympt,2,NA)*input$test_sensitivity/cycles.per.test,
             `Total FPs` = lag(Susceptible,2,NA)*(1-input$test_specificity)/cycles.per.test,
             `Total TNs` = lag(Susceptible,2,NA)*input$test_specificity/cycles.per.test,
             `Total FNs` = lag(Exposed,2,NA)+lag(Asympt,2,NA)*(1-input$test_sensitivity)/cycles.per.test) %>% 
      mutate(Day = Cycle/cycles.per.day,
             `True Positive` = TP,
             Symptoms = Symptoms,
             `False Positive` = FP,
             Total = TP+Symptoms+FP) %>% 
      mutate(`New Infections` = lag(Asympt,1,NA)*beta*lag(Susceptible,1,NA)/(lag(Susceptible,1,NA)+lag(Exposed,1,NA)+lag(Asympt,1,NA)),
             `New Infections` = ifelse(Cycle>1,
                                       `New Infections`+pmin(`Superspreader Event`*input$new_infections_per_shock,lag(Susceptible,1,NA)),
                                       `New Infections`),
             `New Infections` = ifelse(is.na(`New Infections`),0,`New Infections`),
             `Cumulative Infections` = cumsum(`New Infections`),
             `%Cumulative Infections` = `Cumulative Infections`/input$initial_susceptible)
    
  })
  
  sum.stat <- reactive({
    sum.stat <- 
      df() %>% 
      slice(2:n()) %>% 
      summarize(`Total Persons Tested in 80 days` = sum(`Persons Tested`, na.rm = TRUE),
                `Total Confirmatory Tests Performed` = sum(`Total TPs`, na.rm = TRUE) + sum(`Total FPs`, na.rm = TRUE),
                `Average Isolation Unit Census` = mean(`Total`, na.rm = TRUE),
                `Average %TP in Isolation` = 1-(mean(`False Positive`, na.rm = TRUE)/mean(`Total`, na.rm = TRUE)),
                `Total testing cost` = `Total Persons Tested in 80 days`*input$test_cost+`Total Confirmatory Tests Performed`*input$confirmatory_test_cost,
                `Total Infections` = last(`Cumulative Infections`))
    
    sum.stat <- list(
      ## Expected outputs
      number_tested = sum.stat$`Total Persons Tested in 80 days`,
      number_confirmatory_tests = sum.stat$`Total Confirmatory Tests Performed`,
      average_iu_census = sum.stat$`Average Isolation Unit Census`,
      average_pct_isolated = sum.stat$`Average %TP in Isolation`,
      testing_cost = sum.stat$`Total testing cost`,
      infections = sum.stat$`Total Infections`
    )
  })
  
  ## OUTPUTS -------------------------------------------------------------------
  output$plot1 <- 
    renderPlotly({
      df() %>% 
        select(Day, `True Positive`, Symptoms, `False Positive`) %>% 
        pivot_longer(`True Positive`:`False Positive`, names_to = "Group", values_to = "Value") %>% 
        mutate(Group = as.factor(Group),
               Group = forcats::fct_relevel(Group, levels = c("True Positive", "Symptoms", "False Positive")),
               Group = forcats::fct_recode(Group,
                                           "Asymptomatic (TP)" = "True Positive",
                                           "Symptomatic" = "Symptoms",
                                           "Uninfected (FP)" = "False Positive")) %>% 
        group_by(Day) %>% 
        arrange(Group) %>% 
        mutate(`New Students` = sum(Value),
               Students = cumsum(Value)) %>% 
        plot_ly(x = ~Day, 
                y = ~Students, 
                color = ~Group, 
                colors = RColorBrewer::brewer.pal(9,"YlOrRd")[c(3,6,9)],
                alpha = 0.7,
                type = "scatter",
                mode = "lines",
                fill = 'tonexty',
                text = ~paste0("</br>", Group,": ", round(Value, 1), " students", 
                               " (", scales::percent(Value/`New Students`, accuracy = 0.1), ")",
                               "</br>Total students in isolation: ", round(`New Students`, 1),
                               "</br>Day: ", floor(Day)
                               # "</br>", Group," (Percentage of Students): ", 
                               # "</br>", scales::percent(Value/`New Students`, accuracy = 0.1)
                ), 
                hoverinfo = "text") %>% 
        layout(title = "Composition of Isolation Pool") %>% 
        layout(yaxis = list(title = "Number of Students")) %>% 
        layout(autosize = TRUE, 
               margin = list(l = 75,
                             r = 75,
                             b = 75,
                             t = 75,
                             pad = 10)) %>%
        config(displaylogo = FALSE)
    })
  
  ## Value Boxes 
  output$number_tested_box <- renderValueBox({
    valueBox(scales::comma(sum.stat()$number_tested), "Total Tests",
             icon = icon("vial"),
             color = regular_color)
  })
  
  output$number_confirmatory_tests_box <- renderValueBox({
    valueBox(scales::comma(sum.stat()$number_confirmatory_tests), "Confirmatory Tests",
             icon = icon("vials"), 
             color = regular_color)
  })
  
  output$average_iu_census_box <- renderValueBox({
    valueBox(scales::comma(sum.stat()$average_iu_census), "Isolation Pool Size (Avg.)",
             icon = icon("users"),
             color = regular_color)
  })
  
  output$average_pct_isolated_box <- renderValueBox({
    valueBox(scales::percent(sum.stat()$average_pct_isolated), "of Isolation Pool Infected (Avg.)",
             icon = icon("user-plus"),
             color = regular_color)
  })
  
  output$testing_cost_box <- renderValueBox({
    valueBox(scales::dollar(sum.stat()$testing_cost), "Cost of Testing",
             # icon = icon("money-bill-wave"),
             icon = icon("dollar-sign"),
             color = highlight_color)
  })
  
  output$infections_box <- renderValueBox({
    valueBox(scales::comma(sum.stat()$infections), "Total Infections",
             icon = icon("viruses"),
             color = highlight_color)
  })
  
}

shinyApp(ui, server)

