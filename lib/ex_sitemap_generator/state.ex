defmodule ExSitemapGenerator.State do

  defmacro __using__(_opts) do
    quote do

      defp namepid(name),
        do: String.to_atom(Enum.join([__MODULE__, name]))

      def start_link, do: start_link("", [])
      def start_link(opts) when is_list(opts), do: start_link("", [])
      def start_link(name), do: start_link(name, [])
      def start_link(name, opts) do
        Agent.start_link(fn -> struct(__MODULE__, opts) end, name: namepid(name))
      end

      def state, do: state("")
      def state(name), do: Agent.get(namepid(name), &(&1))

      def finalize_state, do: finalize_state("")
      def finalize_state(name) do
        Agent.update(namepid(name), fn _ ->
          %__MODULE__{}
        end)
      end

      def add_state(key, xml), do: add_state("", key, xml)
      def add_state(name, key, xml) do
        Agent.update(namepid(name), fn s ->
          Map.update!(s, key, &(&1 <> xml))
        end)
      end

      def update_state(key, xml), do: update_state("", key, xml)
      def update_state(name, key, xml) do
        Agent.update(namepid(name), fn s ->
          Map.update!(s, key, fn _ -> xml end)
        end)
      end

      def incr_state(key), do: incr_state("", key, 1)
      def incr_state(key, number) when is_number(number), do: incr_state("", key, number)
      def incr_state(name, key), do: incr_state(name, key, 1)
      def incr_state(name, key, number) do
        Agent.update(namepid(name), fn s ->
          Map.update!(s, key, &((&1 || 0) + number))
        end)
      end

      def decr_state(key), do: decr_state("", key, 1)
      def decr_state(key, number) when is_number(number), do: decr_state("", key, 1)
      def decr_state(name, key), do: decr_state(name, key, 1)
      def decr_state(name, key, number) do
        Agent.update(namepid(name), fn s ->
          Map.update!(s, key, &((&1 || 0) - number))
        end)
      end

    end
  end
end
