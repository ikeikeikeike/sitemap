defmodule Sitemap.Builders.Indexfile do
  alias Sitemap.Consts
  alias Sitemap.Builders.File, as: FileBuilder
  alias Sitemap.Builders.Indexurl
  alias Sitemap.Location
  require XmlBuilder

  use Sitemap.State, [
    content: "",
    link_count: 0,
    total_count: 0,
  ]

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
    s = state()
    content = Consts.xml_idxheader <> s.content <> Consts.xml_idxfooter
    Location.write :indexfile, content, s.link_count
  end

end
