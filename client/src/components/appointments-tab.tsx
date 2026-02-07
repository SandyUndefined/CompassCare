import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { queryClient, apiRequest } from "@/lib/queryClient";
import { useToast } from "@/hooks/use-toast";
import type { Appointment, InsertAppointment } from "@shared/schema";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Calendar, MapPin, Users, Plus, StickyNote, Trash2 } from "lucide-react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { insertAppointmentSchema } from "@shared/schema";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

export function AppointmentsTab() {
  const [showAddDialog, setShowAddDialog] = useState(false);
  const { toast } = useToast();

  const { data: appointments, isLoading } = useQuery<Appointment[]>({
    queryKey: ["/api/appointments"],
  });

  const form = useForm<InsertAppointment>({
    resolver: zodResolver(
      insertAppointmentSchema.extend({
        type: insertAppointmentSchema.shape.type.min(1, "Type is required"),
        doctor: insertAppointmentSchema.shape.doctor.min(1, "Doctor is required"),
        date: insertAppointmentSchema.shape.date.min(1, "Date is required"),
      })
    ),
    defaultValues: {
      type: "",
      doctor: "",
      date: "",
      time: "",
      location: "",
      assignedTo: "",
      notes: "",
    },
  });

  const addMutation = useMutation({
    mutationFn: async (data: InsertAppointment) => {
      const res = await apiRequest("POST", "/api/appointments", data);
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/appointments"] });
      setShowAddDialog(false);
      form.reset();
      toast({ title: "Appointment added", description: "The appointment has been scheduled." });
    },
    onError: (error: Error) => {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await apiRequest("DELETE", `/api/appointments/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/appointments"] });
      toast({ title: "Appointment removed" });
    },
  });

  const onSubmit = (data: InsertAppointment) => {
    addMutation.mutate(data);
  };

  if (isLoading) {
    return (
      <div className="space-y-4">
        <div className="flex justify-between items-center flex-wrap gap-2">
          <Skeleton className="h-8 w-48" />
          <Skeleton className="h-9 w-40" />
        </div>
        {[1, 2].map((i) => (
          <Card key={i}>
            <CardContent className="p-5">
              <div className="space-y-3">
                <Skeleton className="h-5 w-36" />
                <Skeleton className="h-4 w-48" />
                <Skeleton className="h-4 w-32" />
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
        <h2 className="text-xl font-semibold" data-testid="text-appointments-title">
          Upcoming Appointments
        </h2>
        <Button onClick={() => setShowAddDialog(true)} data-testid="button-add-appointment">
          <Plus className="w-4 h-4" />
          Add Appointment
        </Button>
      </div>

      {appointments && appointments.length === 0 && (
        <Card>
          <CardContent className="p-8 flex flex-col items-center justify-center text-center">
            <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center mb-4">
              <Calendar className="w-7 h-7 text-primary" />
            </div>
            <h3 className="font-semibold text-lg mb-1">No appointments scheduled</h3>
            <p className="text-muted-foreground text-sm max-w-sm">
              Schedule appointments to keep the care team informed and prepared.
            </p>
          </CardContent>
        </Card>
      )}

      {appointments?.map((appt) => (
        <Card key={appt.id} className="hover-elevate" data-testid={`card-appointment-${appt.id}`}>
          <CardContent className="p-5">
            <div className="flex justify-between items-start gap-4 mb-3 flex-wrap">
              <div>
                <h3 className="text-base font-semibold" data-testid={`text-appt-type-${appt.id}`}>
                  {appt.type}
                </h3>
                <p className="text-sm text-muted-foreground">{appt.doctor}</p>
              </div>
              <div className="text-right flex items-center gap-2">
                <div>
                  <p className="font-semibold text-primary text-sm">{appt.date}</p>
                  <p className="text-sm text-muted-foreground">{appt.time}</p>
                </div>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => deleteMutation.mutate(appt.id)}
                  className="text-muted-foreground"
                  data-testid={`button-delete-appt-${appt.id}`}
                >
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>
            </div>
            <div className="space-y-1.5 text-sm">
              {appt.location && (
                <div className="flex items-center gap-2 text-muted-foreground">
                  <MapPin className="w-3.5 h-3.5 shrink-0" />
                  <span>{appt.location}</span>
                </div>
              )}
              {appt.assignedTo && (
                <div className="flex items-center gap-2 text-muted-foreground">
                  <Users className="w-3.5 h-3.5 shrink-0" />
                  <span>
                    Assigned to: <span className="font-medium text-foreground">{appt.assignedTo}</span>
                  </span>
                </div>
              )}
              {appt.notes && (
                <div className="mt-3 rounded-md bg-accent/50 p-3 flex items-start gap-2">
                  <StickyNote className="w-3.5 h-3.5 mt-0.5 text-muted-foreground shrink-0" />
                  <p className="text-sm text-muted-foreground">{appt.notes}</p>
                </div>
              )}
            </div>
          </CardContent>
        </Card>
      ))}

      <Dialog open={showAddDialog} onOpenChange={setShowAddDialog}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Add Appointment</DialogTitle>
            <DialogDescription>
              Schedule a new appointment for your care plan.
            </DialogDescription>
          </DialogHeader>
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
              <div className="grid grid-cols-2 gap-3">
                <FormField
                  control={form.control}
                  name="type"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Type</FormLabel>
                      <FormControl>
                        <Input placeholder="e.g. Cardiology" {...field} data-testid="input-appt-type" />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="doctor"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Doctor</FormLabel>
                      <FormControl>
                        <Input placeholder="e.g. Dr. Johnson" {...field} data-testid="input-appt-doctor" />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <FormField
                  control={form.control}
                  name="date"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Date</FormLabel>
                      <FormControl>
                        <Input placeholder="e.g. Feb 20, 2026" {...field} data-testid="input-appt-date" />
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
                        <Input placeholder="e.g. 2:30 PM" {...field} data-testid="input-appt-time" />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
              <FormField
                control={form.control}
                name="location"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Location</FormLabel>
                    <FormControl>
                      <Input placeholder="e.g. Memorial Hospital" {...field} data-testid="input-appt-location" />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="assignedTo"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Assigned To</FormLabel>
                    <FormControl>
                      <Input placeholder="e.g. Sarah" {...field} data-testid="input-appt-assigned" />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="notes"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Notes</FormLabel>
                    <FormControl>
                      <Textarea
                        placeholder="Any notes or reminders for this appointment"
                        {...field}
                        value={field.value || ""}
                        data-testid="input-appt-notes"
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <DialogFooter>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setShowAddDialog(false)}
                  data-testid="button-cancel-add-appt"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  disabled={addMutation.isPending}
                  data-testid="button-submit-add-appt"
                >
                  {addMutation.isPending ? "Adding..." : "Add Appointment"}
                </Button>
              </DialogFooter>
            </form>
          </Form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
