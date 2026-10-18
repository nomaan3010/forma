# FORMA Tap Card Studio — zero-budget starter

A mobile-first NFC digital business card system for a small operator with 25 NTAG216 cards. It includes an admin dashboard, client-specific login view, client profile CRUD, image uploads, public mini profile pages, public share link, QR PNG download, and a downloadable vCard contact file. Built with static HTML/CSS/JS + Supabase. No paid framework required.

## Important honest note
This is a **starter MVP**, not an audited enterprise SaaS. Public card pages intentionally expose the contact fields you choose to publish. Do not put private notes, passwords, payment details, or identity documents into client profile fields. Test with a dummy profile before selling. Public profile view is read-only; only the admin edits profiles in this starter. Client login can see their linked profile/link. Password reset, email verification workflows, billing, analytics, audit logs, custom domains, and automated client self-editing are not included yet.

## What you need
- A computer with a browser and internet.
- A free Supabase account/project: https://supabase.com
- Free static hosting, e.g. https://www.netlify.com or https://vercel.com
- Your 25 blank NFC NTAG216 cards and an NFC-writing app on an NFC-capable phone.
- Optional: a phone photo/logo from each customer.

## Setup (about 30–60 minutes if nothing goes wrong)
1. Create a Supabase project. Keep the database password safe.
2. In Supabase open **SQL Editor → New query**, paste the entire `supabase.sql`, and run it.
3. In Supabase open **Project Settings → API** (or API Keys). Copy the Project URL and the **publishable/anon key**. Never use the `service_role` or secret key in browser code.
4. Open `app.js` in a text editor. Replace:
   - `PASTE_SUPABASE_PROJECT_URL` with the Project URL
   - `PASTE_SUPABASE_ANON_KEY` with the publishable/anon key
5. Create your admin login: Supabase → Authentication → Users → Add user. Enter your email and a strong password. Confirm the user if the dashboard offers that option.
6. Copy that user's UUID. In SQL Editor run:
   ```sql
   insert into public.profiles (id, role)
   values ('PASTE-YOUR-AUTH-USER-UUID-HERE','admin')
   on conflict (id) do update set role='admin';
   ```
7. Deploy: easiest is drag the whole `tapcard-studio` folder to Netlify Drop if available, or create a GitHub repository and import it into Netlify/Vercel. Make sure `index.html`, `style.css`, and `app.js` sit at the published root. Use the resulting HTTPS URL.
8. Open the deployed URL and sign in as admin. Create a test profile and check the public card link in an incognito/private browser window.
9. Only after tests pass, create real client profiles and program the NFC card.

## Create a client login (optional portal)
1. In Supabase → Authentication → Users → Add user, create their email/password. For a customer, invite them and set a temporary password they change with you present; don't send passwords in plain text.
2. Copy the auth user's UUID.
3. Run in SQL Editor, replacing values:
   ```sql
   insert into public.profiles (id, role)
   values ('CLIENT-AUTH-USER-UUID','client')
   on conflict (id) do update set role='client';
   update public.clients set user_id='CLIENT-AUTH-USER-UUID' where slug='client-slug';
   ```
4. They sign in at the same site and can see their linked profile. Admin and client data are separated with row-level security.

## NFC programming
1. Install a reputable NFC writer app (for example NFC Tools) on an NFC-capable Android phone or compatible iPhone.
2. In admin, select a client → **Link / QR** → copy the public profile URL.
3. In the NFC app choose Write / Add a record / URL (URL/URI record), paste the HTTPS profile URL, then tap **Write** and hold the card still against the phone's NFC antenna until success.
4. Read-test it with a second phone. Make sure the link opens without logging in.
5. Print a QR code if desired. The downloaded QR PNG is a digital file; for physical printing use a professional printer and verify the QR scans before handing it over.
6. Keep the NFC tag URL as the stable profile slug. You can change the person's name, role, phone, services, photo, etc. later in admin without reprogramming the card. If you change the slug, the old NFC URL will stop working.

