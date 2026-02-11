import { cn } from "@/lib/utils";
import logoPath from "@assets/compasscare-logo-original_1770820871822.png";

interface CompassLogoProps {
  className?: string;
  size?: number;
}

export function CompassLogo({ className, size = 40 }: CompassLogoProps) {
  return (
    <img
      src={logoPath}
      alt="CompassCare Logo"
      className={cn("object-contain", className)}
      width={size}
      height={size}
    />
  );
}
