defmodule Booking.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :room_name, :string, null: false
      add :user_email, :string, null: false
      add :start_at, :utc_datetime, null: false
      add :end_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:bookings, [:room_name, :start_at])
  end
end
