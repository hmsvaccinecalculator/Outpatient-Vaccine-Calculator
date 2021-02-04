#install.packages("shiny","shinydashboard", "shinyTime", "scales","tidyverse","DT")
library(shiny)
library(shinydashboard)
library(shinyTime)
library(scales)
library(tidyverse)
library(DT)

#' Code structure for this R Shiny app was based primarily on the dashboard created by the AFI DSI COVID-19 Research Group's
#' COVID-19 Screening Tool: https://github.com/UW-Madison-DataScience/Paltiel-COVID-19-Screening-for-College
## Header and Sidebar------------------
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

#format sidebar to open with results displayed on the 'dashboard' tab with parameters on the 'inputs' tabs
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
    menuItem("Acknowledgements/Legal", tabName = "references", icon = icon("book"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(
    ## MAIN DASHBOARD ---------------------------------------------------
      tabName = "dashboard",
      
      h2("Instructions"),
      p("This tool is intended to assist site managers at outpatient clinics or 
        offsite locations with preparation, workforce planning and budgeting for 
        COVID vaccination in compliance with NASEM, ACIP, state, and county 
        guidelines and regulations, principally focused on Moderna, Pfizer, or 
        AstraZeneca vaccine distribution. Input parameters can 
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
        ),
    h2("Results"),
      fluidRow(
        tabBox(
          title = "Staff Data",
          # The id lets us use input$tabset1 on the server to find the current tab
          id = "tabset1", height = "250px",
          tabPanel("Staff Hours", dataTableOutput("staffhours")
                   
          ),
          tabPanel("Staff Wages", dataTableOutput("staffwages"))
        ),
        box(
          title = "Vaccination Data",
          # The id lets us use input$tabset1 on the server to find the current tab
          id = "tabset2", height = "250px", collapsible = FALSE,
          dataTableOutput("vaxtotals")
          
        ),
      ),
      p(""),
      p("These results assume:",
        
        tags$ul(tags$li("outreach/scheduling, registration, and post-vaccine observation 
                    will be done by medical assistants-which can be changed to other types of workers on the Input sheet);"),
                
                tags$li("per-diem staff (MAs, nurses, custodial) will need to be hired or 
                    pulled from other activities, at a cost, for the vaccine on-site 
                    administration-including scheduling, registration, administration, 
                    and observation"), 
                
                tags$li("refrigeration/freezer equipment will be a separate 
                    line-item or otherwise sourced or pre-existing (hence, not included 
                    in these cost estimates); and"),
                
                tags$li("1 hour lunch break will be provided for staff each day.")
        ),
      ),
      
    
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
             collapsible = TRUE, collapsed = FALSE,
             
             numericInput("cohort_id-roster", "Generate Roster of Eligibles for Each of 13 NASEM/ACIP Subphases (Hours, once per subphase)", value = 2,
                          min = 0),
             numericInput("cohort_id-duplicate", "De-Duplication, Contact Information Corrections (Hours, once per subphase)", value = 1,
                          min = 0),
         ),
         box(title = "Contact", width = NULL, solidHeader = TRUE, status = input_element_color,
             collapsible = TRUE, collapsed = FALSE,
             
             numericInput("contact-staffing", "Outreach and Scheduling Staffing (USD, per diem cost per worker per hour)", value = 27,
                          min = 0),
             numericInput("contact-screening", "Outreach and Pre-screening Time (Minutes per outreach, including callbacks)", value = 5,
                          min = 0),
             numericInput("contact-scheduling", "Scheduling and Documentation Time (Minutes per outreach, calendaring and notes)", value = 5,
                          min = 0),
             numericInput("contact-outreaches", "Outreaches per Subphase", value = 1432,
                          min = 0),
         ),
         
         
        ),
        column(width = 4,
             box(title = "Scheduling", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("scheduling-availability", "Vaccine Clinic Public Availability (Days per week)", value = 5,
                              min = 0),
                 numericInput("scheduling-probability", "Probability of Scheduling Changes/Cancellations for Dose 1", value = 0.1,
                              min = 0, max = 1),
                 numericInput("scheduling-cancel", "Time to Reschedule/Cancel for Dose 1 (Minutes per patient)", value = 5,
                              min = 0),
             ), 
            box(title = "Staffing", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
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
             
        ),
        column(width = 4,
             box(title = "Equipment Prep", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
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
                 collapsible = TRUE, collapsed = FALSE,
                 
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
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("intake-equipment", "Registration Area IT/Equipment Setup (Hours, once per site)", value = 2,
                              min = 0),
                 numericInput("intake-wages", "Registration Worker Wages (USD, per diem cost per worker per hour)", value = 27,
                              min = 0),
                 timeInput("intake-time", "Time of First Patient Appointment (24 Hr format)", value = strptime("08:15:00", "%T"),
                              seconds = FALSE),
                 numericInput("intake-registration", "Patient Registration Time (Minutes per patient)", value = 4,
                              min = 0),
             ),
      ),
      column(width = 4,
             box(title = "Waiting Area", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("waiting-setup", "Waiting Room Setup Time (Minutes, twice per day)", value = 5,
                              min = 0),
                 numericInput("waiting-cleanup", "Waiting Room Clean-up/Maintenance (Minutes, twice per day)", value = 10,
                              min = 0),
             ),
             box(title = "Back Room", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("backroom-wages", "Wages for Staff (USD, per-diem per worker per hour)", value = 27,
                              min = 0),
                 numericInput("backroom-vialprep", "Vial Prep and Monitoring, Checklists (Minutes per batch of 24 vaccines)", value = 30,
                              min = 0),
                 numericInput("backroom-needleprep", "Needle Prep and Documentation (Minutes per batch of 24 vaccines)", value = 12,
                              min = 0),
             ),
             
      ),
      column(width = 4,
             box(title = "Vaccination Room", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("vaccination-id", "ID Re-Verification, Assessment, and Counseling (Minutes per vaccination)", value = 3,
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
                 collapsible = TRUE, collapsed = FALSE,
                 
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
                 collapsible = TRUE, collapsed = FALSE,
                 
                 timeInput("followup-time", "Time of Last Patient Appointment (24 Hr format)", value = strptime("17:00:00", "%T"),
                           seconds = FALSE),
                 numericInput("followup-cancel", "Rate of Appointment Changes/Cancellations for Dose 2", value = 0.1,
                              min = 0, max = 1),
                 numericInput("followup-reschedule", "Time Required to Reschedule/Cancel Appointments for Dose 2 (Minutes)", value = 5,
                              min = 0),
             ),
             box(title = "Closing Up", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("closingup-cleanup", "Clean-Up/Maintenance (Hours, once per day, including biohazards)", value = 1.5,
                              min = 0),
                 numericInput("closingup-wages", "Custodial Worker Wages (USD, per diem cost per worker per hour)", value = 12,
                              min = 0),
                 numericInput("closingup-storage", "Time Required to Properly Store Leftover Vaccine (Hours, once per day)", value = 0.5,
                              min = 0),
             ),
             
      ),
      column(width = 4,
             box(title = "Billing Admin", width = NULL, solidHeader = TRUE, status = input_element_color,
                 collapsible = TRUE, collapsed = FALSE,
                 
                 numericInput("billing-claims", "Claims Coding, Submission, Reconciliation (Minutes per vaccination)", value = 1,
                              min = 0),
             ),
      ),
    ),
    ## Acknowledgement-Legal ----------------------------------------------------------
    tabItem(
      tabName = "references",
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
      h2(),
      p(),
      
      h2(),
      p(),
      
      h2(),
      p(),
       
      h2(),
      p(),
      tags$ul(),
      h2(),
      p(),
    )
  )
)


    
##Server------------------
ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  ## Check that inputs meet restrictions ---------------------------------------
  # observe({
  #   req(input$site_registration,
  #       input$cohort_id-roster,
  #       input$cohort_id-duplicate,
  #       input$contact-staffing,
  #       input$contact-screening,
  #       input$contact-scheduling,
  #       input$contact-outreaches,
  #       input$scheduling-availability,
  #       input$scheduling-probability,
  #       input$scheduling-cancel,
  #       input$staffing-buyout,
  #       input$staffing-planning,
  #       input$staffing-perdiem,
  #       input$staffing-overhead,
  #       input$staffing-training,
  #       input$staffing-practicerun,
  #       input$equipment-ppeorder,
  #       input$equipment-ppecost,
  #       input$equipment-stocking,
  #       input$equipment-paperwork,
  #       input$equipment-pharmacy,
  #       input$equipment-refrigeration,
  #       input$equipment-supplyorder,
  #       input$qi-pdsa1,
  #       input$qi-pdsa2,
  #       input$safety-donning,
  #       input$no-show,
  #       input$intake-equipment,
  #       input$intake-wages,
  #       input$intake-time,
  #       input$intake-registration,
  #       input$waiting-setup,
  #       input$waiting-cleanup,
  #       input$backroom-wages,
  #       input$backroom-vialprep,
  #       input$backroom-needleprep,
  #       input$vaccination-id,
  #       input$vaccination-wages,
  #       input$vaccination-nurses,
  #       input$vaccination-disposal,
  #       input$cleanup-doffing,
  #       input$documentation-reporting,
  #       input$observation-time,
  #       input$observation-anaphylaxis,
  #       input$observation-supplies,
  #       input$observation-vaers,
  #       input$followup-time,
  #       input$followup-cancel,
  #       input$followup-reschedule,
  #       input$closingup-cleanup,
  #       input$closingup-wages,
  #       input$closingup-storage,
  #       input$billing-claims,
  #       
  #       cancelOutput = TRUE
  #   )
  #   
  #   showWarningIf <- function(condition, message) {
  #     if (condition) {
  #       showNotification(message, type = "warning")
  #     }
  #   }
  #   
  #       showWarningIf(input$`site_registration` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`cohort_id-roster` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`cohort_id-duplicate` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`contact-staffing` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`contact-screening` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`contact-scheduling` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`contact-outreaches` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`scheduling-availability` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`scheduling-probability` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`scheduling-probability` > 1, "The value you entered is greater than 100%.")
  #       showWarningIf(input$`scheduling-cancel` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`staffing-buyout` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`staffing-planning` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`staffing-perdiem` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`staffing-overhead` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`staffing-overhead` > 1, "The value you entered is greater than 100%.")
  #       showWarningIf(input$`staffing-training` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`staffing-practicerun` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-ppeorder` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-ppecost` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-stocking` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-paperwork` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-pharmacy` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-refrigeration` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`equipment-supplyorder` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`qi-pdsa1` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`qi-pdsa2` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`safety-donning` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`no-show` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`no-show` > 1, "The value you entered is greater than 100%.")
  #       showWarningIf(input$`intake-equipment` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`intake-wages` < 0, "The value you entered is a negative number.")
  #       #showWarningIf(input$`intake-time` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`intake-registration` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`waiting-setup` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`waiting-cleanup` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`backroom-wages` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`backroom-vialprep` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`backroom-needleprep` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`vaccination-id` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`vaccination-wages` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`vaccination-nurses` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`vaccination-disposal` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`cleanup-doffing` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`documentation-reporting` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`observation-time` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`observation-anaphylaxis` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`observation-anaphylaxis` >1, "The value you entered is greater than 100%.")
  #       showWarningIf(input$`observation-supplies` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`observation-vaers` < 0, "The value you entered is a negative number.")
  #       #showWarningIf(input$`followup-time` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`followup-cancel` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`followup-cancel` > 1, "The value you entered is greater than 100%.")
  #       showWarningIf(input$`followup-reschedule` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`closingup-cleanup` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`closingup-wages` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`closingup-storage` < 0, "The value you entered is a negative number.")
  #       showWarningIf(input$`billing-claims` < 0, "The value you entered is a negative number.")
  # })
  ##Generate Tables with Input--------------------
  
  
  output$staffhours = renderDataTable({
    rows1 = c("Logistics/Supervisors", "IT","Pharmacist","Scheduling","Registration and Observers", "Vaccine Prep/Backend","Vaccine Administrators","Custodian")
    onetime1 = c(input$`site_registration` + input$`staffing-planning` + input$`staffing-perdiem`*(input$`vaccination-nurses`+3) + input$`staffing-training` + input$`staffing-practicerun` + input$`equipment-refrigeration` + input$`staffing-buyout`,
                 (input$`cohort_id-roster`+ input$`cohort_id-duplicate`)*13 + input$`intake-equipment`,
                 input$`equipment-refrigeration` +input$`staffing-training`,
                 "N/A",
                 "N/A",
                 "N/A",
                 "N/A",
                 "N/A"
                 )
    perweek1 = c("",
                 "",
                 "",
                 "",
                 "",
                 "",
                 "",
                 ""
                )
    persub1 = c(round(input$`staffing-buyout`+input$`equipment-ppeorder`+input$`equipment-stocking`*((input$`contact-outreaches` 
                                                                                                      / (input$`vaccination-nurses`*(1-input$`no-show`)*(
                                                                                                        (as.numeric(input$`followup-time`-input$`intake-time`, units = "hours")-1)
                                                                                                        *60/(input$`vaccination-id`+ input$`vaccination-disposal`+ 
                                                                                                               input$`safety-donning`+ input$`cleanup-doffing`))))/ 
                                                                                                       input$`scheduling-availability`)+((input$`qi-pdsa1`+input$`qi-pdsa2`)/2)),
                round(input$`cohort_id-roster` + input$`cohort_id-duplicate`),
                round(input$`equipment-pharmacy`),
                "",
                round((input$`intake-registration`)/60*input$`contact-outreaches`+input$`followup-cancel`*input$`followup-reschedule`/60*input$`contact-outreaches`+input$`billing-claims`*input$`contact-outreaches`/60+input$`equipment-paperwork`*input$`scheduling-availability`),
                "input$`contact-outreaches`*(Input!K36/100+Input!K49/24+Input!K48/24)/60+Input!K65*G1*input$`scheduling-availability`",
                "input$`contact-outreaches`*(Input!K39+Input!K50+Input!K53+Input!K54+Input!K55)/60+input$`contact-outreaches`*Input!K57+Input!K59",
                "((Input!K45+Input!K46)*2/60+Input!K63)*G1*input$`scheduling-availability`"
    )
    total1 = c("",
               "",
               "",
               "",
               "",
               "",
               "",
               ""
    ) 
    table = data.frame(rows1, onetime1, perweek1, persub1,total1)
    colnames(table) = c(" ", "Fixed, One-Time, Setup (Hours)", 
                        "Recurring, per week (Hours)",
                        "Recurring, per subphase (Hours)", 
                        "Overall Vaccination Campaign (fixed + recurring, across all subphases)"
    )
    table
  }, options = list(searching = FALSE, paging = FALSE))
  
  output$staffwages = renderDataTable({
    rows2 = c("Medical Assistants", "Nurses","Custodial")
    perweek2 = c("",
                 "", 
                 ""
                 )
    persub2 = c("58.9 (6.7)","", "")
    total2 = c("58.9 (6.7)","", "") 
    table = data.frame(rows2, perweek2, persub2,total2)
    colnames(table) = c(" ", 
                        "Recurring, per week (USD)",
                        "Recurring, per subphase (USD)", 
                        "Overall Vaccination Campaign (fixed + recurring, across all subphases) (USD)"
                        )
    table
  }, options = list(searching = FALSE, paging = FALSE))
  
  
  
  output$vaxtotals = renderDataTable({
    rows3 = c("Number of vaccinations completed per day", 
              "Total vaccinations completed, overall vax campaign (all subphases)",
              "Number of days to vaccinate each subphase (of 13 subphases)",
              "Number of weeks to complete vax campaign",
              "Personnel cost per vaccination",
              "Equipment/supply cost per vaccination")
    total3 = c(round(input$`vaccination-nurses`*(1-input$`no-show`)*(
                (input$`followup-time`-input$`intake-time`-1)*60 
                /(input$`vaccination-id`+ input$`vaccination-disposal`+ 
                    input$`safety-donning`+ input$`cleanup-doffing`))),
               
               round(13*input$`contact-outreaches`*(1-input$`no-show`)),
               
               round(input$`contact-outreaches` 
                / (input$`vaccination-nurses`*(1-input$`no-show`)*(
                  (as.numeric(input$`followup-time`-input$`intake-time`, units = "hours")-1)
                  *60/(input$`vaccination-id`+ input$`vaccination-disposal`+ 
                         input$`safety-donning`+ input$`cleanup-doffing`)))),
               
               round((input$`contact-outreaches` 
                      / (input$`vaccination-nurses`*(1-input$`no-show`)*(
                        (as.numeric(input$`followup-time`-input$`intake-time`, units = "hours")-1)
                        *60/(input$`vaccination-id`+ input$`vaccination-disposal`+ 
                               input$`safety-donning`+ input$`cleanup-doffing`))))/ 
                       input$`scheduling-availability` * 13),
               
               "",
               ""
              )
    table = data.frame(rows3, total3)
    
    table
  }, options = list(searching = FALSE, paging = FALSE))
}

shinyApp(ui, server)

