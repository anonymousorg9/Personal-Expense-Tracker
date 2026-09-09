# Personal Finance Tracker

A modern personal finance tracking application built with **Flutter and Dart**.

The purpose of this project is to build something that feels like a real application rather than a basic Flutter demo. I am developing it incrementally, testing each major change, keeping the code organized, and maintaining a meaningful Git history throughout the process.

> **Status:** 🚧 Under active development

---

## About the Project

Managing personal finances can become difficult when income, expenses, savings, and spending information are spread across different places.

The idea behind this project is to bring those things together into one clean and easy-to-use application.

The application is being developed to eventually allow users to:

- Track income and expenses
- Organize transactions by category
- Monitor their current balance
- Set and monitor budgets
- Understand spending patterns
- View financial reports
- Store financial data locally
- Switch between light and dark themes
- Use the application comfortably across different screen sizes

The project is still under development, so the dashboard currently uses representative sample data.

---

## Current Progress

| Area | Status |
|---|---|
| Flutter SDK setup | ✅ Completed |
| Dart setup | ✅ Completed |
| Git setup | ✅ Completed |
| GitHub repository | ✅ Completed |
| Flutter project creation | ✅ Completed |
| Project architecture | ✅ Completed |
| Design system foundation | ✅ Completed |
| Light theme | ✅ Completed |
| Dark theme | ✅ Completed |
| Dashboard foundation | ✅ Completed |
| Responsive dashboard layout | ✅ Completed |
| Spending chart | ✅ Completed |
| Recent transactions section | ✅ Completed |
| Dashboard testing | ✅ Completed |
| Transaction management | ⏳ Planned |
| Categories | ⏳ Planned |
| Budgets | ⏳ Planned |
| Reports and analytics | ⏳ Planned |
| Local data persistence | ⏳ Planned |
| Security improvements | ⏳ Planned |
| Production polish | ⏳ Planned |

---

## Tech Stack

### Application

- Flutter
- Dart
- Material 3

### Packages

The project currently uses:

- `provider` — state management
- `go_router` — routing foundation
- `intl` — currency and number formatting
- `fl_chart` — data visualization

More packages will be added only when they are actually required by a feature.

### Development Tools

- Visual Studio Code
- Android Studio
- Git
- GitHub
- Google Chrome

---

## Project Structure

The project follows a feature-first structure so that each major part of the application can grow independently.

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       ├── app_typography.dart
│       └── theme_controller.dart
│
├── core/
│   ├── constants/
│   ├── extensions/
│   └── utils/
│
├── features/
│   ├── dashboard/
│   ├── transactions/
│   ├── budgets/
│   ├── reports/
│   ├── categories/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   └── models/
│
└── main.dart

The structure will continue to evolve as new features are implemented.

Design Direction

The application follows a Modern Clean visual style.

The main design goals are:

Clear visual hierarchy
Minimal visual clutter
Consistent spacing
Rounded cards
Clean typography
Useful data visualization
Responsive layouts
Consistent light and dark themes

The design is intentionally kept clean so that functionality can be added later without making the interface feel crowded.

Theme Support

The application currently supports three theme modes:

System
Light
Dark

Theme colors and styling are centralized rather than being repeated throughout individual screens.

The dashboard also includes a theme toggle so that the theme system can be checked quickly during development.

Dashboard Development

The dashboard was the first major application screen developed after the project foundation.

The goal was to move beyond the default Flutter counter application and create the first screen that actually resembles a finance product.

The current dashboard contains:

Desktop sidebar navigation
Mobile/tablet bottom navigation
Total balance card
Income summary
Expense summary
Savings summary
Weekly spending chart
Recent transactions
Responsive layout
Light/dark theme support
Indian Rupee formatting

The current dashboard uses sample data. Real transaction data will be connected later.

Dashboard Debugging and Development Notes

The dashboard went through several iterations before reaching its current state. The problems below were encountered during development and were fixed before moving forward.

Documenting these issues is intentional. The goal is to keep a record of how the application was actually developed rather than presenting only the final result.

1. The default Flutter test was still expecting MyApp
What happened

The Flutter project was initially generated from the standard Flutter template.

The generated test expected the default application class:

MyApp

After the project foundation was introduced, the application was renamed to:

PersonalFinanceApp

