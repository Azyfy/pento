defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

 # alias Pento.Accounts

  @numbers_to_guess 1..10

  def mount(_params, session, socket) do
   # user = Accounts.get_user_by_session_token(session["user_token"])
    random_number = Enum.random(@numbers_to_guess)

    {:ok, assign(
                  socket,
                  score: 0,
                  message: "Make a guess:",
                  guess_number: random_number,
                  numbers_to_guess: @numbers_to_guess,
                  win: false,
                  time: time(),
                  session_id: session["live_socket_id"]
                #  current_user: user
                )}
  end

  def render(assigns) do
    ~H"""
      <h1>Your score: <%= @score %></h1>
      <p>
        It's <%= @time %>
      </p>
      <h2>
        <%= @message %>
      </h2>
      <h2>
        <%= for n <- @numbers_to_guess do %>
          <a href="#" phx-click="guess" phx-value-number={n} ><%= n %></a>
        <% end %>
        <pre>
          <%= @current_user.email %>
          <%= @session_id %>
        </pre>
      </h2>
      <%= if @win do%>
        <button phx-click="reset" > Reset </button>
      <% end %>
    """
  end

  def handle_event("guess", %{"number" => guess}=_data, socket) do
    guess = guess |> String.to_integer()
    check = guess == socket.assigns.guess_number
    random_number = Enum.random(@numbers_to_guess)

    message = if check
                do
                  "Your guess: #{guess}. Correct. You win."
                else
                  "Your guess: #{guess}. Wrong. Guess again."
                end
    score = if check
                do
                  socket.assigns.score + 1
                else
                  socket.assigns.score - 1
                end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        guess_number: random_number,
        win: check == true,
        time: time()
      )
    }
  end

  def handle_event("reset", _, socket) do
    {
      :noreply,
      assign(
        socket,
        score: 0,
        message: "Game reset. Your guess:",
        guess_number: Enum.random(@numbers_to_guess),
        win: false,
        time: time()
      )
    }
  end

  def time() do
    DateTime.utc_now |> to_string
  end


end
