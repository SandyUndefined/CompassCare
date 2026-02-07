import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { queryClient, apiRequest } from "@/lib/queryClient";
import { useToast } from "@/hooks/use-toast";
import type { Medication, InsertMedication } from "@shared/schema";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Pill, Plus, Clock, Check, AlertTriangle } from "lucide-react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { insertMedicationSchema } from "@shared/schema";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

export function MedicationsTab() {
  const [showAddDialog, setShowAddDialog] = useState(false);
  const { toast } = useToast();

  const { data: medications, isLoading } = useQuery<Medication[]>({
    queryKey: ["/api/medications"],
  });

  const form = useForm<InsertMedication>({
    resolver: zodResolver(
      insertMedicationSchema.extend({
        name: insertMedicationSchema.shape.name.min(1, "Name is required"),
        dosage: insertMedicationSchema.shape.dosage.min(1, "Dosage is required"),
      })
    ),
    defaultValues: {
      name: "",
      dosage: "",
      frequency: "Once daily",
      time: "",
      lastTaken: null,
      nextDue: null,
      critical: false,
    },
  });

  const addMutation = useMutation({
    mutationFn: async (data: InsertMedication) => {
      const res = await apiRequest("POST", "/api/medications", data);
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/medications"] });
      setShowAddDialog(false);
      form.reset();
      toast({ title: "Medication added", description: "The medication has been added to the schedule." });
    },
    onError: (error: Error) => {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    },
  });

  const markTakenMutation = useMutation({
    mutationFn: async (id: number) => {
      const res = await apiRequest("PATCH", `/api/medications/${id}/taken`);
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/medications"] });
      toast({ title: "Marked as taken", description: "Medication has been logged." });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await apiRequest("DELETE", `/api/medications/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/medications"] });
      toast({ title: "Medication removed" });
    },
  });

  const onSubmit = (data: InsertMedication) => {
    addMutation.mutate(data);
  };

  if (isLoading) {
    return (
      <div className="space-y-4">
        <div className="flex justify-between items-center flex-wrap gap-2">
          <Skeleton className="h-8 w-48" />
          <Skeleton className="h-9 w-36" />
        </div>
        {[1, 2, 3].map((i) => (
          <Card key={i}>
            <CardContent className="p-5">
              <div className="space-y-3">
                <Skeleton className="h-5 w-40" />
                <Skeleton className="h-4 w-56" />
                <div className="flex gap-8">
                  <Skeleton className="h-4 w-24" />
                  <Skeleton className="h-4 w-32" />
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
      <div className="flex justify-between items-center flex-wrap gap-2">
        <h2 className="text-xl font-semibold" data-testid="text-medications-title">
          Medication Schedule
        </h2>
        <Button onClick={() => setShowAddDialog(true)} data-testid="button-add-medication">
          <Plus className="w-4 h-4" />
          Add Medication
        </Button>
      </div>

      {medications && medications.length === 0 && (
        <Card>
          <CardContent className="p-8 flex flex-col items-center justify-center text-center">
            <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center mb-4">
              <Pill className="w-7 h-7 text-primary" />
            </div>
            <h3 className="font-semibold text-lg mb-1">No medications yet</h3>
            <p className="text-muted-foreground text-sm max-w-sm">
              Add medications to keep track of dosages, schedules, and who administered them.
            </p>
          </CardContent>
        </Card>
      )}

      {medications?.map((med) => (
        <Card key={med.id} className="hover-elevate" data-testid={`card-medication-${med.id}`}>
          <CardContent className="p-5">
            <div className="flex justify-between items-start gap-4 flex-wrap">
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                  <h3 className="text-base font-semibold" data-testid={`text-med-name-${med.id}`}>
                    {med.name}
                  </h3>
                  {med.critical && (
                    <Badge variant="destructive" className="text-[10px] no-default-hover-elevate">
                      <AlertTriangle className="w-3 h-3 mr-0.5" />
                      CRITICAL
                    </Badge>
                  )}
                </div>
                <p className="text-sm text-muted-foreground mb-3">
                  {med.dosage} &middot; {med.frequency}
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-sm">
                  <div>
                    <p className="text-muted-foreground text-xs mb-0.5">Schedule</p>
                    <p className="font-medium flex items-center gap-1.5">
                      <Clock className="w-3.5 h-3.5 text-muted-foreground" />
                      {med.time}
                    </p>
                  </div>
                  <div>
                    <p className="text-muted-foreground text-xs mb-0.5">Last Taken</p>
                    <p className="font-medium">{med.lastTaken || "Not yet taken"}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground text-xs mb-0.5">Next Due</p>
                    <p className="font-medium">{med.nextDue || "Pending"}</p>
                  </div>
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => markTakenMutation.mutate(med.id)}
                  disabled={markTakenMutation.isPending}
                  className="text-status-online border-status-online/30 bg-status-online/5"
                  data-testid={`button-mark-taken-${med.id}`}
                >
                  <Check className="w-3.5 h-3.5" />
                  Mark Taken
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => deleteMutation.mutate(med.id)}
                  className="text-destructive"
                  data-testid={`button-delete-med-${med.id}`}
                >
                  Remove
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      ))}

      <Dialog open={showAddDialog} onOpenChange={setShowAddDialog}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Add Medication</DialogTitle>
            <DialogDescription>
              Add a new medication to the care schedule.
            </DialogDescription>
          </DialogHeader>
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
              <FormField
                control={form.control}
                name="name"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Medication Name</FormLabel>
                    <FormControl>
                      <Input placeholder="e.g. Lisinopril" {...field} data-testid="input-med-name" />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <div className="grid grid-cols-2 gap-3">
                <FormField
                  control={form.control}
                  name="dosage"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Dosage</FormLabel>
                      <FormControl>
                        <Input placeholder="e.g. 10mg" {...field} data-testid="input-med-dosage" />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="time"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Time</FormLabel>
                      <FormControl>
                        <Input placeholder="e.g. 8:00 AM" {...field} data-testid="input-med-time" />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
              <FormField
                control={form.control}
                name="frequency"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Frequency</FormLabel>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <FormControl>
                        <SelectTrigger data-testid="select-med-frequency">
                          <SelectValue placeholder="Select frequency" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value="Once daily">Once daily</SelectItem>
                        <SelectItem value="Twice daily">Twice daily</SelectItem>
                        <SelectItem value="Three times daily">Three times daily</SelectItem>
                        <SelectItem value="As needed">As needed</SelectItem>
                        <SelectItem value="Weekly">Weekly</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="critical"
                render={({ field }) => (
                  <FormItem className="flex items-center gap-3">
                    <FormControl>
                      <input
                        type="checkbox"
                        checked={field.value}
                        onChange={field.onChange}
                        className="h-4 w-4 rounded border-input accent-primary"
                        data-testid="checkbox-med-critical"
                      />
                    </FormControl>
                    <FormLabel className="!mt-0 text-sm font-normal">
                      Mark as critical medication
                    </FormLabel>
                  </FormItem>
                )}
              />
              <DialogFooter>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setShowAddDialog(false)}
                  data-testid="button-cancel-add-med"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  disabled={addMutation.isPending}
                  data-testid="button-submit-add-med"
                >
                  {addMutation.isPending ? "Adding..." : "Add Medication"}
                </Button>
              </DialogFooter>
            </form>
          </Form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
