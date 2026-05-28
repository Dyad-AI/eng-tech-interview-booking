defmodule Booking.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :room_name, :string
    field :user_email, :string
    field :start_at, :utc_datetime
    field :end_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @required ~w(room_name user_email start_at end_at)a

  def changeset(booking, attrs) do
    booking
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_length(:room_name, min: 1, max: 100)
    |> validate_length(:user_email, min: 3, max: 200)
    |> validate_end_after_start()
  end

  defp validate_end_after_start(changeset) do
    start_at = get_field(changeset, :start_at)
    end_at = get_field(changeset, :end_at)

    if start_at && end_at && DateTime.compare(end_at, start_at) != :gt do
      add_error(changeset, :end_at, "must be after start")
    else
      changeset
    end
  end
end
