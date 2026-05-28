defmodule Booking.Bookings do
  @moduledoc """
  The Bookings context.
  """

  import Ecto.Query

  alias Booking.Repo
  alias Booking.Bookings.Booking

  def list_bookings_on(%Date{} = date) do
    {:ok, day_start} = DateTime.new(date, ~T[00:00:00], "Etc/UTC")
    day_end = DateTime.add(day_start, 1, :day)

    Booking
    |> where([b], b.start_at >= ^day_start and b.start_at < ^day_end)
    |> order_by([b], asc: b.start_at)
    |> Repo.all()
  end

  def get_booking!(id), do: Repo.get!(Booking, id)

  def create_booking(attrs) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def delete_booking(%Booking{} = booking), do: Repo.delete(booking)

  def change_booking(%Booking{} = booking, attrs \\ %{}) do
    Booking.changeset(booking, attrs)
  end
end
