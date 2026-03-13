import { Link } from "wouter";
import { Shield, ExternalLink } from "lucide-react";
import { CompassLogo } from "@/components/compass-logo";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

const sections = [
  {
    title: "Information We Collect",
    paragraphs: [
      "CompassCare is designed to help users organize caregiving information. Depending on how you use the app, the application may collect and store medication details, appointment details, care team names and roles, and document metadata such as document names, dates, and file types.",
      "The mobile application also stores cached copies of this information on the device using local SQLite storage to support faster loading and offline access. The app does not request access to the device camera, microphone, contacts, photos, or precise location based on the current implementation.",
    ],
  },
  {
    title: "How We Use Information",
    paragraphs: [
      "We use the information processed through CompassCare to provide the app's core caregiving features, including medication tracking, appointment management, document organization, care team display, and personalized shopping suggestions related to caregiving supplies.",
      "We may also use technical information such as request timing, error details, and general server logs to maintain the service, debug issues, and improve performance and reliability.",
    ],
  },
  {
    title: "Shopping Links and Third Parties",
    paragraphs: [
      "CompassCare includes shopping links that may redirect users to third-party retailers such as Amazon. When a user opens one of those links, any information collected by the external retailer is governed by that third party's own privacy policy and terms.",
      "CompassCare may earn a commission from qualifying purchases made through those external links. The app does not control third-party websites or their data practices after a user leaves CompassCare.",
    ],
  },
  {
    title: "How Information Is Shared",
    paragraphs: [
      "We do not sell personal information. We may share information only as needed to operate the app, such as with hosting, database, analytics, security, or infrastructure service providers acting on our behalf, or when disclosure is required by law, regulation, legal process, or to protect rights and safety.",
      "If you use a deployment or backend managed by your organization, your organization may also have access to information processed through that environment.",
    ],
  },
  {
    title: "Data Retention",
    paragraphs: [
      "Information is retained for as long as needed to provide CompassCare and support legitimate operational, legal, and security needs. Cached information may remain on a user's device until the app is deleted, app data is cleared, or the cache is overwritten by newer data.",
      "If you operate your own CompassCare deployment, you are responsible for defining and enforcing your retention schedule for server-side data.",
    ],
  },
  {
    title: "Security",
    paragraphs: [
      "We use reasonable administrative, technical, and organizational measures to protect information processed by CompassCare. However, no method of electronic storage or transmission is completely secure, and we cannot guarantee absolute security.",
    ],
  },
  {
    title: "Children's Privacy",
    paragraphs: [
      "CompassCare is not directed to children under 13, and it is not intended for independent use by children. If you believe information from a child has been submitted to the app inappropriately, contact the publisher or support contact responsible for the deployed application.",
    ],
  },
  {
    title: "Your Choices",
    paragraphs: [
      "You can choose what caregiving information you enter into CompassCare. You may also stop using the app at any time, remove app data from your device, or request deletion through the operator of the specific CompassCare deployment you use, if server-side deletion is available.",
    ],
  },
  {
    title: "Changes to This Policy",
    paragraphs: [
      "We may update this Privacy Policy from time to time. When we do, we will update the effective date shown on this page. Continued use of CompassCare after an updated policy becomes effective means the updated policy will apply going forward.",
    ],
  },
  {
    title: "Contact",
    paragraphs: [
      "For privacy questions or requests, contact the publisher or support contact for the CompassCare app deployment you are using.",
      "Before submitting this app to Google Play or the Apple App Store, replace this contact section with your real privacy contact email and, if applicable, your business mailing address.",
    ],
  },
];

export default function PrivacyPolicy() {
  return (
    <div className="min-h-screen bg-background">
      <div className="border-b bg-background/90 backdrop-blur">
        <div className="mx-auto flex max-w-5xl items-center justify-between gap-4 px-4 py-4">
          <div className="flex items-center gap-3">
            <CompassLogo size={40} className="text-primary" />
            <div>
              <p className="text-xs font-medium uppercase tracking-[0.2em] text-muted-foreground">
                Legal
              </p>
              <h1 className="text-xl font-bold">CompassCare Privacy Policy</h1>
            </div>
          </div>
          <Button asChild variant="outline">
            <Link href="/">Back to App</Link>
          </Button>
        </div>
      </div>

      <main className="mx-auto max-w-5xl px-4 py-8">
        <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_280px]">
          <section className="space-y-6">
            <Card className="overflow-hidden">
              <div className="h-2 bg-gradient-to-r from-primary via-primary/70 to-secondary" />
              <CardHeader className="space-y-4">
                <div className="flex items-center gap-3 text-primary">
                  <Shield className="h-5 w-5" />
                  <span className="text-sm font-semibold uppercase tracking-[0.18em]">
                    Public Policy Page
                  </span>
                </div>
                <div>
                  <CardTitle className="text-3xl font-bold leading-tight">
                    Privacy Policy
                  </CardTitle>
                  <CardDescription className="mt-2 max-w-2xl text-sm leading-6">
                    Effective date: March 6, 2026. This policy describes how the
                    CompassCare application processes caregiving information across
                    its web and mobile experiences.
                  </CardDescription>
                </div>
              </CardHeader>
              <CardContent className="space-y-8">
                {sections.map((section) => (
                  <section key={section.title} className="space-y-3">
                    <h2 className="text-lg font-semibold">{section.title}</h2>
                    <div className="space-y-3 text-sm leading-7 text-muted-foreground">
                      {section.paragraphs.map((paragraph) => (
                        <p key={paragraph}>{paragraph}</p>
                      ))}
                    </div>
                  </section>
                ))}
              </CardContent>
            </Card>
          </section>

          <aside className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle className="text-lg">Store Submission Notes</CardTitle>
                <CardDescription>
                  This page is suitable as a public privacy policy URL for store review.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-3 text-sm text-muted-foreground">
                <p>Suggested public URL path: `/privacy-policy`</p>
                <p>
                  If you deploy the app on your production domain, use that full URL
                  in Google Play Console and App Store Connect.
                </p>
                <p>
                  Update the contact section before submission so the policy includes
                  your real support email.
                </p>
              </CardContent>
            </Card>

            <Card className="bg-accent/40">
              <CardHeader>
                <CardTitle className="text-base">Third-Party Links</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 text-sm text-muted-foreground">
                <p>
                  Shopping links may open external retailer sites in a browser or
                  external app.
                </p>
                <a
                  href="https://www.amazon.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-2 font-medium text-primary"
                >
                  Example retailer destination
                  <ExternalLink className="h-4 w-4" />
                </a>
              </CardContent>
            </Card>
          </aside>
        </div>
      </main>
    </div>
  );
}
