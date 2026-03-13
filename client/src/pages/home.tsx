import { useQuery } from "@tanstack/react-query";
import { Link } from "wouter";
import type { CareTeamMember } from "@shared/schema";
import { CompassLogo } from "@/components/compass-logo";
import { ThemeToggle } from "@/components/theme-toggle";
import { MedicationsTab } from "@/components/medications-tab";
import { AppointmentsTab } from "@/components/appointments-tab";
import { DocumentsTab } from "@/components/documents-tab";
import { CareTeamTab } from "@/components/care-team-tab";
import { ShoppingTab } from "@/components/shopping-tab";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Pill, Calendar, FileText, Users, ShoppingBag } from "lucide-react";

export default function Home() {
  const { data: careTeam } = useQuery<CareTeamMember[]>({
    queryKey: ["/api/care-team"],
  });

  return (
    <div className="min-h-screen bg-background">
      <header className="sticky top-0 z-50 bg-background/80 backdrop-blur-md border-b">
        <div className="max-w-5xl mx-auto px-4 py-3">
          <div className="flex items-center justify-between gap-4 flex-wrap">
            <div className="flex items-center gap-3">
              <CompassLogo size={36} className="text-primary" />
              <div>
                <h1 className="text-lg font-bold leading-tight" data-testid="text-app-title">
                  CompassCare
                </h1>
                <p className="text-xs text-muted-foreground">Caring for Mom</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="flex -space-x-1.5">
                {careTeam?.map((member) => (
                  <div key={member.id} className="relative" data-testid={`avatar-team-${member.id}`}>
                    <Avatar className="w-8 h-8 border-2 border-background">
                      <AvatarFallback className="text-xs font-semibold bg-primary/10 text-primary">
                        {member.name[0]}
                      </AvatarFallback>
                    </Avatar>
                    {member.online && (
                      <div className="absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 bg-status-online rounded-full border-2 border-background" />
                    )}
                  </div>
                ))}
              </div>
              <ThemeToggle />
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 py-6">
        <Tabs defaultValue="medications" className="space-y-6">
          <TabsList className="w-full h-auto flex-wrap gap-1 bg-card p-1.5 rounded-md" data-testid="tabs-navigation">
            <TabsTrigger value="medications" className="flex-1 min-w-[120px] gap-1.5" data-testid="tab-medications">
              <Pill className="w-4 h-4" />
              <span className="hidden sm:inline">Medications</span>
              <span className="sm:hidden">Meds</span>
            </TabsTrigger>
            <TabsTrigger value="appointments" className="flex-1 min-w-[120px] gap-1.5" data-testid="tab-appointments">
              <Calendar className="w-4 h-4" />
              <span className="hidden sm:inline">Appointments</span>
              <span className="sm:hidden">Appts</span>
            </TabsTrigger>
            <TabsTrigger value="documents" className="flex-1 min-w-[120px] gap-1.5" data-testid="tab-documents">
              <FileText className="w-4 h-4" />
              <span>Documents</span>
            </TabsTrigger>
            <TabsTrigger value="team" className="flex-1 min-w-[120px] gap-1.5" data-testid="tab-team">
              <Users className="w-4 h-4" />
              <span className="hidden sm:inline">Care Team</span>
              <span className="sm:hidden">Team</span>
            </TabsTrigger>
            <TabsTrigger value="shopping" className="flex-1 min-w-[120px] gap-1.5" data-testid="tab-shopping">
              <ShoppingBag className="w-4 h-4" />
              <span>Shopping</span>
            </TabsTrigger>
          </TabsList>

          <TabsContent value="medications">
            <MedicationsTab />
          </TabsContent>

          <TabsContent value="appointments">
            <AppointmentsTab />
          </TabsContent>

          <TabsContent value="documents">
            <DocumentsTab />
          </TabsContent>

          <TabsContent value="team">
            <CareTeamTab />
          </TabsContent>

          <TabsContent value="shopping">
            <ShoppingTab />
          </TabsContent>
        </Tabs>

        <footer className="mt-10 flex flex-col gap-3 border-t pt-6 text-sm text-muted-foreground sm:flex-row sm:items-center sm:justify-between">
          <p>CompassCare helps families organize caregiving information in one place.</p>
          <Button asChild variant="outline" size="sm">
            <Link href="/privacy-policy">Privacy Policy</Link>
          </Button>
        </footer>
      </main>
    </div>
  );
}
