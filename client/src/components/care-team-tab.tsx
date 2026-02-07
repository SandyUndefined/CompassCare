import { useQuery } from "@tanstack/react-query";
import type { CareTeamMember } from "@shared/schema";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import { MessageSquare, UserPlus } from "lucide-react";

function OnlineIndicator({ online }: { online: boolean }) {
  return (
    <div
      className={`absolute bottom-0 right-0 w-3.5 h-3.5 rounded-full border-2 border-card ${
        online ? "bg-status-online" : "bg-status-offline"
      }`}
    />
  );
}

export function CareTeamTab() {
  const { data: careTeam, isLoading } = useQuery<CareTeamMember[]>({
    queryKey: ["/api/care-team"],
  });

  if (isLoading) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-8 w-48" />
        {[1, 2, 3].map((i) => (
          <Card key={i}>
            <CardContent className="p-5">
              <div className="flex items-center gap-4">
                <Skeleton className="w-14 h-14 rounded-full" />
                <div className="space-y-2 flex-1">
                  <Skeleton className="h-5 w-24" />
                  <Skeleton className="h-4 w-20" />
                  <Skeleton className="h-3 w-36" />
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-semibold" data-testid="text-team-title">
        Care Team Members
      </h2>

      {careTeam && careTeam.length === 0 && (
        <Card>
          <CardContent className="p-8 flex flex-col items-center justify-center text-center">
            <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center mb-4">
              <UserPlus className="w-7 h-7 text-primary" />
            </div>
            <h3 className="font-semibold text-lg mb-1">No team members yet</h3>
            <p className="text-muted-foreground text-sm max-w-sm">
              Add family members or caregivers to coordinate care together.
            </p>
          </CardContent>
        </Card>
      )}

      {careTeam?.map((member) => (
        <Card key={member.id} className="hover-elevate" data-testid={`card-team-member-${member.id}`}>
          <CardContent className="p-5">
            <div className="flex items-center gap-4">
              <div className="relative">
                <Avatar className="w-14 h-14">
                  <AvatarFallback className="bg-primary/10 text-primary text-lg font-semibold">
                    {member.name[0]}
                  </AvatarFallback>
                </Avatar>
                <OnlineIndicator online={member.online} />
              </div>
              <div className="flex-1 min-w-0">
                <h3 className="font-semibold" data-testid={`text-member-name-${member.id}`}>
                  {member.name}
                </h3>
                <p className="text-sm text-muted-foreground">{member.role}</p>
                <p className="text-xs text-muted-foreground mt-0.5 flex items-center gap-1.5">
                  <span
                    className={`inline-block w-2 h-2 rounded-full ${
                      member.online ? "bg-status-online" : "bg-status-offline"
                    }`}
                  />
                  {member.online ? "Online" : "Offline"}
                  {member.lastActive && ` \u00B7 Last active: ${member.lastActive}`}
                </p>
              </div>
              <Button variant="outline" size="sm" data-testid={`button-message-${member.id}`}>
                <MessageSquare className="w-4 h-4" />
                Message
              </Button>
            </div>
          </CardContent>
        </Card>
      ))}

      <Card className="border-dashed hover-elevate cursor-pointer" data-testid="button-invite-member">
        <CardContent className="p-4 flex items-center justify-center gap-2 text-muted-foreground">
          <UserPlus className="w-4 h-4" />
          <span className="text-sm font-medium">Invite Care Team Member</span>
        </CardContent>
      </Card>
    </div>
  );
}
