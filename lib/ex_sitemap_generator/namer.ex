defmodule ExSitemapGenerator.Namer do

  defstruct [
    base: "",
    ext: ".xml.gz",
    zero: nil,
    start: 1,
    count: nil,
  ]

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def state, do: Agent.get(__MODULE__, &(&1))

  def to_string do
    s = state
    "#{s.base}#{s.count}#{s.ext}"
  end

  def reset do
    # update_state :count, state.zero
  end

  def start? do
    s = state
    s.count == s.zero
  end

end
