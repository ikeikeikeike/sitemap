defmodule ExSitemapGenerator.State do

  defmacro __using__(_opts) do
    quote do

      def start_link do
        Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
      end

      def state, do: Agent.get(__MODULE__, &(&1))

      def finalize_state do
        Agent.update(__MODULE__, fn _ ->
          %__MODULE__{}
        end)
      end

      def add_state(key, xml) do
        Agent.update(__MODULE__, fn s ->
          Map.update!(s, key, &(&1 <> xml))
        end)
      end

      def update_state(key, xml) do
        Agent.update(__MODULE__, fn s ->
          Map.update!(s, key, fn _ -> xml end)
        end)
      end

      def incr_state(key), do: incr_state(key, 1)
      def incr_state(key, number) do
        Agent.update(__MODULE__, fn s ->
          Map.update!(s, key, &(&1 + number))
        end)
      end

    end
  end
end
