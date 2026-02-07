import { useQuery } from "@tanstack/react-query";
import type { Medication } from "@shared/schema";
import { Card, CardContent } from "@/components/ui/card";
import { Pill, Heart, Activity, Shield, ShoppingBag, ChevronRight, Sparkles, Info } from "lucide-react";

const categories = [
  {
    name: "Daily Living Aids",
    icon: Heart,
    search: "daily+living+aids+elderly",
    items: ["Grab bars", "Shower chairs", "Reachers"],
  },
  {
    name: "Mobility",
    icon: Activity,
    search: "mobility+aids+walker+cane",
    items: ["Walkers", "Canes", "Wheelchairs"],
  },
  {
    name: "Medical Supplies",
    icon: Sparkles,
    search: "medical+supplies+first+aid",
    items: ["Bandages", "Gauze", "Medical tape"],
  },
  {
    name: "Nutrition",
    icon: ShoppingBag,
    search: "senior+nutrition+supplements",
    items: ["Supplements", "Protein shakes", "Meal replacements"],
  },
  {
    name: "Safety & Comfort",
    icon: Shield,
    search: "home+safety+elderly+comfort",
    items: ["Bed rails", "Non-slip mats", "Cushions"],
  },
];

export function ShoppingTab() {
  const { data: medications } = useQuery<Medication[]>({
    queryKey: ["/api/medications"],
  });

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold mb-1" data-testid="text-shopping-title">
          Care Supplies & Medications
        </h2>
        <p className="text-sm text-muted-foreground">
          Quick access to essential care supplies. Save time with convenient delivery options.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <a
          href="https://www.amazon.com/s?k=medication+organizer"
          target="_blank"
          rel="noopener noreferrer"
          className="group"
          data-testid="link-medication-supplies"
        >
          <Card className="bg-primary text-primary-foreground border-primary-border h-full hover-elevate">
            <CardContent className="p-5">
              <div className="flex items-center gap-3 mb-2">
                <Pill className="w-7 h-7" />
                <h3 className="text-base font-semibold">Medication Supplies</h3>
              </div>
              <p className="text-sm opacity-80">
                Pill organizers, dispensers, reminders
              </p>
            </CardContent>
          </Card>
        </a>
        <a
          href="https://www.amazon.com/s?k=home+health+care+supplies"
          target="_blank"
          rel="noopener noreferrer"
          className="group"
          data-testid="link-health-monitoring"
        >
          <Card className="bg-secondary text-secondary-foreground border-secondary-border h-full hover-elevate">
            <CardContent className="p-5">
              <div className="flex items-center gap-3 mb-2">
                <Activity className="w-7 h-7" />
                <h3 className="text-base font-semibold">Health Monitoring</h3>
              </div>
              <p className="text-sm text-muted-foreground">
                Blood pressure monitors, thermometers, scales
              </p>
            </CardContent>
          </Card>
        </a>
      </div>

      <div>
        <h3 className="text-base font-semibold mb-3">Shop by Category</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {categories.map((category) => {
            const IconComp = category.icon;
            return (
              <a
                key={category.name}
                href={`https://www.amazon.com/s?k=${category.search}`}
                target="_blank"
                rel="noopener noreferrer"
                data-testid={`link-category-${category.name.toLowerCase().replace(/\s+/g, "-")}`}
              >
                <Card className="hover-elevate h-full">
                  <CardContent className="p-4">
                    <div className="w-9 h-9 rounded-md bg-primary/10 flex items-center justify-center mb-3">
                      <IconComp className="w-5 h-5 text-primary" />
                    </div>
                    <h4 className="font-semibold text-sm mb-2">{category.name}</h4>
                    <ul className="text-xs text-muted-foreground space-y-0.5">
                      {category.items.map((item) => (
                        <li key={item} className="flex items-center gap-1">
                          <span className="w-1 h-1 rounded-full bg-muted-foreground/40" />
                          {item}
                        </li>
                      ))}
                    </ul>
                  </CardContent>
                </Card>
              </a>
            );
          })}
        </div>
      </div>

      {medications && medications.length > 0 && (
        <Card className="bg-primary/5 border-primary/20">
          <CardContent className="p-5">
            <div className="flex items-start gap-4">
              <div className="w-11 h-11 rounded-md bg-primary flex items-center justify-center shrink-0">
                <Pill className="w-5 h-5 text-primary-foreground" />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold mb-1">Based on Your Medications</h3>
                <p className="text-sm text-muted-foreground mb-3">
                  Supplies that might help with managing your medication list:
                </p>
                <div className="space-y-2">
                  <a
                    href="https://www.amazon.com/s?k=weekly+pill+organizer"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center justify-between gap-2 rounded-md bg-background p-3 hover-elevate"
                    data-testid="link-pill-organizer"
                  >
                    <div>
                      <p className="font-medium text-sm">Weekly Pill Organizer</p>
                      <p className="text-xs text-muted-foreground">
                        For {medications.slice(0, 2).map((m) => m.name).join(" & ")}
                      </p>
                    </div>
                    <ChevronRight className="w-4 h-4 text-muted-foreground shrink-0" />
                  </a>
                  <a
                    href="https://www.amazon.com/s?k=pill+reminder+alarm"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center justify-between gap-2 rounded-md bg-background p-3 hover-elevate"
                    data-testid="link-pill-reminder"
                  >
                    <div>
                      <p className="font-medium text-sm">Medication Reminder Timer</p>
                      <p className="text-xs text-muted-foreground">
                        Never miss a dose with audio alerts
                      </p>
                    </div>
                    <ChevronRight className="w-4 h-4 text-muted-foreground shrink-0" />
                  </a>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      <Card className="bg-accent/50 border-accent">
        <CardContent className="p-3 flex items-start gap-2">
          <Info className="w-4 h-4 text-muted-foreground mt-0.5 shrink-0" />
          <p className="text-xs text-muted-foreground">
            <span className="font-medium">Shopping convenience:</span> CompassCare may earn a commission from qualifying purchases. This helps us keep the app free while providing you with quick access to essential care supplies.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
