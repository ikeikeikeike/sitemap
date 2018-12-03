defmodule Sitemap.Namer do
  alias Sitemap.Config
  alias Sitemap.NameError

  use Sitemap.State,
    ext: ".xml.gz",
    zero: nil,
    start: 1,
    count: nil

  def to_string(name) do
    s = state(name)
    "#{Config.get().filename}#{s.count}#{s.ext}"
  end

  def reset(name) do
    update_state(name, :count, state(name).zero)
  end

  def start?(name) do
    s = state(name)
    s.count == s.zero
  end

  def next(name) do
    if start?(name) do
      update_state(name, :count, state(name).start)
    else
      incr_state(name, :count)
    end
  end

  def previous!(name) do
    if start?(name),
      do:
        raise(NameError,
          message: "Already at the start of the series"
        )

    s = state(name)

    if s.count <= s.start do
      update_state(name, :count, state(name).zero)
    else
      decr_state(name, :count)
    end
  end
end
