# CompassCare Store Submission Guide

Last updated: March 6, 2026

This file prepares store listing copy and privacy/compliance answers for the Flutter app in `mobile/compasscare_flutter`.

Package identifiers:
- Android application ID: `com.sandy.compasscare`
- iOS bundle ID: `com.sandy.compasscare`

Important assumptions used below:
- The production build uses HTTPS for the API base URL.
- The production site publishes the privacy policy at `https://YOUR-DOMAIN/privacy-policy`.
- The current Flutter app has no account creation, login, ads SDK, analytics SDK, crash reporting SDK, push notifications, or tracking SDK.
- The app does not request camera, microphone, contacts, photo library, Bluetooth, or location permissions in the current codebase.
- The app opens external shopping links in the device browser or external app.

Before submitting:
- Replace `https://YOUR-DOMAIN/privacy-policy` with your real public URL.
- Replace `support@yourdomain.com` with your real support/privacy contact.
- Recheck these answers if you add Firebase, authentication, notifications, ads, analytics, crash reporting, or new permissions.

## Google Play

### Store listing copy

App name:
`CompassCare`

Recommended category:
`Medical`

Short description:
`Organize medications, appointments, care teams, and medical documents.`

Full description:

```text
CompassCare helps families and caregivers keep important care information in one place.

Use CompassCare to:
- track medications and daily schedules
- add and review upcoming appointments
- keep important care documents organized
- view care team details at a glance
- access caregiving supply links and medication-related shopping suggestions

CompassCare is built for simple family caregiving coordination across everyday routines. The app stores caregiving information on device for faster access and syncs with its backend to keep data available when needed.

Key features:
- Medication tracking with dose timing and reminders
- Appointment planning with notes, provider, and location details
- Document list for important medical records
- Care team overview with status indicators
- Helpful shopping links for common caregiving supplies

CompassCare is not a medical device and does not diagnose, treat, cure, or prevent any medical condition. Always seek advice from a qualified healthcare professional regarding medical decisions.
```

### App content / policy answers

Ads:
`No, this app does not contain ads.`

App access:
`No login or demo account is required. Reviewers can open and use the app directly.`

Privacy policy URL:
`https://YOUR-DOMAIN/privacy-policy`

Support email:
`support@yourdomain.com`

### Data safety form

High-level answers:
- Does the app collect or share any required user data types: `Yes`
- Is any user data shared with third parties: `No`
- Is all user data collected by the app encrypted in transit: `Yes`, assuming your production API URL is HTTPS
- Can users request that their data be deleted: `No` in the current implementation unless you provide a manual deletion process outside the app

Recommended data types to declare:

1. `Health and fitness > Health info`
Reason:
Medication names, dosage, schedule, appointment details, and medical-document metadata are health-related information.

Collection:
- Collected: `Yes`
- Shared: `No`
- Processing is optional: `Yes`, users enter this information only if they choose to use those features
- Purpose: `App functionality`

2. `Personal info > Name`
Reason:
The app stores names such as doctor names, caregiver names, care-team names, and assigned caregiver names.

Collection:
- Collected: `Yes`
- Shared: `No`
- Processing is optional: `Yes`
- Purpose: `App functionality`

3. `App activity > Other user-generated content`
Reason:
The appointment notes field allows free-form text entered by the user.

Collection:
- Collected: `Yes`
- Shared: `No`
- Processing is optional: `Yes`
- Purpose: `App functionality`

Do not declare these unless your production build changes:
- Precise location
- Approximate location
- Financial info
- Contacts
- Photos and videos
- Audio files
- Files and docs from device storage
- Messages
- App interactions for analytics
- Crash logs
- Device or other IDs for tracking

### Health apps declaration

Use these answers if Play Console shows the Health apps declaration:

- Does your app have health features: `Yes`
- Does your app function as a medical device or make clinical/diagnostic claims: `No`
- Does your app access Health Connect data: `No`, based on the current codebase

Suggested policy statement for forms or reviewer notes:

```text
CompassCare helps users organize caregiving information such as medications, appointments, care-team details, and document metadata. It is not a medical device and does not provide diagnosis or treatment recommendations.
```

### Reviewer notes

```text
CompassCare does not require sign-in. The app opens directly into onboarding and the main caregiving workflow. A Privacy Policy link is available from the in-app app-bar menu, and the public policy URL is https://YOUR-DOMAIN/privacy-policy.
```

## Apple App Store

### App Store Connect metadata

App name:
`CompassCare`

Subtitle:
`Family caregiving organizer`

Primary category:
`Medical`

Secondary category:
`Productivity`

Promotional text:
`Keep medications, appointments, care-team details, and key documents organized in one caregiving app.`

Keywords:
`caregiver,medication,appointments,medical,eldercare,family,documents,health`

Description:

```text
CompassCare helps families organize day-to-day caregiving information in one place.

With CompassCare, you can:

- track medications and daily dose schedules
- organize appointments with provider, date, location, and notes
- review important document records
- keep care-team information easy to reach
- open helpful shopping links for common caregiving supplies

CompassCare is designed for practical family caregiving coordination and simple record-keeping.

Important:
CompassCare is not a medical device and does not provide medical advice, diagnosis, or treatment. Always consult a qualified healthcare professional for medical guidance.
```

Privacy Policy URL:
`https://YOUR-DOMAIN/privacy-policy`

Support URL:
`https://YOUR-DOMAIN/support`

App Review contact email:
`support@yourdomain.com`

App Review notes:

```text
No sign-in is required. Reviewers can launch the app and access all core flows immediately. The privacy policy is available from the in-app app-bar menu and at https://YOUR-DOMAIN/privacy-policy.
```

### App Privacy answers

Tracking:
- Data used to track users across apps or websites: `No`

Data linked to the user:

1. `Health & Fitness > Health`
Why:
The app processes medication schedules, appointment information, and medical-document metadata.

Selection:
- Collected: `Yes`
- Linked to user: `Yes`
- Used for tracking: `No`
- Purpose: `App Functionality`

2. `Contact Info > Name`
Why:
The app processes doctor names, caregiver names, and care-team names entered or displayed in the app.

Selection:
- Collected: `Yes`
- Linked to user: `Yes`
- Used for tracking: `No`
- Purpose: `App Functionality`

3. `User Content > Other User Content`
Why:
The appointment notes field accepts free-form text.

Selection:
- Collected: `Yes`
- Linked to user: `Yes`
- Used for tracking: `No`
- Purpose: `App Functionality`

Recommended answers for everything else in the current build:
- Contact Info > Email Address: `No`
- Contact Info > Phone Number: `No`
- Location: `No`
- Sensitive Info: `No`
- Contacts: `No`
- Browsing History: `No`
- Search History: `No`
- Identifiers: `No`
- Purchases: `No`
- Financial Info: `No`
- Usage Data: `No`
- Diagnostics: `No`

### Age rating guidance

Recommended starting point:
- Age rating: `4+`

The app does not include objectionable content categories in the current codebase. You should still answer the App Store Connect age-rating questionnaire based on the final shipped build.

## Current submission risk

The privacy answers above fit the current codebase. If you later add any of the following, you must update both stores before release:
- Firebase Analytics
- Crashlytics or other crash reporting
- Push notifications
- Authentication or account creation
- Email collection
- Device identifiers
- Additional permissions
- Uploading actual medical files or photos
