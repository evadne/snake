defmodule SnakeData.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def up do
    create table(:games, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:status, :nonempty_string, null: false)
      add(:score, :integer, null: false, default: 0)
      add(:board_width, :integer, null: false)
      add(:board_height, :integer, null: false)
      add(:board_snapshot, :binary, null: false)
      timestamps()
    end
  end
  
  def down do
    drop table(:games)
  end
end
