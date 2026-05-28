defmodule BookingWeb.BookingLive do
  use BookingWeb, :live_view

  alias Booking.Bookings
  alias Booking.Bookings.Booking

  @impl true
  def mount(_params, _session, socket) do
    today = Date.utc_today()

    socket =
      socket
      |> assign(:date, today)
      |> assign(:form, to_form(Bookings.change_booking(%Booking{})))
      |> stream(:bookings, Bookings.list_bookings_on(today))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"booking" => params}, socket) do
    changeset =
      %Booking{}
      |> Bookings.change_booking(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"booking" => params}, socket) do
    case Bookings.create_booking(params) do
      {:ok, booking} ->
        socket =
          socket
          |> stream_insert(:bookings, booking)
          |> assign(:form, to_form(Bookings.change_booking(%Booking{})))
          |> put_flash(:info, "Booking created")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    booking = Bookings.get_booking!(id)
    {:ok, _} = Bookings.delete_booking(booking)
    {:noreply, stream_delete(socket, :bookings, booking)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Bookings for {Calendar.strftime(@date, "%A, %B %-d, %Y")}
        <:subtitle>Room bookings (UTC)</:subtitle>
      </.header>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mt-6">
        <section>
          <h2 class="text-base font-semibold mb-3">Today's bookings</h2>

          <div id="bookings" phx-update="stream" class="space-y-2">
            <div
              :for={{dom_id, b} <- @streams.bookings}
              id={dom_id}
              class="rounded border border-base-300 p-3 flex items-start justify-between gap-3"
            >
              <div>
                <div class="font-medium">{b.room_name}</div>
                <div class="text-sm text-base-content/70">
                  {format_time(b.start_at)} – {format_time(b.end_at)}
                </div>
                <div class="text-sm text-base-content/70">{b.user_email}</div>
              </div>
              <button
                type="button"
                class="btn btn-xs btn-ghost"
                phx-click="delete"
                phx-value-id={b.id}
                data-confirm="Delete this booking?"
              >
                Delete
              </button>
            </div>
          </div>
        </section>

        <section>
          <h2 class="text-base font-semibold mb-3">New booking</h2>

          <.form for={@form} phx-change="validate" phx-submit="create" class="space-y-3">
            <.input field={@form[:room_name]} type="text" label="Room" placeholder="e.g. Oak" />
            <.input field={@form[:user_email]} type="email" label="Email" />
            <.input field={@form[:start_at]} type="datetime-local" label="Start" />
            <.input field={@form[:end_at]} type="datetime-local" label="End" />

            <.button type="submit" variant="primary">Create booking</.button>
          </.form>
        </section>
      </div>
    </Layouts.app>
    """
  end

  defp format_time(%DateTime{} = dt), do: Calendar.strftime(dt, "%H:%M")
end
