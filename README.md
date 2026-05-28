# Booking

A small Phoenix LiveView app for booking rooms in a co-working space. You'll
work in this codebase during your live interview.

## What's here

- `Booking.Bookings` — context for managing bookings
- `Booking.Bookings.Booking` — the `bookings` schema (room, user email, start, end)
- `BookingWeb.BookingLive` — single LiveView at `/` listing today's bookings and
  a form to create new ones

## Before the interview (~15 min)

Just get the app running on your machine and click around. Don't change anything.

### Requirements

- Elixir 1.18+, Erlang/OTP 27+
- PostgreSQL running locally (default credentials: `postgres`/`postgres` on
  `localhost:5432`)

If your Postgres credentials differ, edit `config/dev.exs` and `config/test.exs`.

### Setup

```bash
mix setup           # installs deps, creates DB, migrates, seeds
mix phx.server      # boots the app on http://localhost:4000
```

`mix setup` should leave you with 6 seeded bookings for today across 3 rooms
(Oak, Maple, Birch).

### Verify

- Open http://localhost:4000 — you should see today's bookings and a form
- Run `mix test` — all tests should pass

If anything is broken, ping the interviewer ahead of the session so we don't
burn live time on setup.

## During the interview

We'll work on this codebase together. The interviewer will play the role of
someone bringing you a feature request, and you'll pair on it. Bring your own
editor and shell — work how you normally would. Think out loud where you can.
