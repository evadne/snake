defmodule SnakeData.Repo.Migrations.SetupFunctions do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION public.utc_now()
      RETURNS timestamp AS $$
        SELECT now() AT TIME ZONE 'utc';
      $$ LANGUAGE sql;
    """
    
    execute """
      CREATE OR REPLACE FUNCTION public.assign_inserted_at()
      RETURNS TRIGGER AS $$
      BEGIN
        NEW.inserted_at = utc_now();
        NEW.updated_at = utc_now();
        RETURN NEW;
      END;
      $$ language 'plpgsql';
    """
    
    execute """
      CREATE OR REPLACE FUNCTION public.assign_updated_at()
      RETURNS TRIGGER AS $$
      BEGIN
        NEW.updated_at = utc_now();
        RETURN NEW;	
      END;
      $$ language 'plpgsql';
    """
    
    execute """
      CREATE OR REPLACE FUNCTION public.array_distinct_sort(ANYARRAY)
      RETURNS ANYARRAY LANGUAGE SQL IMMUTABLE AS $$
        SELECT ARRAY(SELECT DISTINCT UNNEST($1) x ORDER BY x ASC);
      $$
    """
    
    execute """
      CREATE OR REPLACE FUNCTION public.raise_mutation_exception()
      RETURNS TRIGGER AS $$
      BEGIN
        RAISE EXCEPTION 'Can not update protected column(s).';
      END;
      $$ language 'plpgsql';
    """
  end

  def down do
    execute "DROP FUNCTION public.raise_mutation_exception();"
    execute "DROP FUNCTION public.array_distinct_sort(ANYARRAY);"
    execute "DROP FUNCTION public.assign_updated_at();"
    execute "DROP FUNCTION public.assign_inserted_at();"
    execute "DROP FUNCTION public.utc_now();"
  end
end
