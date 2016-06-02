defmodule Sitemap.Builders.Url do
  alias Sitemap.Funcs
  alias Sitemap.Config
  import XmlBuilder

  def to_xml(link, attrs \\ []) do
    elms =
      element(:url, Funcs.eraser([
        element(:loc,         Path.join(Config.get.host, link || "")),
        element(:lastmod,     Keyword.get_lazy(attrs, :lastmod, fn -> Funcs.iso8601 end)),
        element(:expires,     attrs[:expires]),
        element(:changefreq,  attrs[:changefreq]),
        element(:priority,    attrs[:priority]),
      ]))

    if attrs[:mobile],     do: elms = append_last(elms, mobile())
    if attrs[:geo],        do: elms = append_last(elms, geo(attrs[:geo]))
    if attrs[:news],       do: elms = append_last(elms, news(attrs[:news]))
    if attrs[:pagemap],    do: elms = append_last(elms, pagemap(attrs[:pagemap]))
    if attrs[:images],     do: elms = append_last(elms, images([attrs[:images]]))
    if attrs[:videos],     do: elms = append_last(elms, videos([attrs[:videos]]))
    if attrs[:alternates], do: elms = append_last(elms, alternates([attrs[:alternates]]))

    elms
  end

  defp append_last(elements, element) do
    combine = elem(elements, 2) ++ [element]

    elements
    |> Tuple.delete_at(2)
    |> Tuple.append(combine)
  end

  defp news(data) do
    element(:"news:news", Funcs.eraser([
      element(:"news:publication", Funcs.eraser([
        element(:"news:name",             data[:publication_name]),
        element(:"news:language",         data[:publication_language]),
      ])),
      element(:"news:title",              data[:title]),
      element(:"news:access",             data[:access]),
      element(:"news:genres",             data[:genres]),
      element(:"news:keywords",           data[:keywords]),
      element(:"news:stock_tickers",      data[:stock_tickers]),
      element(:"news:publication_date",   data[:publication_date]),
    ]))
  end

  defp images(list, elements \\ [])
  defp images([], elements), do: elements
  defp images([data|tail], elements) do
    elm =
      element(:"image:image", Funcs.eraser([
        element(:"image:loc", data[:loc]),
        (unless is_nil(data[:title]), do: element(:"image:title", data[:title])),
        (unless is_nil(data[:license]), do: element(:"image:license", data[:license])),
        (unless is_nil(data[:caption]), do: element(:"image:caption", data[:caption])),
        (unless is_nil(data[:geo_location]), do: element(:"image:geo_location", data[:geo_location])),
      ]))

    images(tail, elements ++ [elm])
  end

  defp videos(list, elements \\ [])
  defp videos([], elements), do: elements
  defp videos([data|tail], elements) do
    elm =
      element(:"video:video", Funcs.eraser([
        element(:"video:title",           data[:title]),
        element(:"video:description",     data[:description]),
        (if data[:player_loc] do
          attrs = %{allow_embed: Funcs.yes_no(data[:allow_embed])}
          if data[:autoplay], do: attrs = Map.put(attrs, :autoplay, Funcs.autoplay(data[:autoplay]))
          element(:"video:player_loc", attrs, data[:player_loc])
        end),
        element(:"video:content_loc",     data[:content_loc]),
        element(:"video:thumbnail_loc",   data[:thumbnail_loc]),
        element(:"video:duration",        data[:duration]),

        (unless is_nil(data[:gallery_loc]),      do: element(:"video:gallery_loc", %{title: data[:gallery_title]}, data[:gallery_loc])),
        (unless is_nil(data[:rating]),           do: element(:"video:rating", data[:rating])),
        (unless is_nil(data[:view_count]),       do: element(:"video:view_count", data[:view_count])),
        (unless is_nil(data[:expiration_date]),  do: element(:"video:expiration_date", data[:expiration_date])),  # TODO: gonna be convinient
        (unless is_nil(data[:publication_date]), do: element(:"video:publication_date", data[:publication_date])), # TODO: gonna be convinient
        (unless is_nil(data[:tags]),             do: Enum.map(data[:tags] || [], &(element(:"video:tag", &1)))),
        (unless is_nil(data[:tag]),              do: element(:"video:tag", data[:tag])),
        (unless is_nil(data[:category]),         do: element(:"video:category", data[:category])),
        (unless is_nil(data[:family_friendly]),  do: element(:"video:family_friendly", Funcs.yes_no(data[:family_friendly]))),
        (unless is_nil(data[:restriction]) do
          attrs = %{relationship: Funcs.allow_deny(data[:relationship])}
          element(:"video:restriction", attrs, data[:restriction])
        end),
        (unless is_nil(data[:uploader]) do
          attrs = %{}
          if data[:uploader_info], do: attrs = %{info: data[:uploader_info]}
          element(:"video:uploader", attrs, data[:uploader])
        end),
        (unless is_nil(data[:price]), do: element(:"video:price", video_price_attrs(data), data[:price])),
        (unless is_nil(data[:live]),  do: element(:"video:live", Funcs.yes_no(data[:live]))),
        (unless is_nil(data[:requires_subscription]), do: element(:"video:requires_subscription", Funcs.yes_no(data[:requires_subscription]))),
      ]))

    videos(tail, elements ++ [elm])
  end

  defp video_price_attrs(data) do
    attrs = %{}
    attrs = Map.put attrs, :currency, data[:price_currency]
    if data[:price_type], do: attrs = Map.put attrs, :type, data[:price_type]
    if data[:price_type], do: attrs = Map.put attrs, :resolution, data[:price_resolution]
    attrs
  end

  defp alternates(list, elements \\ [])
  defp alternates([], elements), do: elements
  defp alternates([data|tail], elements) do
    rel = if data[:nofollow], do: "alternate nofollow", else: "alternate"

    attrs = %{rel: rel, href: data[:href]}
    attrs = Map.put attrs, :hreflang, data[:lang]
    attrs = Map.put attrs, :media, data[:media]

    alternates(tail, elements ++ [element(:"xhtml:link", attrs)])
  end

  defp geo(data) do
    element(:"geo:geo", [
      element(:"geo:format", data[:format])
    ])
  end

  defp mobile do
    element(:"mobile:mobile")
  end

  defp pagemap(data) do
    element(:PageMap, Enum.map(data[:dataobjects] || [], fn(obj) ->
      element(:DataObject, %{type: obj[:type], id: obj[:id]}, Enum.map(obj[:attributes] || [], fn(attr) ->
        element(:Attribute, %{name: attr[:name]}, attr[:value])
      end))
    end))
  end

end