The original test was therefore no longer testing the application that was actually being built.

Flutter reported:

The name 'MyApp' isn't a class.
How it was fixed

The generated test was replaced with a test for the actual application:

await tester.pumpWidget(const PersonalFinanceApp());

The test was then changed to verify important dashboard content instead of the original Flutter counter example.

This made the test relevant to the actual product.

2. The first dashboard test failed with Bad state: Too many elements
What happened

An early version of the test attempted to find the Recent Transactions section using:

await tester.scrollUntilVisible(...)

The dashboard contains more than one scrollable widget.

Because of that, Flutter could not determine which scrollable widget should perform the scrolling operation.

The test failed with:

Bad state: Too many elements
How it was fixed

Instead of making the test depend on the internal scrolling structure, the dashboard test was simplified into a smoke test.

The test now checks that important dashboard elements are present:

Your financial overview
Total balance
₹84,250
Income
Expenses
Savings
Spending overview
Recent transactions
Salary
Groceries

This makes the test less fragile and focuses it on what the user should actually see.

3. The Indian Rupee symbol displayed incorrectly
What happened

The first dashboard version did not render the Indian Rupee symbol correctly.

Instead of:

₹84,250

the browser displayed something similar to:

â‚¹84,250

The same problem affected other currency values.

How it was fixed

The currency formatter was changed to use the Unicode representation of the Indian Rupee symbol:

symbol: '\u20B9',

The hard-coded balance value was also written using the Unicode representation:

'\u20B984,250'

The result now renders correctly:

₹84,250
₹45,000
₹27,450
₹17,550

This also keeps the currency formatting consistent across the dashboard.

4. The chart displayed the weekdays repeatedly
What happened

The first version of the spending chart showed labels similar to:

Mon Mon Mon Mon Mon Tue Tue Tue ...

The chart was technically rendering, but the X-axis was clearly incorrect and difficult to read.

How it was fixed

The chart configuration was updated so that each data point corresponds to exactly one weekday.

The intended axis is:

Mon   Tue   Wed   Thu   Fri   Sat   Sun

The chart now uses a fixed interval:

interval: 1,

and maps each X position to one label.

5. The spending chart tooltip showed incorrect values
What happened

The first chart implementation treated its values as though they were already measured in thousands and then appended k manually.

This caused the tooltip to display values such as:

₹120.0k

even though the underlying sample data did not represent that amount.

How it was fixed

The chart data was changed to represent actual rupee amounts.

Example data now represents:

₹1,800
₹2,700
₹2,000
₹3,400
₹2,700
₹4,200
₹3,100

The tooltip now uses the same Indian currency formatter as the rest of the dashboard.

For example:

₹4,200

instead of:

₹120.0k

This keeps the chart values and displayed values consistent.

6. The desktop chart occupied too much of the page
What happened

The first dashboard layout placed the spending chart across almost the full available width.

Because of that, the chart became the dominant element on the page and the Recent Transactions section was pushed much further down.

For a desktop dashboard, this was not an efficient use of space.

How it was fixed

The lower part of the dashboard was redesigned into a responsive layout.

On wider screens:

┌──────────────────────────────┬──────────────────────┐
│ Spending overview            │ Recent transactions  │
│                              │                      │
│            Chart             │ Salary               │
│                              │ Groceries            │
│                              │ Electricity          │
│                              │ Coffee               │
└──────────────────────────────┴──────────────────────┘

On smaller screens, the two sections stack vertically.

This makes the dashboard work more naturally across different screen sizes.

7. A chart color triggered an analyzer warning
What happened

Flutter's analyzer reported:

Instances of 'Color' should be created using an 8-digit hexadecimal integer

The affected dashboard color had an incorrect hexadecimal representation.

How it was fixed

The color was corrected to a valid 8-digit ARGB value:

Color(0x24FFFFFF)

This represents a translucent white value and follows Flutter's expected full hexadecimal format.

8. An unnecessary const was reported
What happened

After correcting the color value, Flutter reported:

Unnecessary 'const' keyword

This happened because the surrounding widget tree was already constant and the nested const was unnecessary.

How it was fixed

The unnecessary keyword was removed while keeping the widget tree valid.

The goal was to finish the dashboard with:

flutter analyze
No issues found!

rather than leaving code-quality warnings behind.