## Client intake form (copy this checklist)
Required:
- Full name exactly as it should appear
- Job title / designation
- Business name or brand
- Phone number and WhatsApp number (with country code)
- Email (confirm spelling)
- Profile photo or company logo (get permission to publish it)
- One-sentence introduction / value proposition
- 3–5 services or areas of expertise
- Website and social links (only the ones they want public)
- City / business address (optional)
- Booking link (optional)
- Approval of the preview and all public contact details

Ask whether they already have a logo/headshot and website. If no website, this profile is their small mobile landing page. If they have a website, link to it. Never ask for passwords to their social accounts. Obtain written approval before publishing photos/contact information.

## Starter service & pricing (India)
For your first few customers, sell the **outcome**, not the blank plastic:
- **Founding client offer: ₹999 one-time** — one programmed NTAG216 card, premium mobile profile, photo/logo, save-contact button, call/WhatsApp/email buttons, QR code, one round of edits, and setup help. Clearly state any future hosting/support fees before payment.
- After 2–3 testimonials: test ₹1,499–₹1,999 one-time with 30 days of small text edits included.
- Optional care plan: ₹99–₹199/month for edits/support only if you can reliably provide it. Do not promise permanent hosting at zero budget.
- If client wants 5+ cards, quote separately based on your actual card cost, time, printing, and delivery.
Prices are suggested experiments, not a guarantee that nobody will bargain. Competitors vary significantly; don't claim competitors cost more without current verified quotes. A clean premium demo and reliable follow-up beat fake comparisons.

## Sell one today: simple plan
1. Make one demo profile for yourself or a fictional sample clearly labelled “Demo” (never publish a real person's data without permission).
2. Test every button, QR, NFC write, contact save, and mobile layout.
3. Pick one nearby decision-maker: consultant, real-estate agent, salon owner, photographer, gym trainer, architect, boutique, or small agency.
4. Lead with a 20-second demo on your phone: tap the card, show the profile, click Save contact, then edit one field live and reload to show it updates without replacing the card.
5. Ask for the sale directly: “I can set up your card today for ₹999, including the NFC card, profile page, QR, and contact-save button. You approve the details before it goes live. Shall I make yours?”
6. Collect payment before custom setup if appropriate, provide a receipt, and get written approval for public info.
7. Keep your offer honest: don't guarantee sales, claim certifications you don't have, or imply the card itself stores all the profile data. The NFC tag stores a link; the profile lives online.

## Design / printing recommendation
Keep all 25 cards visually identical. White glossy card: front only, matte-black or deep charcoal typography, tiny champagne-gold accent, ample whitespace. Avoid trying to print the QR too small or placing essential details only on the card.
Suggested front:
- FORMA (or your chosen brand) / DIGITAL IDENTITY
- “Tap. Connect. Remember.”
- Small NFC contactless icon
- “Tap or scan to connect”
Do not print a customer's details on your reusable stock cards. If you want to sell under your own brand, print the same studio identity on all cards; if selling unbranded cards, use a minimal “TAP TO CONNECT” mark. Glossy surfaces can make QR scanning reflective; keep QR on a matte sticker or use the QR on screen instead. Confirm your card dimensions and printer safe area before ordering.

## Known limitations / production checklist
- Uses third-party CDNs for Supabase JS, QR generation and fonts. Requires internet.
- Profile image bucket is public by design, because published pages need to display images.
- The admin can edit/delete profile data. The admin dashboard's public link depends on the site being deployed at a stable URL.
- Current MVP uses public slug URLs; don't use sequential personal IDs or sensitive data in slugs.
- Client portal does not include self-service profile editing. For the first sale, you can operate it manually from admin.
- Before scaling: custom domain, backup/export, privacy notice, terms, consent capture, password reset, rate limits, audit logs, error monitoring, image cleanup on replacement/deletion, analytics, automated client onboarding, and a security review.
