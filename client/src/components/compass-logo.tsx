import { cn } from "@/lib/utils";

interface CompassLogoProps {
  className?: string;
  size?: number;
}

export function CompassLogo({ className, size = 40 }: CompassLogoProps) {
  return (
    <svg
      className={cn(className)}
      width={size}
      height={size}
      viewBox="0 0 200 200"
      xmlns="http://www.w3.org/2000/svg"
    >
      <circle cx="100" cy="100" r="95" fill="currentColor" opacity="0.1" />
      <circle
        cx="100"
        cy="100"
        r="70"
        fill="none"
        stroke="currentColor"
        strokeWidth="3"
      />
      <circle cx="100" cy="30" r="4" fill="currentColor" />
      <circle cx="170" cy="100" r="4" fill="currentColor" />
      <circle cx="100" cy="170" r="4" fill="currentColor" />
      <circle cx="30" cy="100" r="4" fill="currentColor" />
      <g>
        <path
          d="M 100 100 L 95 60 L 100 45 L 105 60 Z"
          fill="hsl(0 72% 51%)"
          stroke="hsl(0 72% 46%)"
          strokeWidth="1"
        />
        <path
          d="M 100 100 L 95 140 L 100 155 L 105 140 Z"
          fill="hsl(243 75% 30%)"
          stroke="hsl(243 75% 25%)"
          strokeWidth="1"
        />
        <path
          d="M 100 100 L 140 95 L 155 100 L 140 105 Z"
          fill="hsl(243 75% 59%)"
          stroke="hsl(243 75% 54%)"
          strokeWidth="1"
        />
        <path
          d="M 100 100 L 60 95 L 45 100 L 60 105 Z"
          fill="hsl(243 75% 59%)"
          stroke="hsl(243 75% 54%)"
          strokeWidth="1"
        />
      </g>
      <circle
        cx="100"
        cy="100"
        r="8"
        fill="hsl(222 15% 12%)"
        stroke="hsl(220 15% 98%)"
        strokeWidth="2"
      />
      <path
        d="M 100 96 C 100 94, 98 92, 96 92 C 94 92, 93 93, 93 95 C 93 93, 92 92, 90 92 C 88 92, 86 94, 86 96 C 86 99, 88 101, 93 105 L 96 107 L 99 105 C 104 101, 106 99, 106 96 C 106 94, 104 92, 102 92 C 100 92, 99 93, 99 95 C 99 93, 98 92, 96 92 Z"
        fill="hsl(220 15% 98%)"
        transform="translate(4, 0) scale(1.3)"
      />
      <path
        d="M 60 60 A 56 56 0 0 1 140 60"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeDasharray="4,4"
        opacity="0.3"
      />
      <path
        d="M 140 140 A 56 56 0 0 1 60 140"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeDasharray="4,4"
        opacity="0.3"
      />
    </svg>
  );
}
