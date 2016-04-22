defmodule ExSitemapGenerator.State do

  defmacro state do
    Agent.get(__MODULE__, &(&1))
  end

  defmacro finalize_state do
    quote do
      Agent.update(__MODULE__, fn _ ->
        %__MODULE__{}
      end)
    end
  end

  defmacro add_state(key, xml) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, &(&1 <> xml))
    end)
  end

  defmacro update_state(key, xml) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, fn _ -> xml end)
    end)
  end

  defmacro incr_state(key) do
    quote do
      incr_state(unquote(key), 1)
    end
  end
  defmacro incr_state(key, number) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, &(&1 + number))
    end)
  end

end
