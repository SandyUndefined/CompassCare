import { useQuery } from "@tanstack/react-query";
import type { Document } from "@shared/schema";
import { Card, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { FileText, File, FileSpreadsheet, FileImage } from "lucide-react";

function getDocIcon(type: string) {
  switch (type.toUpperCase()) {
    case "PDF":
      return <FileText className="w-6 h-6" />;
    case "XLSX":
    case "CSV":
      return <FileSpreadsheet className="w-6 h-6" />;
    case "JPG":
    case "PNG":
      return <FileImage className="w-6 h-6" />;
    default:
      return <File className="w-6 h-6" />;
  }
}

export function DocumentsTab() {
  const { data: documents, isLoading } = useQuery<Document[]>({
    queryKey: ["/api/documents"],
  });

  if (isLoading) {
    return (
      <div className="space-y-4">
        <div className="flex justify-between items-center flex-wrap gap-2">
          <Skeleton className="h-8 w-48" />
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {[1, 2, 3, 4].map((i) => (
            <Card key={i}>
              <CardContent className="p-4">
                <div className="flex items-start gap-3">
                  <Skeleton className="w-12 h-12 rounded-md" />
                  <div className="space-y-2 flex-1">
                    <Skeleton className="h-4 w-32" />
                    <Skeleton className="h-3 w-24" />
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center flex-wrap gap-2">
        <h2 className="text-xl font-semibold" data-testid="text-documents-title">
          Medical Documents
        </h2>
      </div>

      {documents && documents.length === 0 && (
        <Card>
          <CardContent className="p-8 flex flex-col items-center justify-center text-center">
            <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center mb-4">
              <FileText className="w-7 h-7 text-primary" />
            </div>
            <h3 className="font-semibold text-lg mb-1">No documents yet</h3>
            <p className="text-muted-foreground text-sm max-w-sm">
              Documents like insurance cards, lab results, and medical records will appear here.
            </p>
          </CardContent>
        </Card>
      )}

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {documents?.map((doc) => (
          <Card
            key={doc.id}
            className="hover-elevate cursor-pointer"
            data-testid={`card-document-${doc.id}`}
          >
            <CardContent className="p-4">
              <div className="flex items-start gap-3">
                <div className="w-11 h-11 rounded-md bg-destructive/10 flex items-center justify-center text-destructive shrink-0">
                  {getDocIcon(doc.type)}
                </div>
                <div className="flex-1 min-w-0">
                  <h3 className="font-semibold text-sm mb-0.5 truncate" data-testid={`text-doc-name-${doc.id}`}>
                    {doc.name}
                  </h3>
                  <p className="text-xs text-muted-foreground">{doc.date}</p>
                  <p className="text-[10px] text-muted-foreground mt-0.5 uppercase tracking-wide">
                    {doc.type}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
