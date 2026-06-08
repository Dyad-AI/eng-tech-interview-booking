alias Booking.Bookings

today = Date.utc_today()

at = fn h, m ->
  {:ok, dt} = DateTime.new(today, Time.new!(h, m, 0), "Etc/UTC")
  dt
end

# Note: the 11:00 Maple booking overlaps the 12:00 one — kept on purpose for the demo data.
bookings = [
  %{room_name: "Oak",   user_email: "alice@example.com", start_at: at.(9, 0),   end_at: at.(10, 0)},
  %{room_name: "Oak",   user_email: "bob@example.com",   start_at: at.(10, 0),  end_at: at.(11, 0)},
  %{room_name: "Maple", user_email: "carol@example.com", start_at: at.(11, 0),  end_at: at.(12, 30)},
  %{room_name: "Maple", user_email: "dan@example.com",   start_at: at.(12, 0),  end_at: at.(13, 0)},
  %{room_name: "Birch", user_email: "erin@example.com",  start_at: at.(14, 0),  end_at: at.(15, 0)},
  %{room_name: "Birch", user_email: "frank@example.com", start_at: at.(15, 30), end_at: at.(16, 30)}
]

Enum.each(bookings, fn attrs ->
  {:ok, _} = Bookings.create_booking(attrs)
end)

IO.puts("Seeded #{length(bookings)} bookings for #{today}")