9. The dashboard was visually checked after the fixes

The dashboard was not treated as complete simply because the application compiled.

It was opened through Flutter Web and visually checked in Chrome.

The final dashboard was inspected for:

Correct ₹ symbol
Correct currency formatting
Correct weekday labels
Correct chart tooltip values
Balance card
Income card
Expense card
Savings card
Recent transactions
Sidebar navigation
Responsive layout
Theme toggle
Dark theme appearance

The resulting dashboard now presents the main information in a much more balanced layout.

Testing the Dashboard

The dashboard has been checked using both automated tests and visual testing.

Static Analysis

The project is checked with:

flutter analyze

The intended final result is:

No issues found!

This catches syntax problems, API problems, analyzer warnings, and other code-quality issues before changes are committed.

Widget Testing

The project is checked with:

flutter test

The dashboard test verifies important user-visible elements rather than depending on internal scrolling behavior.

The intended result is:

All tests passed!
Web Testing

The application is currently developed primarily using Flutter Web.

Run:

flutter run -d web-server

Flutter starts a local development server and provides a localhost address.

That address is opened in Google Chrome for visual testing.

This workflow provides a fast development loop without depending on the Android emulator for everyday dashboard development.

Current Dashboard

The current dashboard follows this general structure:

FinTrack
│
├── Dashboard
├── Transactions
├── Budgets
├── Reports
├── Categories
└── Settings

Dashboard

Good morning, Adithya
Your financial overview

┌────────────────────────────────────────────┐
│ Total balance                       Healthy│
│ ₹84,250                                    │
│ +12.8% from last month                     │
└────────────────────────────────────────────┘

┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ Income       │ │ Expenses     │ │ Savings      │
│ ₹45,000      │ │ ₹27,450      │ │ ₹17,550      │
└──────────────┘ └──────────────┘ └──────────────┘

┌────────────────────────────┬────────────────────┐
│ Spending overview          │ Recent transactions│
│                            │                    │
│ Mon Tue Wed Thu Fri Sat Sun│ Salary             │
│                            │ Groceries          │
│           Chart            │ Electricity        │
│                            │ Coffee             │
└────────────────────────────┴────────────────────┘

The dashboard currently contains representative data. Later versions will calculate these values from real transactions stored by the application.

Git Development History

The repository is being developed with meaningful commits rather than artificial commits made only to increase the commit count.

Commit 1
chore: initialize flutter project

Created the initial Flutter project and Git repository.

Commit 2
chore: establish project architecture and design system

Introduced the feature-first project structure, application foundation, centralized theme system, colors, typography, and light/dark theme support.

Commit 3
docs: update project README

Updated the README with the project overview, technology stack, architecture, and development direction.

Current Dashboard Milestone

The dashboard implementation is currently being prepared for:

feat: build responsive app shell and dashboard

This milestone contains the dashboard UI, responsive navigation, summary cards, chart, recent transactions, INR formatting, and the debugging fixes documented above.

Running the Project

Clone the repository:

git clone https://github.com/anonymousorg9/Personal-Expense-Tracker.git

Enter the project directory:

cd Personal-Expense-Tracker

Install dependencies:

flutter pub get

Run static analysis:

flutter analyze

Run tests:

flutter test

Run the web development server:

flutter run -d web-server

Open the generated localhost URL in Google Chrome.

Development Approach

The project is being developed one meaningful stage at a time.

The idea is to finish each major part properly before moving on to the next one.

Project setup
      ↓
Architecture
      ↓
Design system
      ↓
Dashboard
      ↓
Transaction management
      ↓
Categories
      ↓
Budgets
      ↓
Reports
      ↓
Data persistence
      ↓
Testing and polish
      ↓
Release

Each major stage is tested before it becomes part of the stable project history.

What This Project Is Intended to Demonstrate

This project is intended to demonstrate practical software development skills rather than simply produce another basic Flutter CRUD application.

It is being built to demonstrate:

Flutter application development
Dart programming
Responsive UI design
State management
Reusable components
Theme management
Data visualization
Widget testing
Static analysis
Git and GitHub workflow
Incremental feature development
Debugging and problem solving
Attention to UI/UX
Production-oriented project organization
Author

Adithya Salaka

Built with Flutter and Dart.

License

#This project is currently being developed as a personal/academic portfolio project.