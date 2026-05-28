defmodule Booking.BookingsTest do
  use Booking.DataCase, async: true

  alias Booking.Bookings

  describe "create_booking/1" do
    test "creates a booking with valid attributes" do
      attrs = valid_attrs()

      assert {:ok, booking} = Bookings.create_booking(attrs)
      assert booking.room_name == "Oak"
      assert booking.user_email == "alice@example.com"
    end

    test "requires room_name, user_email, start_at, end_at" do
      assert {:error, changeset} = Bookings.create_booking(%{})

      errors = errors_on(changeset)
      assert errors[:room_name] == ["can't be blank"]
      assert errors[:user_email] == ["can't be blank"]
      assert errors[:start_at] == ["can't be blank"]
      assert errors[:end_at] == ["can't be blank"]
    end

    test "rejects end_at not after start_at" do
      attrs = %{valid_attrs() | end_at: valid_attrs().start_at}

      assert {:error, changeset} = Bookings.create_booking(attrs)
      assert errors_on(changeset)[:end_at] == ["must be after start"]
    end
  end

  describe "list_bookings_on/1" do
    test "returns bookings for the given date, ordered by start_at" do
      {:ok, _b2} = Bookings.create_booking(valid_attrs(hour: 14))
      {:ok, _b1} = Bookings.create_booking(valid_attrs(hour: 9))

      bookings = Bookings.list_bookings_on(today())

      assert Enum.map(bookings, & &1.start_at.hour) == [9, 14]
    end
  end

  defp today, do: Date.utc_today()

  defp valid_attrs(opts \\ []) do
    hour = Keyword.get(opts, :hour, 10)
    {:ok, start_at} = DateTime.new(today(), Time.new!(hour, 0, 0), "Etc/UTC")
    end_at = DateTime.add(start_at, 1, :hour)

    %{
      room_name: "Oak",
      user_email: "alice@example.com",
      start_at: start_at,
      end_at: end_at
    }
  end
end
