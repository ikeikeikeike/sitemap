defmodule ExSitemapGenerator.Builders.Indexfile do
  alias ExSitemapGenerator.Consts
  alias ExSitemapGenerator.Builders.File, as: FileBuilder
  alias ExSitemapGenerator.Builders.Indexurl
  alias ExSitemapGenerator.Location
  require XmlBuilder

  defstruct [
    content: "",
    link_count: 0,
    total_count: 0,
  ]

  use ExSitemapGenerator.State

  def init do
    start_link
  end

  def add(options \\ []) do
    FileBuilder.write

    content =
      Indexurl.to_xml(Location.url(:file), options)
      |> XmlBuilder.generate

    add_state :content, content
    incr_state :link_count
    incr_state :total_count, FileBuilder.state.link_count
  end

  def write do
    s = state
    content = Consts.xml_idxheader <> s.content <> Consts.xml_idxfooter
    Location.write :indexfile, content, s.link_count
  end

end
