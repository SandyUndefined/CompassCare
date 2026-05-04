import crypto from "node:crypto";
import { promisify } from "node:util";
import type { User } from "@shared/schema";

const scryptAsync = promisify(crypto.scrypt);
const tokenTtlSeconds = 60 * 60 * 24 * 30;

type AuthTokenPayload = {
  sub: string;
  email: string;
  name?: string;
  exp: number;
};

export function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

export async function hashPassword(password: string): Promise<string> {
  const salt = crypto.randomBytes(16).toString("hex");
  const derivedKey = (await scryptAsync(password, salt, 64)) as Buffer;
  return `scrypt$${salt}$${derivedKey.toString("hex")}`;
}

export async function verifyPassword(
  password: string,
  passwordHash: string,
): Promise<boolean> {
  const [algorithm, salt, key] = passwordHash.split("$");

  if (algorithm !== "scrypt" || !salt || !key) {
    return false;
  }

  const derivedKey = (await scryptAsync(password, salt, 64)) as Buffer;
  const storedKey = Buffer.from(key, "hex");

  if (storedKey.length !== derivedKey.length) {
    return false;
  }

  return crypto.timingSafeEqual(storedKey, derivedKey);
}

export function createAuthToken(user: User, displayName?: string): string {
  const payload: AuthTokenPayload = {
    sub: user.id,
    email: user.username,
    name:
      normalizeDisplayName(displayName) || displayNameFromEmail(user.username),
    exp: Math.floor(Date.now() / 1000) + tokenTtlSeconds,
  };
  const encodedPayload = base64UrlEncode(JSON.stringify(payload));
  const signature = sign(encodedPayload);
  return `${encodedPayload}.${signature}`;
}

export function verifyAuthToken(token: string): AuthTokenPayload | undefined {
  const [encodedPayload, signature] = token.split(".");

  if (!encodedPayload || !signature) {
    return undefined;
  }

  const expectedSignature = sign(encodedPayload);
  const signatureBuffer = Buffer.from(signature);
  const expectedSignatureBuffer = Buffer.from(expectedSignature);

  if (
    signatureBuffer.length !== expectedSignatureBuffer.length ||
    !crypto.timingSafeEqual(signatureBuffer, expectedSignatureBuffer)
  ) {
    return undefined;
  }

  let decoded: AuthTokenPayload;
  try {
    decoded = JSON.parse(base64UrlDecode(encodedPayload)) as AuthTokenPayload;
  } catch {
    return undefined;
  }

  if (
    !decoded.sub ||
    !decoded.email ||
    decoded.exp < Math.floor(Date.now() / 1000)
  ) {
    return undefined;
  }

  return decoded;
}

export function publicUser(user: User, displayName?: string) {
  return {
    id: user.id,
    name:
      normalizeDisplayName(displayName) || displayNameFromEmail(user.username),
    email: user.username,
  };
}

function normalizeDisplayName(name: string | undefined): string {
  return name?.trim() ?? "";
}

function displayNameFromEmail(email: string): string {
  const [localPart] = email.split("@");
  return localPart || email;
}

function sign(value: string): string {
  return crypto
    .createHmac("sha256", authSecret())
    .update(value)
    .digest("base64url");
}

function authSecret(): string {
  const secret = process.env.AUTH_SECRET || process.env.SESSION_SECRET;

  if (secret) {
    return secret;
  }

  if (process.env.NODE_ENV === "production") {
    throw new Error("AUTH_SECRET must be set in production");
  }

  return "compasscare-local-development-auth-secret";
}

function base64UrlEncode(value: string): string {
  return Buffer.from(value).toString("base64url");
}

function base64UrlDecode(value: string): string {
  return Buffer.from(value, "base64url").toString("utf8");
}
