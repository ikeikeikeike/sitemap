defmodule ExSitemapGenerator.Namer do
  alias ExSitemapGenerator.NameError

  defstruct [
    base: "",
    ext: ".xml.gz",
    zero: nil,
    start: 1,
    count: nil,
  ]

  use ExSitemapGenerator.State

  def init, do: start_link

  def to_string do
    s = state
    "#{s.base}#{s.count}#{s.ext}"
  end

  def reset do
    update_state :count, state.zero
  end

  def start? do
    s = state
    s.count == s.zero
  end

  def next do
    if start? do
      update_state :count, state.start
    else
      incr_state :count
    end
  end

  def previous! do
    if start?, do: raise NameError,
        message: "Already at the start of the series"

    s = state
    if s.count <= s.start do
      update_state :count, state.zero
    else
      decr_state :count
    end
  end

end
