defmodule Snake.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "games" do
    field :status, :string, default: "pending"
    field :score, :integer, default: 0
    field :board_width, :integer
    field :board_height, :integer
    field :board_snapshot, :binary
    timestamps()
  end

  def create_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, ~w(status score board_width board_height board_snapshot)a)
    |> validate_required(~w(status score board_width board_height board_snapshot)a)
  end

  def update_changeset(game, attrs \\ %{}) do
    game
    |> cast(attrs, ~w(status score board_snapshot)a)
    |> validate_required(~w(status score board_snapshot)a)
  end
end
