import { cn } from "@/lib/utils";
import logoPath from "@assets/5F3DC2E5-79B3-43EB-9C3A-85C86DF1FCA4_1770903947703.png";

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
